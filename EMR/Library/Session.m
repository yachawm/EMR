//
//  sessionTon.m
//  studysessionton
//
//  Created by Wenly on 2014. 08. 04..
//  Copyright (c) 2014년 Wenly. All rights reserved.
//

#import "Session.h"
#import "Network.h"
#import "Coredata.h"

@implementation Session

#define ALERT_TAG_APNS_DETAIL 100
#define ALERT_TAG_LOGIN_CONFIRM 101

static Session *session= nil;


+(Session *)manager
{
    @synchronized([Session class]) // 오직 하나의 쓰레드만 접근할 수 있도록 함.
    {
        
        if(session==nil)
        {
            
            session = [[self alloc] init];
            if (nil != session) {
                
            }
        }
    }
    return session;
    
}

- (id)init
{
    if((self = [super init]) )// 초기화 선언부분
    {
        [self load];
        
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [self performSelector:@selector(didSessionLoaded) withObject:nil afterDelay:0.1];
        
    }
    return self;
}

- (void)didSessionLoaded{

}


/**
 * @brief 모든 메모리 데이터를 영구 저장한다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)save{
//    [[NSUserDefaults standardUserDefaults]setObject:self.pushToken forKey:@"pushToken"];
//    [[NSUserDefaults standardUserDefaults]setBool:self.autoLogin forKey:@"autoLogin"];
    
    [self.appDelegate saveContext];
}


/**
 * @brief 영구 저장된 데이터를 메모리로 불러온다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)load{
//    self.pushToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"pushToken"];
//    self.autoLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"autoLogin"];
}


- (void)alertMessage:(NSString*)message autoClose:(BOOL)autoClose{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(closeAlert:) withObject:alert afterDelay:4];
}

- (void)closeAlert:(UIAlertView*)alert{
    [alert dismissWithClickedButtonIndex:1 animated:YES];
    alert = nil;
}




@end
