//
//  Socket.h
//  HanHeartCard
//
//  Created by Wenly on 2014. 8. 8..
//  Copyright (c) 2014년 (주)SpaceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket : NSObject <NSURLConnectionDelegate,NSStreamDelegate>{
    BOOL sendingSocket;
}


@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) NSString *socketInterfaceIDCurrent;
@property (nonatomic, assign) id socketSender;
@property (nonatomic, retain) NSValue *socketFinishedSelector;
@property (nonatomic, retain) NSValue *socketFailedSelector;
@property (nonatomic, assign) int identifier;

- (void)requestSocketWithDatas:(NSArray*)datas interfaceID:(NSString*)interfaceID sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)requestSocketWithString:(NSString*)string interfaceID:(NSString*)interfaceID sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

@end
