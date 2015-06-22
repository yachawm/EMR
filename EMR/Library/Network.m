//
//  Network.m
//  bulcuhk
//
//  Created by Wenly on 12. 11. 8..
//  Copyright (c) 2012년 MangoApps. All rights reserved.
//

#import "Network.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "ModalAlert.h"
#import "Session.h"
#import "DataProvider.h"
#import "XMLReader.h"

@implementation NSDictionary (NSDictionary_Extensions)

- (id)stringForKey:(id)aKey{
    if([[self objectForKey:aKey] isKindOfClass:[NSNull class]] || [self valueForKey:aKey]==nil){
        return @"";
    }
    return [NSString stringWithFormat:@"%@",[self objectForKey:aKey]];
    
}



@end

@implementation Network

@synthesize g_activity, g_vActivityMain;

static Network *network= nil;

+(Network *)manager
{
    @synchronized([Network class]) // 오직 하나의 쓰레드만 접근할 수 있도록 함.
    {
        
        if(network==nil)
        {
            
            network = [[self alloc] init];
            if (nil != network) {
                
            }
        }
    }
    return network;
    
}

- (id)init
{
    if((self = [super init])) // 초기화 선언부분
    {
        [self initActivityType];
        //        if ([[Session manager]isTestAccount]){
        //            [self setHostDev];
        //        }
        //        else{
        //            [self setHostNormal];
        //        }
        [self setHostDev];
    }
    
    return self;
}

- (void)setHostDev{
    self.socketIP = HOST_SOCKET_DEV;
    self.socketPort = HOST_SOCKET_PORT_DEV;
    self.hostURL = HOST_URL_DEV;
    NSLog(@"setHostDev");
}

- (void)setHostNormal{
    self.socketIP = HOST_SOCKET;
    self.socketPort = HOST_SOCKET_PORT;
    self.hostURL = HOST_URL;
    NSLog(@"setHostNormal");
}

- (id)getSSID
{
#if !TARGET_IPHONE_SIMULATOR
    //    CFArrayRef myArray = CNCopySupportedInterfaces();
    //    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    //    NSLog(@"Connected at:%@",myDict);
    //    NSDictionary *myDictionary = (__bridge NSDictionary*)myDict;
    //    NSString * ssid = [myDictionary objectForKey:@"SSID"];
    //    NSLog(@"ssid is %@",ssid);
    //    return ssid;
#else
    return @"SPACESOFT";
#endif
    return @"SPACESOFT";
}


- (void) initSocketCommunication {
    
    NSLog(@"initSocketCommunication");
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.socketIP, self.socketPort, &readStream, &writeStream);
    
    
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
    
}

- (void) sendMessage {
    
    //	NSString *response  = [NSString stringWithFormat:@"LOS001;%@", inputMessageField.text];
    //    NSLog(@"write string = %@",response);
    //	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    //	[outputStream write:[data bytes] maxLength:[data length]];
    //	inputMessageField.text = @"";
    
}


- (void)requestSocketWithDatas:(NSArray*)datas interfaceID:(NSString*)interfaceID sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    if(sendingSocket)return;
    
    [self initSocketCommunication];
    
    self.socketInterfaceIDCurrent = nil;
    self.socketInterfaceIDCurrent = interfaceID;
    
    self.socketSender = nil;
    self.socketSender = sender;
    
    self.socketFinishedSelector = nil;
    self.socketFinishedSelector = [NSValue valueWithPointer:finishedSelector];
    
    self.socketFailedSelector = nil;
    self.socketFailedSelector = [NSValue valueWithPointer:failedSelector];
    
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
        if (string.length==0) {
            [string appendString:[NSString stringWithFormat:@"%@",data]];
        }
        else{
            [string appendString:[NSString stringWithFormat:@";%@",data]];
        }
    }
    
    NSLog(@"requestSocket full String = %@",string);
    
    NSData *data = [[NSData alloc] initWithData:[string dataUsingEncoding:StringEncoding]];
    [self showActivityType];
    sendingSocket = YES;
    [_outputStream write:[data bytes] maxLength:[data length]];
    //[data release];
    
    
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %i", streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
            if (theStream == _inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:StringEncoding];
                        
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
            //NSLog(@"theStream.retainCount = %lu",(unsigned long)theStream.retainCount);
            //[theStream release];
            theStream = nil;
            sendingSocket = NO;
            
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            //NSLog(@"theStream.retainCount = %lu",(unsigned long)theStream.retainCount);
            //[theStream release];
            theStream = nil;
            sendingSocket = NO;
            break;
        default:
            NSLog(@"Unknown event");
    }
    
    //self.inputStream = nil;
    //self.outputStream = nil;
    
    [self closeActivityType];
}

