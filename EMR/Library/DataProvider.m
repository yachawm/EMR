//
//  NetworkProvider.m
//  YUMC-R
//
//  Created by Wenly on 2014. 2. 20..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import "DataProvider.h"
#import "Network.h"
#import "Session.h"
#import "ModalAlert.h"

#import "WUtil.h"

//#import "ModelObjects.h"


@implementation DataProvider

static DataProvider *singleTone= nil;

+(DataProvider *)manager
{
    @synchronized([DataProvider class]) // 오직 하나의 쓰레드만 접근할 수 있도록 함.
    {
        if(singleTone==nil)
        {
            singleTone = [[self alloc] init];
            if (nil != singleTone) {
                
            }
        }
    }
    return singleTone;
    
}

- (id)init
{
	if((self = [super init]))// 초기화 선언부분
	{
        
    }
	
	return self;
}

- (id)provideData:(id)data ofAPI:(NSString*)api{
    NSLog(@"api[%@] provideData = %@",api,data);
    
    return data;
    
    NSArray *originalDatas = data;
    
    if (originalDatas==nil) {
        return nil;
    }
    
    NSString *resultCode = [originalDatas objectAtIndex:0];
    NSString *resultMessage = [originalDatas objectAtIndex:1];
    
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    
    for(int i = 2 ; i < originalDatas.count ; i++){
        NSString *string = [originalDatas objectAtIndex:i];
        [datas addObject:string];
    }
    
    if([resultCode integerValue]==100){
        if([api isEqualToString:@"LOS001"]){// 추가 처리 (옵션)
            
        }
        else if([api isEqualToString:@""]){
            
        }
    }
    else{
        if([api isEqualToString:@"LOS001"]){// 추가 처리 (옵션)
//            if([[Session manager]isTestAccount]){
//                return data;
//            }
        }
        else if([api isEqualToString:@"ABS001"]){// 추가 처리 (옵션)
            return data;
        }
        [WUtil alertMessage:resultMessage];
    }
    
    return data;
}

- (id)eccFilteredString:(id)object{
    if ([object isKindOfClass:[NSString class]]) {
        NSString *string = object;
        return [[string stringByReplacingOccurrencesOfString:@"|r|" withString:@"\n"] stringByReplacingOccurrencesOfString:@"|n|" withString:@"\n"];
    }
    return object;
}

@end