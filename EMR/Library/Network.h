//
//  Network.h
//  bulcuhk
//
//  Created by Wenly on 12. 11. 8..
//  Copyright (c) 2012년 MangoApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Macro.h"

//#import "ModelObjects.h"

#define StringEncoding NSUTF8StringEncoding // 4
//#define StringEncoding -2147481280 // 한글 - euc-kr

#define HOST_URL_TEST @""

#define HOST_URL_DEV @"" // 개발서버
// 203.149.223.88:8080 웹
// 203.149.223.88:8082 모바일
#define HOST_URL @"" // 실서버 ( 로컬서버 )
#define HOST_URL_CAMERA @"" // 카메라 서버
#define HOST_URL_WEB @""

#define HOST_SOCKET @""
#define HOST_SOCKET_PORT 10005

#define HOST_SOCKET_DEV @""
#define HOST_SOCKET_PORT_DEV 40005


#define SSID @"SPACESOFT"

@interface NSDictionary (NSDictionary_Extensions)

- (id)stringForKey:(id)aKey;

@end

@interface Network : NSObject<NSURLConnectionDelegate,NSStreamDelegate>{
    BOOL alertLock;
    BOOL b_isContinueActivity;
    
    BOOL sendingSocket;
    
}

+(Network *) manager;

@property (nonatomic, retain) NSString *hostURL;
@property (nonatomic, retain) NSString *socketIP;
@property (nonatomic, assign) int socketPort;
@property (nonatomic, assign) NSInputStream *inputStream;
@property (nonatomic, assign) NSOutputStream *outputStream;
@property (nonatomic, retain) NSString *socketInterfaceIDCurrent;
@property (nonatomic, assign) id socketSender;
@property (nonatomic, retain) NSValue *socketFinishedSelector;
@property (nonatomic, retain) NSValue *socketFailedSelector;

- (void)releaseAlertLock;

//-(NSDictionary *)dictionaryWithResultForSynchFullPath:(NSString *)apiPath dictionary:(NSDictionary*)dictionary;
//-(NSDictionary *)dictionaryWithResultForSynch:(NSString *)apiPath dictionary:(NSDictionary*)dictionary;
@property (nonatomic, retain) UIView *g_vActivityMain;
@property (nonatomic, retain) UIActivityIndicatorView *g_activity;
-(void)showBlackLayer:(UIView *)vFrame;
-(void)closeBlackLayer;

-(void)showBlackLayer:(UIView *)vFrame animated:(BOOL)animated;
-(void)closeBlackLayer:(BOOL)animate;
-(void)showActivityContine:(BOOL)isContinue;
-(void)closeActivityKill:(BOOL)isKill;
-(void)showActivityType;
-(void)closeActivityType;


-(void)requestAPIGet:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary;
- (void)requestAPIGet:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)requestAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary;
- (void)requestAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

//- (void)requestWithURL:(NSURL*)url dictionary:(NSDictionary*)dictionary name:(NSString*)name sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

//-(id)objectFromServerAPI:(NSString *)apiPath postDictionary:(NSDictionary*)dictionar;

//-(NSDictionary*)dictionaryFromServerAPI:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary;

-(NSDictionary *)requestAPISyncGet:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary;
-(id)requestAPISyncPost:(NSString *)apiPath postDictionary:(NSDictionary*)dictionary;

- (NSString*)jsonStringFromObject:(id)object;

- (id)objectFromJsonString:(NSString*)jsonString;

- (void)requestAPIGet:(NSString*)apiPath urlString:(NSString*)urlString sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (id)getSSID;

- (void) initSocketCommunication ;

- (void)requestSocketWithDatas:(NSArray*)datas interfaceID:(NSString*)interfaceID sender:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (NSString *)encodeURIComponent:(NSString *)string;

- (void)requestStringAPI:(NSString*)apiPath postDictionary:(NSDictionary*)dictionary delegate:(id)sender finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)setHostDev;

- (void)setHostNormal;

- (BOOL)isNull:(id)object;

- (BOOL)uploadData:(NSData*)data withFilename:(NSString*)filename toURLString:(NSString*)urlString;

- (NSData*)downloadFileFromAPIPath:(NSString*)api filename:(NSString*)filename;
- (NSData*)downloadFileFromURL:(NSString*)urlString toFilename:(NSString*)filename;

@end