/**
 * @brief 서버API 주소를 호출하여 데이터를 비동기 송수신한다.
 * @param (NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector
 * @return nil
 * @author Chang-hyeok Yang
 */
- (void)requestAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    
    NSString *encodedURLString = [self encodeURIComponent:[NSString stringWithFormat:@"%@/%@",self.hostURL,apiPath] ];
    
    [self requestWithURL:[NSURL URLWithString:encodedURLString]  dictionary:dictionary name:apiPath sender:sender finishedSelector:finishedSelector failedSelector:failedSelector];
    
}


- (void)requestStringAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    
    NSString *encodedURLString = [self encodeURIComponent:[NSString stringWithFormat:@"%@/%@",self.hostURL,apiPath] ];
    
    [self requestStringWithURL:[NSURL URLWithString:encodedURLString]  dictionary:dictionary name:apiPath sender:sender finishedSelector:finishedSelector failedSelector:failedSelector];
    
}


- (void)requestAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary{
    [self requestAPI:apiPath postDictionary:dictionary delegate:nil finishedSelector:nil failedSelector:nil];
}


- (void)requestStringAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary{
    [self requestStringAPI:apiPath postDictionary:dictionary delegate:nil finishedSelector:nil failedSelector:nil];
}


- (void)requestWithURL:(NSURL*)url dictionary:(NSDictionary*)dictionary name:(NSString*)name sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSError *error = nil;
    
    [request setError:error];
    
    //    [request setDefaultResponseEncoding:StringEncoding];
    //    [request setResponseEncoding:StringEncoding];
    //    [request setStringEncoding:StringEncoding];
    [request setDefaultResponseEncoding:StringEncoding];
    [request setResponseEncoding:StringEncoding];
    [request setStringEncoding:StringEncoding];
    [request setRequestMethod:@"POST"];
    for (NSString *key in dictionary) {
        [request addPostValue:[dictionary valueForKey:key] forKey:key];
    }
    
    [request setUsername:name];
    if (sender!=nil) {
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                              sender,@"sender",
                              [NSValue valueWithPointer:finishedSelector],@"finish",
                              [NSValue valueWithPointer:failedSelector],@"fail",
                              nil]
         ];
    }
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    
    [request startAsynchronous];
    //[request release];
    
    [self showActivityType];
}

/**
 * @brief 서버API 주소를 호출하여 POST 비동기 송수신한다. String 값을 그대로 받아온다.
 * @param (NSURL*)url dictionary:(NSDictionary*)dictionary name:(NSString*)name sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector
 * @return nil
 * @author Chang-hyeok Yang
 */
- (void)requestStringWithURL:(NSURL*)url dictionary:(NSDictionary*)dictionary name:(NSString*)name sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSError *error = nil;
    
    [request setError:error];
    
    [request setDefaultResponseEncoding:StringEncoding];
    [request setResponseEncoding:StringEncoding];
    [request setStringEncoding:StringEncoding];
    [request setRequestMethod:@"POST"];
    for (NSString *key in dictionary) {
        [request addPostValue:[dictionary valueForKey:key] forKey:key];
    }
    
    [request setUsername:name];
    if (sender!=nil) {
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                              sender,@"sender",
                              [NSValue valueWithPointer:finishedSelector],@"finish",
                              [NSValue valueWithPointer:failedSelector],@"fail",
                              nil]
         ];
    }
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestStringFinished:)];
    [request setDidFailSelector:@selector(requestStringFailed:)];
    
    [request startAsynchronous];
    //[request release];
    
    [self showActivityType];
}

/**
 * @brief 서버API 주소를 호출하여 GET 데이터를 비동기 송수신한다.
 * @param (NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector
 * @return nil
 * @author Chang-hyeok Yang
 */

- (void)requestAPIGet:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    NSMutableString *requestString = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",self.hostURL,apiPath]];
    int paramCount = 0;
    for (NSString *key in dictionary) {
        
        if (paramCount>0) {
            [requestString appendString:@"&"];
        }
        else{
            [requestString appendString:@"?"];
        }
        [requestString appendString:[NSString stringWithFormat:@"%@=%@",key,[dictionary valueForKey:key]]];
        paramCount++;
    }
    
    
    //    if (paramCount>0) {
    //        [requestString appendString:@"&"];
    //    }
    //    else{
    //        [requestString appendString:@"?"];
    //    }
    //    [requestString appendString:[NSString stringWithFormat:@"%@=%@",@"CTNO",[[[Session manager]selectedPatient] registNumber]]];
    //    paramCount++;
    
    
    
    NSURL *url = [NSURL URLWithString:[self encodeURIComponent:requestString]];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSLog(@"request.url = %@",request.url);
    
    //[request setDefaultResponseEncoding:StringEncoding];
    //[request setResponseEncoding:StringEncoding];
    [request setDefaultResponseEncoding:StringEncoding];
    [request setResponseEncoding:StringEncoding];
    [request setStringEncoding:StringEncoding];
    [request setRequestMethod:@"GET"];
    for (NSString *key in dictionary) {
        [request addPostValue:[dictionary valueForKey:key] forKey:key];
    }
    
    //[request addPostValue:[[[Session manager]selectedPatient] registNumber] forKey:@"CTNO"];
    
    [request setUsername:apiPath];
    if (sender!=nil) {
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                              sender,@"sender",
                              [NSValue valueWithPointer:finishedSelector],@"finish",
                              [NSValue valueWithPointer:failedSelector],@"fail",
                              nil]
         ];
    }
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
    
    [self showActivityType];
}





