//
//  NSData+AES.h
//  MKeeper
//
//  Created by Wenly on 13. 9. 3..
//  Copyright (c) 2013년 Harusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData(AES)
- (NSData*)AES128Decrypt;
- (NSData*)AES128Encrypt;
@end
