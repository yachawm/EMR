//
//  WUtil.h
//  PhotoEnglish
//
//  Created by jeong yunyung on 11. 10. 28..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WUtil : NSObject<UIWebViewDelegate>


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
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (NSString*)appVersion;
+ (CGRect)autoHeightFrameFromLabel:(UILabel*)label;
+ (CGRect)autoHeightFrameFromView:(UIView *)view withMarginBottom:(CGFloat)marginBottom;
+ (CGRect)autoHeightFrameFromView:(UIView *)view;
+ (void)loadWebView:(UIWebView*)webView withHTMLString:(NSString*)htmlString;
+ (CGRect)autoHeightFrameFromWebView:(UIWebView*)webView;
+ (void)autoLocateViewToBottom:(UIView*)view fromView:(UIView*)viewParent;

+ (NSString*) sha1:(NSString*)input length:(int)length;
+ (NSString *) md5:(NSString *)input length:(int)length;
+ (BOOL)isiPhone5;

+ (NSString*)filteredStringOfRemoveSpacesFromString:(NSString*)fullString;
+ (NSString*)filteredStringOfRemoveSubstring:(NSString*)subString FromFullstring:(NSString*)fullString;

+ (BOOL)isString:(NSString*)string existInFullString:(NSString*)fullString;
+ (BOOL)isString:(NSString*)searchString existInStringArray:(NSArray*)strings;

+ (NSDate*)dateFromString:(NSString*)string withFormat:(NSString*)format;
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format;

+ (NSString*)sexStringFromBOOL:(BOOL)sex;

+ (void)hideNavigationToolbar:(UINavigationController*)navigation;

+ (void)addTitlesFromCell:(UITableViewCell*)cell toView:(UIView*)view;

+ (void)addLabelBoardLinesToView:(UIView*)view isCell:(BOOL)isCell;

+ (void)addLabelBoardLinesToView:(UIView*)view isCell:(BOOL)isCell withGap:(CGFloat)gap;

+ (NSString*) keyFromStringObject:(NSString*)string ofDictionary:(NSDictionary*)dictionary;

+ (void)applyAttributedStringToLabel:(UILabel*)label fromHTML:(NSString*)html;

+ (NSString*)stringFromHTML:(NSString*)html;

- (id)fetchSSIDInf;

+ (void)hideKeyboardFromView:(UIView*)view fromMainView:(UIView*)mainView;

+ (void)hideKeyboardFromView:(UIView*)view fromMainView:(UIView*)mainView animate:(BOOL)animate;

+(UIAlertView*)alertMessage:(NSString*)message;

+(UIAlertView*)alertMessage:(NSString*)message withTitle:(NSString*)title;

+(UIAlertView*)alertMessage:(NSString*)message withTitle:(NSString*)title withDelegate:(id)delegate;

+(UIView*)viewWithTag:(int)tag fromViews:(NSArray*)views;

+(id)loadViewFromNibName:(NSString*)nib;

+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;

+ (NSString*)modelName;
+ (NSString*)osVersion;

+ (void)callPhone:(NSString*)phoneNumber;

+ (UIView*)viewAbsoluteFrame:(UIView*)view fromView:(UIView*)superView;

+ (NSString *)getIPAddress;

+(NSURL*)urlForWebPath:(NSString*)path;

+ (NSString*)stringFromBoolean:(BOOL)boolean;

+ (BOOL)isLongScreen;

+(id)loadViewFromNibName:(NSString*)nib atIndex:(int)index;

+ (BOOL)isNull:(id)object;

+ (NSString*)stringUTCFromDate:(NSDate*)date withFormat:(NSString*)format;

@end