- (void)requestAPIGet:(NSString*)apiPath urlString:(NSString*)urlString sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector{
    
    NSMutableString *requestString = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",self.hostURL,urlString]];
    
    NSURL *url = [NSURL URLWithString:[self encodeURIComponent:requestString]];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSLog(@"request.url = %@",request.url);
    
    NSError *error = nil;
    
    [request setDefaultResponseEncoding:StringEncoding];
    [request setResponseEncoding:StringEncoding];
    [request setStringEncoding:StringEncoding];
    [request setRequestMethod:@"GET"];
    [request setError:error];
    //[request addPostValue:[[[Session manager]selectedPatient] registNumber] forKey:@"CTNO"];
    
    [request setUsername:apiPath];
    if (sender!=nil) {
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                              sender,@"sender",
                              [NSValue valueWithPointer:finishedSelector],@"finish",
                              [NSValue valueWithPointer:failedSelector],@"fail",
                              nil]
         ];
    }
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request startAsynchronous];
    //[request release];
    
    [self showActivityType];
}

/**
 * @brief 서버로부터 API 를 통하여 비동기 방식으로 GET 을 요청한다.
 * @param (NSString *)apiPath (NSDictionary*)dictionary
 * @return (NSDictionary *)
 * @author Chang-hyeok Yang
 * @section
 */
-(void)requestAPIGet:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary
{
    
    [self requestAPIGet:apiPath postDictionary:dictionary delegate:nil finishedSelector:nil failedSelector:nil];
    
}

/**
 * @brief 서버로부터 API 를 통하여 동기화방식으로 사전형 정보를 다운받는다.
 * @param (NSString *)apiPath (NSDictionary*)dictionary
 * @return (NSDictionary *)
 * @author Chang-hyeok Yang
 * @section
 */
-(id)requestAPISyncPost:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary
{
    
    [self showActivityContine:NO];
    
    NSString * strUrl = [NSString stringWithFormat:@"%@/%@",self.hostURL,apiPath];
    
    NSMutableString *requestString = [[NSMutableString alloc]initWithString:@""];
    
    int paramCount = 0;
    
    for (NSString *key in dictionary) {
        
        if (paramCount>0) {
            [requestString appendString:@"&"];
        }
        else{
            [requestString appendString:@""];
        }
        [requestString appendString:[NSString stringWithFormat:@"%@=%@",key,[dictionary valueForKey:key]]];
        paramCount++;
    }
    
    
    //    NSData *myRequestData = [ NSData dataWithBytes: [ requestString UTF8String ] length: [ requestString length ] ];
    
    NSData *myRequestData = [requestString dataUsingEncoding: StringEncoding];
    
    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: strUrl ] ];
    [ request setHTTPMethod: @"POST" ];
    [ request setValue:@"application/json, text/javascript" forHTTPHeaderField:@"Accept"];
    //[ request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Types"];
    
    [ request setHTTPBody: myRequestData ];
    
    NSURLResponse *response;
    NSError *err=nil;
    
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSLog(@"URLString = %@ / requestString = %@ ",strUrl,requestString);
    
    if(err!=nil){
        NSLog(@"Error = %@",[err description]);
    }
    
    [self closeActivityKill:YES];
    
    if(returnData == nil || [returnData isKindOfClass:[NSNull class]]){
        NSLog(@" returnData NULL error");
        return nil;
    }
    
    
    NSString *responseString = [[[NSString alloc] initWithData:returnData encoding:StringEncoding]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    //[WUtil alertMessage:responseString];
    // CR, LF 제거
    //NSString *removeCRLF = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //NSDictionary *responseDic = [removeCRLF JSONValue];
    //NSLog(@"%@", responseDic);
    
    //NSString *responseString = [NSString stringWithStringEncoding:[returnData bytes]];
    
    //NSLog(@"responseData: %@", responseString);
    
    
    
    NSLog(@"\n\n===================== request Start =============================================================:\n-Api명 %@\n-Parameters:\n%@\n-응답받은 문자열:\n%@\n\n\n",strUrl,requestString,responseString);
    NSLog(@"\n");
    
    if (responseString!=nil) {
        NSData *responseData = [responseString dataUsingEncoding:StringEncoding];
        NSError *error;
        //id data = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        id data = [XMLReader dictionaryForXMLString:responseString error:error];
        
        NSLog(@"\n파싱 결과\n%@\n===================== reqeust End =============================================================",data);
        return data;
        
    }else {
        
        [ModalAlert say:@"서버가 응답하지 않습니다. \n잠시 후 재요청 해주시길 바랍니다."];
        return nil;
        
    }
    
    return nil;
    
}

