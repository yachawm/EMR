//
//  Socket.m
//  HanHeartCard
//
//  Created by Wenly on 2014. 8. 8..
//  Copyright (c) 2014년 (주)SpaceSoft. All rights reserved.
//

#import "Socket.h"
#import "Network.h"
#import "DataProvider.h"

@implementation Socket



- (void) initSocketCommunication {
    
    NSLog(@"initSocketCommunication");
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)[[Network manager]socketIP], [[Network manager]socketPort], &readStream, &writeStream);
    
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
    
}

- (void)requestSocketWithDatas:(NSArray*)datas interfaceID:(NSString*)interfaceID sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    NSMutableString *string = [[NSMutableString alloc]init];
    if (interfaceID!=nil) {
        [string appendString:interfaceID];
    }
    
    //    if ([[Session manager]isTestAccount]) {
    //        [string appendString:@";DENTALTEST01"];
    //    }
    //    else{
    //        [string appendString:[NSString stringWithFormat:@";%@",SSID]];
    //    }
    
    for(NSString *data in datas){
        //if (string.length==0) {
        [string appendString:[NSString stringWithFormat:@"%@;",data]];
        //        }
        //        else{
        //            [string appendString:[NSString stringWithFormat:@";%@",data]];
        //        }
    }
    
    
    if(sendingSocket){
        NSLog(@"still sending socket! ignore this socket = %@",string);
        return;
    }
    
    [self initSocketCommunication];
    
    self.socketInterfaceIDCurrent = nil;
    self.socketInterfaceIDCurrent = interfaceID;
    
    self.socketSender = nil;
    self.socketSender = sender;
    
    self.socketFinishedSelector = nil;
    self.socketFinishedSelector = [NSValue valueWithPointer:finishedSelector];
    
    self.socketFailedSelector = nil;
    self.socketFailedSelector = [NSValue valueWithPointer:failedSelector];
    
    NSLog(@"requestSocket full String = %@",string);
    
    NSData *data = [[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    //[[Network manager] showActivityType];
    sendingSocket = YES;
    [self performSelectorInBackground:@selector(writeDataToSocket:) withObject:data];
    
    //[data release];
    
    
    
    //[theStream close];
    //    [_inputStream close];
    //    [_outputStream close];
    //    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //    ////NSLog(@"theStream.retainCount = %lu",(unsigned long)theStream.retainCount);
    //
    //    [[Network manager]releaseSocketWithIdentifier:self.identifier];
}

- (void)requestSocketWithString:(NSString*)string interfaceID:(NSString*)interfaceID sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    if(sendingSocket){
        NSLog(@"still sending socket! ignore this socket = %@",string);
        return;
    }
    
    [self initSocketCommunication];
    
    self.socketInterfaceIDCurrent = nil;
    self.socketInterfaceIDCurrent = interfaceID;
    
    self.socketSender = nil;
    self.socketSender = sender;
    
    self.socketFinishedSelector = nil;
    self.socketFinishedSelector = [NSValue valueWithPointer:finishedSelector];
    
    self.socketFailedSelector = nil;
    self.socketFailedSelector = [NSValue valueWithPointer:failedSelector];
    
    NSLog(@"requestSocket full String = %@",string);
    
    NSData *data = [[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]] ;
    //[[Network manager] showActivityType];
    sendingSocket = YES;
    [self performSelectorInBackground:@selector(writeDataToSocket:) withObject:data];
    
    
}

- (void)writeDataToSocket:(NSData*)data{
    @autoreleasepool {
        [_outputStream write:[data bytes] maxLength:[data length]];
        //[data release];
    }
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    //    if(streamEvent==nil)return;
    //
    NSLog(@"stream event %i", streamEvent);
    //
    
    if (theStream.streamError!=nil) {
        NSLog(@"[_inputStream.streamError description] = %@",[theStream.streamError description]);
    }
    
    NSLog(@"theStream.streamStatus= %d",theStream.streamStatus);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            //sendingSocket = YES;
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
            if (theStream == _inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output) {
                            
                            NSLog(@"server said: %@", output);
                            
                            NSArray *datas = [output componentsSeparatedByString:@";"];
                            
                            id object = [[DataProvider manager]provideData:datas ofAPI:self.socketInterfaceIDCurrent];
                            
                            SEL finishedSelector = [self.socketFinishedSelector pointerValue];
                            SEL failedSelector = [self.socketFailedSelector pointerValue];
                            id delegate = self.socketSender;
                            
                            if(delegate!=nil){
                                if(finishedSelector!=nil){
                                    [delegate performSelector:finishedSelector withObject:object];
                                }
                                if(failedSelector!=nil){
                                    [delegate performSelector:failedSelector withObject:object];
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            break;
            
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            ////NSLog(@"theStream.retainCount = %lu",(unsigned long)theStream.retainCount);
            
            sendingSocket = NO;
            
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            //[theStream close];
            //[theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_inputStream close];
            [_outputStream close];
            [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            ////NSLog(@"theStream.retainCount = %lu",(unsigned long)theStream.retainCount);
            //[theStream release];
            //theStream = nil;
            sendingSocket = NO;
            //[[Network manager]releaseSocketWithIdentifier:self.identifier];
            break;
        default:
            NSLog(@"Unknown event");
            
            
            sendingSocket = NO;
    }
    
    //self.inputStream = nil;
    //self.outputStream = nil;
    
    [[Network manager] closeActivityType];
//    [[[Network manager] sockets] removeObject:self];
    //[self autorelease];
}




-(void)dealloc{
    self.socketFailedSelector = nil;
    self.socketFinishedSelector = nil;
    self.socketInterfaceIDCurrent = nil;
}

@end
