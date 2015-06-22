//
//  AES.h
//  MKeeper
//
//  Created by Wenly on 13. 9. 3..
//  Copyright (c) 2013년 Harusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

+(NSString*)encryptAES:(NSString*)string;
+(NSString*)decryptAES:(NSString*)string;

@end