/**
 * @brief 서버로부터 API 를 통하여 동기화방식으로 사전형 정보를 다운받는다.
 * @param (NSString *)apiPath (NSDictionary*)dictionary
 * @return (NSDictionary *)
 * @author Chang-hyeok Yang
 * @section
 */
-(NSDictionary *)requestAPISyncGet:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary
{
    [self showActivityContine:NO];
    
    NSString * strUrl = [NSString stringWithFormat:@"%@/%@",self.hostURL,apiPath];
    
    NSMutableString *requestString = [[NSMutableString alloc]initWithString:strUrl];
    
    int paramCount = 0;
    
    for (NSString *key in dictionary) {
        
        if (paramCount>0) {
            [requestString appendString:@"&"];
        }
        else{
            [requestString appendString:@""];
        }
        [requestString appendString:[NSString stringWithFormat:@"%@=%@",key,[dictionary valueForKey:key]]];
        paramCount++;
    }
    
    
    //NSData *myRequestData = [ NSData dataWithBytes: [ requestString StringEncoding ] length: [ requestString length ] ];
    
    //NSData *myRequestData = [requestString dataUsingEncoding: StringEncoding];
    
    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: requestString ] ];
    [ request setHTTPMethod: @"GET" ];
    [ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type: text; charset=UTF-8"];
    //[ request setHTTPBody: myRequestData ];
    
    NSURLResponse *response;
    NSError *err;
    
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSLog(@"URLString = %@ / requestString = %@ ",strUrl,requestString);
    
    
    [self closeActivityKill:YES];
    
    if(returnData == nil || [returnData isKindOfClass:[NSNull class]]){
        NSLog(@" returnData NULL error");
        return nil;
    }
    
    
    NSString *responseString = [[[NSString alloc] initWithData:returnData encoding:StringEncoding]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    // CR, LF 제거
    //NSString *removeCRLF = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //NSDictionary *responseDic = [removeCRLF JSONValue];
    //NSLog(@"%@", responseDic);
    
    //NSString *responseString = [NSString stringWithStringEncoding:[returnData bytes]];
    
    //NSLog(@"responseData: %@", responseString);
    
    
    
    NSLog(@"\n\n===================== request Start =============================================================:\n-Api명 %@\n-Parameters:\n%@\n-응답받은 문자열:\n%@\n\n\n",strUrl,requestString,responseString);
    NSLog(@"\n");
    
    if (responseString!=nil) {
        //NSData *responseData = [responseString dataUsingEncoding:StringEncoding];
        NSError *error;
        //NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSDictionary *data = [XMLReader dictionaryForXMLString:responseString error:error];
        
        NSLog(@"\n파싱 결과\n%@\n===================== reqeust End =============================================================",data);
        return data;
        
    }else {
        
        [ModalAlert say:@"서버가 응답하지 않습니다. \n잠시 후 재요청 해주시길 바랍니다."];
        return nil;
        
    }
    
    return nil;
    
}


- (void)requestFinished:(id)sender{
    
    ASIFormDataRequest *request = sender;
    
    //    for (NSDictionary *dict in request.postData) {
    //        NSLog(@"value(%@) for key(%@)",[dict valueForKey:@"value"],[dict valueForKey:@"key"]);
    //    }
    
    //NSLog(@"request finished = %@, url = %@, response = %@", request.username,request.url, request.responseString);
    NSString *responseString = [[NSString alloc]initWithData:request.responseData encoding:StringEncoding];
    
    NSLog(@"\n\n===================== requestFinished =============================================================:\n-URL %@\n-Parameters:\n%@\n-응답받은 문자열:\n%@\n\n\n바이너리:%@",request.url,request.postData,responseString,request.responseData);
    
    
    
    //NSLog(@"responseString = %@",responseString);
    
    if (request.error!=nil) {
        NSLog(@"[request.error description] = %@",[request.error description]);
    }
    
    NSError *error = nil;
    
    if (request.responseData.length > 1){
        
        //NSString *filteredString = [self stringByRemovingControlCharacters:request.responseString];
        
        //NSString *responseString = [[[[[[NSString alloc] initWithData:request.responseData encoding:StringEncoding]autorelease]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        
        // StringEncoding 혹은 0x80000003
        //        NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:StringEncoding];
        //        // CR, LF 제거
        //        NSString *removeCRLF = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        //        NSDictionary *responseDic = [removeCRLF JSONValue];
        //        NSLog(@"%@", responseDic);
        
        
        NSString *responseString = [[[[[NSString alloc] initWithData:request.responseData encoding:StringEncoding]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSData *responseData = [responseString dataUsingEncoding:StringEncoding];
        
        NSDictionary *receivedDictionary = [XMLReader dictionaryForXMLString:responseString error:error];//[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        
        
        
        //NSDictionary *receivedDictionary = [request.responseString JSONValue];
        
        if(error != nil) {
            NSLog(@"NSJSONSerialization error = %@",[error description]);
        }
        
        id object = [[DataProvider manager]provideData:receivedDictionary ofAPI:request.username];
        
        SEL finishedSelector = [[request.userInfo objectForKey:@"finish"] pointerValue];
        SEL failedSelector = [[request.userInfo objectForKey:@"fail"] pointerValue];
        id delegate = [request.userInfo objectForKey:@"sender"];
        
        if(delegate!=nil){
            if(finishedSelector!=nil){
                [delegate performSelector:finishedSelector withObject:object];
            }
            if(failedSelector!=nil){
                [delegate performSelector:failedSelector withObject:object];
            }
        }
        
    }
    else{
        NSString *message = [NSString stringWithFormat:@"서버로부터 응답이 없습니다. 잠시 후 다시 시도하세요. [%@]",request.username];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alert show];
        //[alert release];
        
    }
    
    [self closeActivityType];
}



- (void)requestFailed:(id)sender{
    
    ASIFormDataRequest *requestFailed = sender;
    NSLog(@"request failed = %@, url = %@, response = %@", requestFailed.username,requestFailed.url, requestFailed.responseString);
    if ([[requestFailed.userInfo valueForKey:@"retryCount"] intValue]<2) {//통신이 실패하면 2번까지 재시도한다.
        
        NSURL *url = requestFailed.url;
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setResponseEncoding:requestFailed.responseEncoding];
        [request setDefaultResponseEncoding:requestFailed.defaultResponseEncoding];
        [request setStringEncoding:requestFailed.stringEncoding];
        [request setUsername:[requestFailed.username copy]];
        request.postData = [requestFailed.postData copy];
        request.fileData = [requestFailed.fileData copy];
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        for (NSString *key in request.userInfo) {
            [userInfo setObject:[request.userInfo objectForKey:key] forKey:key];
        }
        int retryCount = [[NSString stringWithFormat:@"%@",[requestFailed.userInfo valueForKey:@"retryCount"]] intValue];
        [userInfo setObject:[NSNumber numberWithInt:retryCount+1] forKey:@"retryCount"];
        
        [request setUserInfo:nil];
        [request setUserInfo:userInfo];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestFinished:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request startAsynchronous];
        //[request release];
    }
    else{//5번 이상 연속으로 실패하면 경고를 띄운다.
        
        if (alertLock == NO) {//경고가 최대 10초에 한번만 나오도록 조절.
            alertLock = YES;
            [self performSelector:@selector(releaseAlertLock) withObject:nil afterDelay:10];
            
            NSString *message = [NSString stringWithFormat:@"통신이 불안정하여 데이터 전송에 실패했습니다. 잠시 후 다시 시도하세요. [%@]",requestFailed.username];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alert show];
            //[alert release];
            
        }
        
        if ([requestFailed.username isEqualToString:@""]) {//통신 실패시 추가 처리 (옵션)
            
        }
        
        [self closeActivityType];
        
    }
    
}

