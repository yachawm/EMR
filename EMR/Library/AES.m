//
//  AES.m
//  MKeeper
//
//  Created by Wenly on 13. 9. 3..
//  Copyright (c) 2013년 Harusoft. All rights reserved.
//

#import "AES.h"
#import "NSData+AES.h"

@implementation AES

//- (void)testActuallyEncrypting:(NSString *)hexString
//{
//    NSLog(@"Encrypted HexString : %@",hexString);
//    
//    NSData *data = [self dataFromHexString:hexString];
//    NSData *encryptedData =  [NSData dataWithBytes:[data bytes] length:[data length]];
//    NSData *decryptedData = [encryptedData AES128Decrypt];
//    NSString *decryptedString = [NSString stringWithUTF8String:[decryptedData bytes]];
//    NSLog(@"Decrypted String : %@",decryptedString);
//    
//    decryptedString = [self addPaddingToString:decryptedString];
//    decryptedData = [NSData dataWithBytes:[decryptedString UTF8String] length:[[decryptedString dataUsingEncoding:NSUTF8StringEncoding] length]];
//    encryptedData = [decryptedData AES128Encrypt];
//    if (encryptedData!=nil)
//    {
//        NSString *encryptedHexString = [self hexStringFromData:encryptedData];
//        NSLog(@"Encrypted HexString : %@",encryptedHexString);
//        
//        //        NSData *data1 = [self dataFromHexString:encryptedHexString];
//        //        NSData *encryptedData1 =  [NSData dataWithBytes:[data1 bytes] length:[data1 length]];
//        //        NSData *decryptedData1 = [encryptedData1 AES128Decrypt];
//        //        NSString *decryptedString1 = [NSString stringWithUTF8String:[decryptedData1 bytes]];
//        //        NSLog(@"Decrypted String Testing 123: %@",[decryptedString1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]);
//    }
//}

+(NSString*)encryptAES:(NSString*)string{
    NSData *data = [self dataFromHexString:string];
    
    NSData *encryptedData =  [NSData dataWithBytes:[data bytes] length:[data length]];
    NSString *encryptedString = [[[NSString alloc]initWithData:encryptedData encoding:NSASCIIStringEncoding] autorelease];
    return encryptedString;
}

+(NSString*)decryptAES:(NSString*)string{
    NSData *encryptedData = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSData *decryptedData = [encryptedData AES128Decrypt];
    NSString *decryptedString = [NSString stringWithUTF8String:[decryptedData bytes]];
    return decryptedString;
}

//Step 4 : For step3 , you have to add these three methods into your code.

// For Converting incoming HexString into NSData
+ (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[[NSMutableData alloc] init] autorelease];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}


// For converting Encrypted Data into NSString after the encryption
+ (NSString*)hexStringFromData:(NSData *)data
{
    unichar* hexChars = (unichar*)malloc(sizeof(unichar) * (data.length*2));
    unsigned char* bytes = (unsigned char*)data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        unichar c = bytes[i] / 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2] = c;
        c = bytes[i] % 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2+1] = c;
    }
    NSString* retVal = [[NSString alloc] initWithCharactersNoCopy:hexChars
                                                           length:data.length*2
                                                     freeWhenDone:YES];
    return [retVal autorelease];
}

// For padding into a string for required string length
+(NSString *)addPaddingToString:(NSString *)string
{
    NSInteger size = 16;
    NSInteger x = [string length]%size;
    NSInteger padLength = size - x;
    for (int i=0; i<padLength; i++)
    {
        string = [string stringByAppendingString:@" "];
    }
    return string;
}

@end
