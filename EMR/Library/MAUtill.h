//
//  MangoUtil.h
//  PhotoEnglish
//
//  Created by jeong yunyung on 11. 10. 28..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MAUtill : NSObject


+(void)translateView:(UIView*)originView frameView:(UIView*)frameView   duration:(float)aDuration distanceX:(int)aDistanceX distanceY:(int)aDistanceY;
+(UIView *)showBlackImage:(UIView *)aView tartgetView:(UIView*)aModalView;
+(void)closeBlackImage:(UIView *)aModalView;

//특정한 날짜에서 달수 더하기
+(NSString * )addMonthFromDate:(NSDate *)fromDate  toMonth:(NSInteger)toMonth;
//특정한 문자열 날짜에서 달수 더하기
+(NSString * )addMonthFromString:(NSString *)strFromDate  toMonth:(NSInteger)toMonth;
+(NSString*)setDateFormatYYMMDD:(NSString*)strDateTime;
+(NSString*)setDateFormatMMDD:(NSString*)strDateTime;
+(NSString*)setDateFormatMMDDHHmm2:(NSString*)strDateTime;
+(NSString*)setDateFormatMMDDHHmmss:(NSString*)strDateTime;
//오늘 날짜를 문자열로 받기
+(NSString *)getStringFromToday;
+(NSString *)getTodayFromComponent;
+(NSString *)getTwoStringFromInt:(int)aInt;
+(CGFloat )getLabelHeightFromText:(NSString *)str fontSize:(float)aFontSize labelWidth:(CGFloat)aWidth;
+(UILabel * )getLabelResizeFromText:(NSString *)str fontSize:(float)aFontSize labelRect:(CGRect)aRect;
+(UILabel * )getLabelResize:(UILabel *)lblResize  fontSize:(float)aFontSize;
+(BOOL)copyFromResToDoc:(NSString*)fileName reCopy:(BOOL)isReCopy;
+(NSString*)getMoneyFormatFromString:(NSString*)strNumber;   //콤마 처리
+(UILabel*)getMoneyFormatFromLabel:(UILabel*)lblStr;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
+ (NSString*)appVersion;

@end