- (void)requestStringFinished:(id)sender{
    
    ASIFormDataRequest *request = sender;
    
    //    for (NSDictionary *dict in request.postData) {
    //        NSLog(@"value(%@) for key(%@)",[dict valueForKey:@"value"],[dict valueForKey:@"key"]);
    //    }
    
    //    NSLog(@"request finished = %@, url = %@, response = %@", request.username,request.url, request.responseString);
    NSLog(@"\n\n===================== requestFinished =============================================================:\n-URL %@\n-Parameters:\n%@\n-응답받은 문자열:\n%@\n\n\n",request.url,request.postData,request.responseString);
    if (request.error!=nil) {
        NSLog(@"[request.error description] = %@",[request.error description]);
    }
    
    NSError *error = nil;
    
    if (request.responseString.length > 1){
        
        //NSString *filteredString = [self stringByRemovingControlCharacters:request.responseString];
        
        //NSString *responseString = [[[[[[NSString alloc] initWithData:request.responseData encoding:StringEncoding]autorelease]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        
        // StringEncoding 혹은 0x80000003
        //        NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:StringEncoding];
        //        // CR, LF 제거
        //        NSString *removeCRLF = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        //        NSDictionary *responseDic = [removeCRLF JSONValue];
        //        NSLog(@"%@", responseDic);
        
        
        NSString *responseString = [[[[[NSString alloc] initWithData:request.responseData encoding:StringEncoding]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]stringByReplacingOccurrencesOfString:@"\r" withString:@"|r|"] stringByReplacingOccurrencesOfString:@"\n" withString:@"|n|"];
        
        NSData *responseData = [responseString dataUsingEncoding:StringEncoding];
        
        NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        
        //NSDictionary *receivedDictionary = [request.responseString JSONValue];
        
        if(error != nil) {
            NSLog(@"NSJSONSerialization error = %@",[error description]);
        }
        
        id object = request.responseString;//[[DataProvider manager]provideData:receivedDictionary ofAPI:request.username];
        
        SEL finishedSelector = [[request.userInfo objectForKey:@"finish"] pointerValue];
        SEL failedSelector = [[request.userInfo objectForKey:@"fail"] pointerValue];
        id delegate = [request.userInfo objectForKey:@"sender"];
        
        if(delegate!=nil){
            if(finishedSelector!=nil){
                [delegate performSelector:finishedSelector withObject:object];
            }
            if(failedSelector!=nil){
                [delegate performSelector:failedSelector withObject:object];
            }
        }
        
    }
    else{
        NSString *message = [NSString stringWithFormat:@"서버로부터 응답이 없습니다. 잠시 후 다시 시도하세요. [%@]",request.username];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alert show];
        //[alert release];
        
    }
    
    [self closeActivityType];
    //    [[UIManager getSharedInstance] hideActivityIndicatorView];
}



- (void)requestStringFailed:(id)sender{
    
    ASIFormDataRequest *requestFailed = sender;
    NSLog(@"request failed = %@, url = %@, response = %@", requestFailed.username,requestFailed.url, requestFailed.responseString);
    if ([[requestFailed.userInfo valueForKey:@"retryCount"] intValue]<1) {//통신이 실패하면 5번까지 재시도한다.
        
        NSURL *url = requestFailed.url;
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setResponseEncoding:requestFailed.responseEncoding];
        [request setDefaultResponseEncoding:requestFailed.defaultResponseEncoding];
        [request setStringEncoding:requestFailed.stringEncoding];
        [request setUsername:requestFailed.username];
        request.postData = [requestFailed.postData copy];
        request.fileData = [requestFailed.fileData copy];
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        for (NSString *key in request.userInfo) {
            [userInfo setObject:[request.userInfo objectForKey:key] forKey:key];
        }
        int retryCount = [[NSString stringWithFormat:@"%@",[requestFailed.userInfo valueForKey:@"retryCount"]] intValue];
        [userInfo setObject:[NSNumber numberWithInt:retryCount+1] forKey:@"retryCount"];
        
        [request setUserInfo:userInfo];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestStringFinished:)];
        [request setDidFailSelector:@selector(requestStringFailed:)];
        [request startAsynchronous];
        //[request release];
    }
    else{//5번 이상 연속으로 실패하면 경고를 띄운다.
        
        if (alertLock == NO) {//경고가 최대 10초에 한번만 나오도록 조절.
            alertLock = YES;
            [self performSelector:@selector(releaseAlertLock) withObject:nil afterDelay:10];
            
            NSString *message = [NSString stringWithFormat:@"통신이 불안정하여 데이터 전송에 실패했습니다. 잠시 후 다시 시도하세요. [%@]",requestFailed.username];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alert show];
            //[alert release];
            
        }
        
        if ([requestFailed.username isEqualToString:@""]) {//통신 실패시 추가 처리 (옵션)
            
        }
        
        [self closeActivityType];
        
    }
    //    [[UIManager getSharedInstance] hideActivityIndicatorView];
}

- (void)releaseAlertLock{
    alertLock = NO;
}


#pragma mark indicator

/**
 * @brief initActivityType
 로딩 바람개비 초기화
 * @param none
 * @return non
 
 * @section
 */
-(void)initActivityType
{
    g_vActivityMain = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    g_vActivityMain.backgroundColor = [UIColor blackColor];
    g_vActivityMain.alpha=0.0;
    g_vActivityMain.userInteractionEnabled = NO;
    
    g_activity= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(142, 219, 37, 37)];
    g_activity.center = [[[[Session manager]appDelegate]window]center];
    g_activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [g_vActivityMain addSubview:g_activity];
    [g_activity stopAnimating];
    //    [g_activity release];
    g_vActivityMain.hidden = YES;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:g_vActivityMain];
    
}

/**
 * @brief showActivityType
 로딩 바람개비 보이기
 * @param none
 * @return non
 
 * @section
 */
-(void)showActivityType
{
    //    self.tabViewCon.g_v_tabbar.userInteractionEnabled  = NO;
    //    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
    
    //[appDelegate.window addSubview:g_vActivityMain];
    g_vActivityMain.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    g_vActivityMain.alpha = 0.3;
    [UIView commitAnimations];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [appDelegate.window bringSubviewToFront:g_vActivityMain];
    [g_activity startAnimating];
    
    
    
    //    [pool release];
}
/**
 * @brief closeActivityType
 로딩 바람개비 숨기기
 * @param none
 * @return non
 
 * @section
 */
-(void)closeActivityType
{
    //        self.tabViewCon.g_v_tabbar.userInteractionEnabled  = YES;
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.5];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //    [g_vActivityMain removeFromSuperview];
    g_vActivityMain.alpha = 0.0;
    //[UIView commitAnimations];
    
    [g_activity stopAnimating];
    g_vActivityMain.hidden = YES;
    b_isContinueActivity=NO;
    //[g_vActivityMain removeFromSuperview];
}

/**
 * @brief showActivityType
 로딩 바람개비 보이기
 * @param (UIView *)vFrame animated:(BOOL)animated
 * @return none
 
 * @section
 */
-(void)showBlackLayer:(UIView *)vFrame animated:(BOOL)animated
{
    //    self.tabViewCon.g_v_tabbar.userInteractionEnabled  = NO;
    //    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
    if (animated) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    }
    g_vActivityMain.alpha = 0.3;
    if (animated) {
        
        [UIView commitAnimations];
    }
    
    [vFrame addSubview:g_vActivityMain];
    [vFrame bringSubviewToFront:g_vActivityMain];
    
    
    g_vActivityMain.hidden = NO;
    
    //    [pool release];
}
/**
 * @brief closeActivityType
 로딩 바람개비 숨기기
 * @param (BOOL)animated
 * @return non
 
 * @section
 */
-(void)closeBlackLayer:(BOOL)animated
{
    //        self.tabViewCon.g_v_tabbar.userInteractionEnabled  = YES;
    if (animated) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    }
    //    [g_vActivityMain removeFromSuperview];
    g_vActivityMain.alpha = 0.0;
    if (animated) {
        
        [UIView commitAnimations];
    }
    
    [g_vActivityMain removeFromSuperview];
}


/**
 * @brief showActivityType
 로딩 바람개비 보이기
 * @param none
 * @return non
 
 * @section
 */
-(void)showBlackLayer:(UIView *)vFrame
{
    //    self.tabViewCon.g_v_tabbar.userInteractionEnabled  = NO;
    //    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    g_vActivityMain.alpha = 0.3;
    [UIView commitAnimations];
    
    [vFrame addSubview:g_vActivityMain];
    [vFrame bringSubviewToFront:g_vActivityMain];
    
    
    g_vActivityMain.hidden = NO;
    
    //    [pool release];
}
/**
 * @brief closeActivityType
 로딩 바람개비 숨기기
 * @param none
 * @return non
 
 * @section
 */
-(void)closeBlackLayer
{
    //        self.tabViewCon.g_v_tabbar.userInteractionEnabled  = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //    [g_vActivityMain removeFromSuperview];
    g_vActivityMain.alpha = 0.0;
    [UIView commitAnimations];
    
    [g_vActivityMain removeFromSuperview];
}

/**
 * @brief showActivity
 로딩 바람개비 보이기 : 외부에서 접근시
 쓰레드 새로 생성
 * @param none
 * @return non
 
 * @section
 */
-(void)showActivityContine:(BOOL)isContinue
{
    
    NSLog(@"isContinue:%d",isContinue);
    if (isContinue) {
        b_isContinueActivity= isContinue;
    }
    
    //    [AppSession sharedApp].s_bLoading = YES;
    if ( g_activity.isAnimating) {
        
        NSLog(@"애니메이션 ing");
        return;
    }
    [self performSelectorInBackground:@selector(showActivityType) withObject:nil];
    
}

/**
 * @brief closeActivityType
 로딩 바람개비 숨기기
 쓰레드 새로 생성
 * @param none
 * @return non
 
 * @section
 */
-(void)closeActivityKill:(BOOL)isKill
{
    //    [AppSession sharedApp].s_bLoading = NO;
    NSLog(@"isKill:%d,isAnimating:%d,b_isContinueActivity:%d",isKill,g_activity.isAnimating,b_isContinueActivity);
    if (isKill) {
        //        NSLog(@"isKill");
        [self performSelectorInBackground:@selector(closeActivityType) withObject:nil];
    }
    
    if (!g_activity.isAnimating)
        return;
    if (b_isContinueActivity) {
        return;
    }
    
    NSLog(@"애니메이션 stop");
    [self performSelectorInBackground:@selector(closeActivityType) withObject:nil];
    
}

/**
 * @brief NSDictionary 혹은 NSArray 객체를 JSON String 으로 반환
 * @param (id)object
 * @return (NSString*)
 * @author Chang-hyeok Yang
 * @section
 */
- (NSString*)jsonStringFromObject:(id)object{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:StringEncoding];
    
}

- (id)objectFromJsonString:(NSString*)jsonString{
    id result = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: StringEncoding] options:kNilOptions error:nil];
    return result;
}


- (NSString *)encodeURIComponent:(NSString *)string
{
    NSString *s = [string stringByAddingPercentEscapesUsingEncoding:StringEncoding];
    return s;
}

- (NSString *)decodeURIComponent:(NSString *)string
{
    NSString *s = [string stringByReplacingPercentEscapesUsingEncoding:StringEncoding];
    return s;
}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}


/**
 * @brief Null 값인지 확인
 * @param (id)object
 * @return (BOOL)YES:Null  NO:Not Null
 * @author Chang-hyeok Yang
 */
- (BOOL)isNull:(id)object{
    if (object==nil || [object isKindOfClass:[NSNull class]]){
        return YES;
    }
    return NO;
}



- (BOOL)uploadData:(NSData*)data withFilename:(NSString*)filename toURLString:(NSString*)urlString{
    
    //    NSString *urlString = @"http://yourserver.com/upload.php";
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json, text/javascript, */*; q=0.01" forHTTPHeaderField:@"Accept"];
    
    //    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Types"];
    
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    //[postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:data]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    NSError *error = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    //[request release];
    
    
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"data upload result = %@", returnString);
    
    if(error){
        NSLog(@"error = %@",[error description]);
    }
    
    
    return NO;
}


/**
 * @brief 파일을 API 로부터 다운로드 받은 후 특정 파일명으로 저장한다.
 * @param APIPath:(NSString*)api toFilename:(NSString*)filename
 * @return (NSData*)responseData
 * @author Chang-hyeok Yang
 */
- (NSData*)uploadData:(NSData*)data toAPI:(NSString*)api toFilename:(NSString*)filename withParameters:(NSDictionary*)parameters{
    
    //    [self showActivityContine:NO];
    //
    //    NSString *urlString = [NSString stringWithFormat:@"%@/%@?filename=%@",HOST_URL,api,filename];
    //    //attblno=111&seq=1
    //
    //    NSURL *url = [NSURL URLWithString:[self encodeURIComponent:urlString]];
    //    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    //
    //    [request addFile:data withFileName:[NSString stringWithFormat:@"%@_%@.png",@"myimage",attbdlno] andContentType:@"multipart/form-data" forKey:@"file"];
    //    [request addPostValue:attbdlno forKey:@"attbdlno"]; // 파일 묶음 번호
    //
    //    [request setDelegate:self];
    //    [request setDidFinishSelector:@selector(fileUploaded:)];
    //    [request setDidFailSelector:@selector(fileUploadFailed:)];
    //
    //    [request setStringEncoding:NSUTF8StringEncoding];
    //    [request startAsynchronous];
    //
    //    NSLog(@"url = %@, request.responseString = %@",urlString,request.responseString);
    //
    //    if (error!=nil) {
    //        NSLog(@"downloadFileFromAPIPath error = %@",[request.error description]);
    //    }
    //
    //    [self closeActivityKill:YES];
    //
    //    return request.responseData;
    return nil;
}

- (NSData*)downloadFileFromURL:(NSString*)urlString toFilename:(NSString*)filename{
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    NSError *error = nil;
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // Add your filename to the directory to create your saved pdf location
    NSString *pdfLocation = [documentDirectory stringByAppendingPathComponent:filename];
    
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // Add your filename to the directory to create your temp pdf location
    NSString *tempPdfLocation = [cachesDirectory stringByAppendingPathComponent:filename];
    
    [request setError:error];
    [request setTemporaryFileDownloadPath:tempPdfLocation];
    [request setDownloadDestinationPath:pdfLocation];
    [request startSynchronous];
    
    NSLog(@"request.responseString = %@",request.responseString);
    
    if (error!=nil) {
        NSLog(@"downloadFileFromAPIPath error = %@",[request.error description]);
    }
    else{
        NSLog(@"download complete, byte = %lu",(unsigned long)[request.responseData length]);
    }
    
    NSLog(@"urlString = %@",urlString);
    
    return request.responseData;
}



@end