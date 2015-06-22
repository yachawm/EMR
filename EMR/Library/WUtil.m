/**
 * @brief Wenly's Util
 
 * @param
 * @return
 
 * @section
 */
#import "WUtil.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation WUtil


#pragma mark Animation

/**
 * @brief
 onAnimationTypeTraslation:
 
 * @param
 aFrameView :  상위 뷰
 aTargetView : 애니메이션을 대상 뷰
 aDuration : 애니메이션 시간
 aDistanceX : X이동 거리
 aDistanceY : Y이동 거리
 
 * @return <#Return#>
 
 * @section 이동 애니메이션
 */
+(void)translateView:(UIView*)originView frameView:(UIView*)frameView   duration:(float)aDuration distanceX:(int)aDistanceX distanceY:(int)aDistanceY
{
    [UIView beginAnimations:nil	context:nil];//
    [UIView setAnimationDuration:aDuration]; //애니메이션 속도
    [UIView setAnimationDelegate:self];
    
    originView.transform = CGAffineTransformMakeTranslation(aDistanceX, aDistanceY);
    
    [frameView bringSubviewToFront:originView];
    [UIView commitAnimations];
    
}
/**
 * @brief blackImageShow
 
 * @param <#Return#>
 * @return <#Return#>
 
 * @section 블랙 투명 이미지를 보여줘서 alertView 효과
 */

+(UIView *)blackImageShow:(UIView *)aView tartgetView:(UIView*)aModalView
{
    aModalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    aModalView.backgroundColor = [UIColor blackColor];
    aModalView.alpha=0.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [aView addSubview:aModalView];
    aModalView.alpha = 0.8;
    [UIView commitAnimations];
    return aModalView;
}
/**
 * @brief blackImageClose
 
 * @param <#Return#>
 * @return <#Return#>
 
 * @section 블랙 투명 이미지를 보여줘서 alertView 효과
 */

+(void)blackImageClose:(UIView *)aModalView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [aModalView removeFromSuperview];
    aModalView.alpha = 0.0;
    [UIView commitAnimations];
    
}
+(void)printNull
{
    
    NSLog(@"\n\n\n");
    NSLog(@"======================================");
    
}

//+(NSString *)getDocumentFilePath:(NSString *)fileName
//{
//
//    //    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSString * documentFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//
//    NSLog(@"documentFolderPath:%@", documentFolderPath);
//    //	NSString * myPath = [documentFolderPath stringByAppendingPathComponent:@"mangoapps"];
//    NSURL *pathURL= [NSURL fileURLWithPath:documentFolderPath];
//    [self addSkipBackupAttributeToItemAtURL:pathURL];
//
//    NSString * filePath = [documentFolderPath stringByAppendingPathComponent:fileName];
//
//    NSLog(@"docpath:%@", filePath);
//    return filePath;
//}
//
//#pragma mark file Access
//+(BOOL)copyFromResToDoc:(NSString*)fileName reCopy:(BOOL)isReCopy
//{
//
//    [self printNull];
//    BOOL success ;
//    NSLog(@"########### 데이터 파일 생성 start");
//
//    NSError * error;
//	NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
//    NSString * toPath = [self getDocumentFilePath:fileName];
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    BOOL exit = [fileManager fileExistsAtPath:toPath];
//
//    if(exit&&isReCopy)
//    {
//        if (exit) {
//            NSLog(@"데이터 파일 제거 ");
//            success = [fileManager removeItemAtPath:toPath error:&error];
//            if(!success) {
//
//                NSLog(@"remove Error : %@", [error localizedDescription]);
//
//            }
//        }
//        NSLog(@"데이터 파일 다시 복사 ");
//        success = [fileManager copyItemAtPath:defaultDBPath toPath:toPath error:&error];
//        if(!success) {
//
//            NSLog(@"Copy Error : %@", [error localizedDescription]);
//        }
//    }else
//    {
//        NSLog(@"데이터 파일 복사 ");
//        success = [fileManager copyItemAtPath:defaultDBPath toPath:toPath error:&error];
//
//        if(!success) {
//
//            NSLog(@"Copy Error : %@", [error localizedDescription]);
//
//        }
//    }
//
//    NSLog(@"\n filePath1:%@\n myPath:%@",defaultDBPath,toPath);
//    NSLog(@"########### 데이터 파일 생성 end");
//    return success;
//    //    return [self initWithPath: defaultDBPath];
//
//
//}
/**
 * @brief addMonthFromDate
 
 * @param
 -fromDate: 현재 날짜
 -toMonth: 추가 날짜
 * @return NSString
 
 * @section 현재 날짜에서 month만큼 더한다.
 */
+(NSString * )addMonthFromDate:(NSDate *)fromDate  toMonth:(NSInteger)toMonth
{
    NSDate *toDate;
    NSDateComponents *com;
    NSDateFormatter *formatter;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    com  = [calendar components:unitFlags fromDate:fromDate];
    
    NSInteger nMonth = [com month]+toMonth;
    
    [com setMonth:nMonth];
    
    toDate = [[NSCalendar currentCalendar] dateFromComponents:com];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@", [formatter stringFromDate:toDate]);
    NSString  * strToDate = [formatter stringFromDate:toDate];
    
    
    
    return strToDate;
}
/**
 * @brief addMonthFromString
 
 * @param <#Parameter#>
 * @return <#Return#>
 
 * @section <#Description#>
 */

+(NSString * )addMonthFromString:(NSString *)strFromDate  toMonth:(NSInteger)toMonth
{
    NSDate *toDate;
    NSDateComponents *com;
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate   * fromDate = [formatter dateFromString:strFromDate];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    com  = [calendar components:unitFlags fromDate:fromDate];
    
    NSInteger nMonth = [com month]+toMonth;
    
    [com setMonth:nMonth];
    
    toDate = [[NSCalendar currentCalendar] dateFromComponents:com];
    NSString  * strToDate = [formatter stringFromDate:toDate];
    
    
    
    
    
    return strToDate;
}

+(NSString*)setDateFormatYYMMDD:(NSString*)strDateTime
{
    
    NSDateComponents *com;
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate   * fromDate = [formatter dateFromString:strDateTime];
    NSLog(@"fromDate:%@",fromDate);
    formatter.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"];
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate];
    
    
    NSString * strMonthDay = [[NSString alloc]initWithFormat:@"%ld.%@.%@",
                              (long)[com year],
                              ([com month]<10)?[NSString stringWithFormat:@"0%ld",(long)[com month]]:[NSString stringWithFormat:@"%ld",(long)[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%ld",(long)[com day]]:[NSString stringWithFormat:@"%ld",(long)[com day]]];
    //[[NSString alloc]initWithFormat:@"%d.%d %d:%d",[com month],[com day], [com hour], [com minute]];
    
    NSLog(@"strMonthDay:%@",strMonthDay);
    
    return strMonthDay;
}

+(NSString*)setDateFormatMMDD:(NSString*)strDateTime
{
    
    NSDateComponents *com;
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   * fromDate = [formatter dateFromString:strDateTime];
    NSLog(@"fromDate:%@",fromDate);
    formatter.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"];
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate];
    
    
    NSString * strMonthDay = [[NSString alloc]initWithFormat:@"%@.%@ %@:%@",
                              ([com month]<10)?[NSString stringWithFormat:@"0%ld",(long)[com month]]:[NSString stringWithFormat:@"%d",[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%d",[com day]]:[NSString stringWithFormat:@"%d",[com day]],
                              ([com hour]<10)?[NSString stringWithFormat:@"0%d",[com hour]]:[NSString stringWithFormat:@"%d",[com hour]],
                              ([com minute]<10)?[NSString stringWithFormat:@"0%d",[com minute]]:[NSString stringWithFormat:@"%d",[com minute]]];
    //[[NSString alloc]initWithFormat:@"%d.%d %d:%d",[com month],[com day], [com hour], [com minute]];
    
    NSLog(@"strMonthDay:%@",strMonthDay);
    return strMonthDay;
    
    
}

// NSString * strMonthDay = [[NSString alloc]initWithFormat:@"%d.%d %d:%d",[com month],[com day], [com hour], [com minute]];
+(NSString*)setDateFormatMMDDHHmmss:(NSString*)strDateTime
{
    
    NSDateComponents *com;
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   * fromDate = [formatter dateFromString:strDateTime];
    NSLog(@"fromDate:%@",fromDate);
    formatter.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"];
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate];
    
    
    NSString * strMonthDay = [[NSString alloc]initWithFormat:@"%@.%@ %@:%@:%@",
                              ([com month]<10)?[NSString stringWithFormat:@"0%d",[com month]]:[NSString stringWithFormat:@"%d",[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%d",[com day]]:[NSString stringWithFormat:@"%d",[com day]],
                              ([com hour]<10)?[NSString stringWithFormat:@"0%d",[com hour]]:[NSString stringWithFormat:@"%d",[com hour]],
                              ([com minute]<10)?[NSString stringWithFormat:@"0%d",[com minute]]:[NSString stringWithFormat:@"%d",[com minute]],
                              ([com second]<10)?[NSString stringWithFormat:@"0%d",[com second]]:[NSString stringWithFormat:@"%d",[com second]]];
    
    NSLog(@"strMonthDay:%@",strMonthDay);
    
    return strMonthDay;
}



+(NSString *)getStringFromToday
{
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString  * strToDate = [formatter stringFromDate:[NSDate date]];
    
    
    return strToDate;
}

+(NSString *)getTodayFromComponent
{
    
    NSDateComponents *com;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    com  = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSString * toDay= [NSString stringWithFormat:@"%d-%d-%d",[com year],[com month],[com day]];
    
    NSLog(@"**************%@",toDay);
    
    return toDay;
}
/**
 * @brief 두자리 문자열 만들기
 1-> 01
 
 * @param
 * @return @"0x"
 
 * @section
 */

+(NSString *)getTwoStringFromInt:(int)aInt
{
    NSString * strMonth;
    if (aInt<10) {
        
        strMonth = [NSString stringWithFormat:@"0%d",aInt];
    }else
        strMonth = [NSString stringWithFormat:@"%d",aInt];
    return strMonth;
    
}
+(NSString*)getMoneyFormatFromString:(NSString*)strNumber
{
    int nTmp = [strNumber intValue];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatedString = [fmt stringFromNumber:[NSNumber numberWithInt:nTmp]];
    
    return formatedString;
    
}

+(UILabel*)getMoneyFormatFromLabel:(UILabel*)lblStr
{
    int nTmp = [lblStr.text intValue];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatedString = [fmt stringFromNumber:[NSNumber numberWithInt:nTmp]];
    lblStr.text = formatedString;
    
    return lblStr;
    
}

/**
 * @brief 헥스 스트링으로부터 컬러를 가져온다.
 * @param (NSString *)stringToConvert
 * @return (UIColor*)
 * @author Chang-hyeok Yang
 * @section
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    return [WUtil colorWithHexString:stringToConvert alpha:1];
}

/**
 * @brief 헥스 스트링으로부터 컬러를 가져온다.
 * @param (NSString *)stringToConvert alpha:(CGFloat)alpha
 * @return (UIColor*)
 * @author Chang-hyeok Yang
 * @section
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (NSString*)appVersion{
    //NSNumber *version = [NSNumber numberWithFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue]];
    //NSLog(@"appVersion = %@",version);
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//[version retain];
}

+ (NSString*)modelName{
    
    return [NSString stringWithFormat:@"iphone%@", [[UIDevice currentDevice]
                                                    systemVersion]];
    
}

+ (NSString*)osVersion{
    return [[UIDevice currentDevice] systemVersion];
}


/**
 * @brief 라벨의 내용에 알맞게 높이를 변경해준다.
 * @param (UILabel*)label
 * @return (UILabel*)label
 * @author Chang-hyeok Yang
 * @section
 */
+ (CGRect)autoHeightFrameFromLabel:(UILabel*)label{
    //CGSize constraint = CGSizeMake(label.frame.size.width, 10000);
    //label.font = [UIFont systemFontOfSize:14];
    //CGSize size = [label.text sizeWithFont:[label font] constrainedToSize:constraint];
    CGSize size = [label.text sizeWithAttributes:nil];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height);
}

+ (CGRect)autoHeightFrameFromView:(UIView *)view withMarginBottom:(CGFloat)marginBottom{
    CGFloat maxHeight = view.frame.size.height;
    for (UIView *subView in view.subviews) {
        if (maxHeight < subView.frame.origin.y+subView.frame.size.height) {
            maxHeight = subView.frame.origin.y+subView.frame.size.height;
        }
    }
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, maxHeight+marginBottom);
}

+ (CGRect)autoHeightFrameFromView:(UIView *)view{
    CGFloat maxHeight = view.frame.size.height;
    for (UIView *subView in view.subviews) {
        if (maxHeight < subView.frame.origin.y+subView.frame.size.height) {
            maxHeight = subView.frame.origin.y+subView.frame.size.height;
        }
    }
    NSLog(@"maxHeight = %f",maxHeight);
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, maxHeight+20);
}

+ (void)loadWebView:(UIWebView*)webView withHTMLString:(NSString*)htmlString{
    NSString *htmlDiv = @"<html><body><div id='content' style='width:300;font-size:16px;line-height:1.25em'>%@</div></body></html>";
    
    NSString *html = [NSString stringWithFormat:htmlDiv, htmlString];
    
    NSLog(@"html = %@",html);
    
    for (id subview in webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
    
    [webView setScalesPageToFit:NO];
    
    [webView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
             MIMEType:@"text/html"
     textEncodingName:@"UTF-8"
              baseURL:nil];
}

+ (CGRect)autoHeightFrameFromWebView:(UIWebView*)webView{
    
    CGSize contentSize;
    for (id view in webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView*)view;
            if(scrollView.contentSize.height > contentSize.height){
                contentSize = scrollView.contentSize;
            }
        }
    }
    NSLog(@"web content size x = %.1f, y = %.1f",contentSize.width, contentSize.height);
    
    NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    
    NSLog(@"heightString = %@",heightString);
    
    return CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, heightString.floatValue+10);
    
}

/**
 * @brief 뷰 안의 모든 서브뷰를 조사한 후 가장 밑으로 위치를 지정해준다. 또한 포함하는 큰 뷰의 사이즈를 알맞게 조절한다.
 * @param (UIView*)view fromView:(UIView*)viewParent
 * @return
 * @author Chang-hyeok Yang
 * @section
 */
+ (void)autoLocateViewToBottom:(UIView*)view fromView:(UIView*)viewParent{
    CGFloat maxHeight = 0;
    for (UIView *subView in viewParent.subviews) {
        if (subView==view) {
            continue;
        }
        if (maxHeight < subView.frame.origin.y+subView.frame.size.height) {
            maxHeight = subView.frame.origin.y+subView.frame.size.height;
        }
    }
    view.frame = CGRectMake(view.frame.origin.x, maxHeight, view.frame.size.width, view.frame.size.height);
    viewParent.frame = CGRectMake(viewParent.frame.origin.x, viewParent.frame.origin.y, viewParent.frame.size.width, view.frame.origin.y+view.frame.size.height+10);
}




+ (BOOL)isiPhone5{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f && screenSize.width < 540) {
            /*Do iPhone 5 stuff here.*/
            return YES;
        } else {
            /*Do iPhone Classic stuff here.*/
            return NO;
        }
    } else {
        /*Do iPad stuff here.*/
        return NO;
    }
    return NO;
}

/**
 * @brief 문자열에서 여백을 제거
 * @param (NSString*)fullString
 * @return (NSString*)
 * @author Chang-hyeok Yang
 */
+ (NSString*)filteredStringOfRemoveSpacesFromString:(NSString*)fullString{
    NSMutableString* newStr = [NSMutableString stringWithString:fullString];
    NSUInteger numReplacements;
    do {
        NSRange fullRange = NSMakeRange(0, [newStr length]);
        numReplacements = [newStr replaceOccurrencesOfString:@" " withString:@""
                                                     options:0 range:fullRange];
    } while(numReplacements > 0);
    return [NSString stringWithString:newStr];
}

/**
 * @brief 문자열에서 특정문자열을 제거
 * @param (NSString*)subString, (NSString*)fullString
 * @return (NSString*)
 * @author Chang-hyeok Yang
 */
+ (NSString*)filteredStringOfRemoveSubstring:(NSString*)subString FromFullstring:(NSString*)fullString{
    
    NSMutableString *mutableString = [NSMutableString stringWithString:fullString];
    NSRange fullRange = NSMakeRange(0, [mutableString length]);
    [mutableString replaceOccurrencesOfString:subString withString:@"" options:0 range:fullRange];
    
    return [NSString stringWithString:mutableString];
}

+ (BOOL)isString:(NSString*)string existInFullString:(NSString*)fullString{
    NSRange textRange;
    textRange =[fullString rangeOfString:string];
    
    if(textRange.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isString:(NSString*)searchString existInStringArray:(NSArray*)strings{
    for (NSString *string in strings) {
        if ([string isEqualToString:searchString]) {
            return YES;
        }
    }
    return NO;
}

- (NSDate*)randomDate{
    
    NSDate *today = [NSDate date];
    NSTimeInterval todaySecond = [today timeIntervalSince1970];
    todaySecond -= arc4random()%1000000;
    
    NSDate *randomDate = [NSDate dateWithTimeIntervalSince1970:todaySecond];
    
    return randomDate;
    
}

+ (NSDate*)dateFromString:(NSString*)string withFormat:(NSString*)format{
    if(string==nil)return nil;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:format];
    return [df dateFromString:[WUtil stringFromHTML:string]];
}

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format{
    if(date==nil)return nil;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:format];
    return [df stringFromDate:date];
}

+ (NSString*)stringUTCFromDate:(NSDate*)date withFormat:(NSString*)format{
    if(date==nil)return nil;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:format];
    return [df stringFromDate:date];
}


+ (NSString*)sexStringFromBOOL:(BOOL)sex{
    if (sex) {
        return @"남";
    }
    else{
        return @"여";
    }
    return @"";
}

+ (void)hideNavigationToolbar:(UINavigationController*)navigation{
    [navigation setNavigationBarHidden:YES];
}

+ (void)addTitlesFromCell:(UITableViewCell*)cell toView:(UIView*)view{
    //    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, view.frame.size.width, view.frame.size.height);
    //    cell.backgroundColor = view.backgroundColor;
    //    [view addSubview:cell];
    //
    for(id object in cell.contentView.subviews){
        if([object isMemberOfClass:[UILabel class]]||[object isMemberOfClass:[UITextField class]]){
            UIView *label = object;
            [view addSubview:label];
            label.center = CGPointMake(label.center.x, view.frame.size.height/2);
        }
    }
}


+ (void)addLabelBoardLinesToView:(UIView*)view isCell:(BOOL)isCell{
    
    [WUtil addLabelBoardLinesToView:view isCell:isCell withGap:0];
    
}

+ (void)addLabelBoardLinesToView:(UIView*)view isCell:(BOOL)isCell withGap:(CGFloat)gap{
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    
    if (isCell==NO) {
        UIView *boardLineTop = [[UIView alloc]initWithFrame:CGRectMake(0,0,view.frame.size.width,1)];
        boardLineTop.backgroundColor = backgroundColor;
        boardLineTop.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        
        [view addSubview:boardLineTop];
    }
    
    UIView *boardLineBottom = [[UIView alloc]initWithFrame:CGRectMake(0,view.frame.size.height-1,view.frame.size.width,1)];
    boardLineBottom.backgroundColor = backgroundColor;
    [view addSubview:boardLineBottom];
    boardLineBottom.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    UIView *boardLineRight = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width-1,0,1,view.frame.size.height)];
    boardLineRight.backgroundColor = backgroundColor;
    [view addSubview:boardLineRight];
    boardLineRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
    
    UIView *boardLineLeft = [[UIView alloc]initWithFrame:CGRectMake(0,0,1,view.frame.size.height)];
    boardLineLeft.backgroundColor = backgroundColor;
    [view addSubview:boardLineLeft];
    boardLineLeft.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    
    for (id object in view.subviews) {
        if ([object isMemberOfClass:[UILabel class]]||[object isMemberOfClass:[UITextField class]]) {
            UIView *label = object;
            
            UIView *boardLine = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x-gap,0,1,view.frame.size.height)];
            
            boardLine.backgroundColor = backgroundColor;
            
            boardLine.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
            
            [view addSubview:boardLine];
            
            int index = [view.subviews indexOfObject:object];
            
            boardLine.tag = index;
            
        }
        
    }
    
}

+ (NSString*) keyFromStringObject:(NSString*)string ofDictionary:(NSDictionary*)dictionary{
    for(NSString *key in dictionary){
        if([[dictionary objectForKey:key] isEqualToString:string]){
            return key;
        }
    }
    return @"";
}

+ (void)applyAttributedStringToLabel:(UILabel*)label fromHTML:(NSString*)html{
    //    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    //
    //    NSError *error = nil;
    //
    NSAttributedString *string = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                            NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                       documentAttributes:nil error:nil];
    
    label.attributedText = string;
    
}

+ (NSString*)stringFromHTML:(NSString*)html{
    
    NSArray *firstArray = [html componentsSeparatedByString:@">"];
    if(firstArray.count>1){
        return [[[firstArray objectAtIndex:1] componentsSeparatedByString:@"<"]objectAtIndex:0];
    }
    
    return html;
}

+ (void)hideKeyboardFromView:(UIView*)view fromMainView:(UIView*)mainView{
    [WUtil hideKeyboardFromView:view fromMainView:mainView animate:YES];
}

/**
 * @brief 특정 뷰 안에 있는 텍스트 필드와 텍스트 뷰로부터 키보드를 숨긴다.
 * @param (UIView*)view
 * @return
 * @author Chang-hyeok Yang
 */
+ (void)hideKeyboardFromView:(UIView*)view fromMainView:(UIView*)mainView animate:(BOOL)animate{
    for(id object in view.subviews){
        if([object isMemberOfClass:[UITextField class]]){
            UITextField *textField = object;
            [textField resignFirstResponder];
        }
        else if([object isMemberOfClass:[UITextView class]]){
            UITextView *textView = object;
            [textView resignFirstResponder];
        }
    }
    
    if (animate) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
    }
    
    mainView.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
    
    if (animate) {
        [UIView commitAnimations];
    }
}

+(UIAlertView*)alertMessage:(NSString*)message{
    
    return [WUtil alertMessage:message withTitle:nil];
}

+(UIAlertView*)alertMessage:(NSString*)message withTitle:(NSString*)title{
    return [WUtil alertMessage:message withTitle:title withDelegate:nil];
}

+(UIAlertView*)alertMessage:(NSString*)message withTitle:(NSString*)title withDelegate:(id)delegate{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
    //[alert autorelease];
    return alert;
}


+(UIView*)viewWithTag:(int)tag fromViews:(NSArray*)views{
    for(UIView *view in views){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

+(id)loadViewFromNibName:(NSString*)nib{
    return [[[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil] objectAtIndex:0];
}


+(id)loadViewFromNibName:(NSString*)nib atIndex:(int)index{
    return [[[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil] objectAtIndex:index];
}

//+(NSURL*)urlForWebPath:(NSString*)path{
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",HOST_URL_WEB,path]];
//}

+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

/**
 * @brief 전화걸기
 * @param (NSString*)phoneNumber
 * @return
 * @author Chang-hyeok Yang
 */
+ (void)callPhone:(NSString*)phoneNumber{
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        [WUtil alertMessage:@"통화기능을 사용할 수 없습니다."];
    }
}


+ (UIView*)viewAbsoluteFrame:(UIView*)view fromView:(UIView*)superView{
    
    //NSLog(@"view = %@ , superview = %@",view,superView);
    
    if(view.superview==nil){
        return view;
    }
    else if (view.superview==superView) {
        return view;
    }
    
    return [WUtil viewAbsoluteFrame:view.superview fromView:superView];
    
}


+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    NSLog(@"ip = %@",address);
    
    return address;
    
}


+ (NSString*)stringFromBoolean:(BOOL)boolean{
    if(boolean){
        return @"Y";
    }
    return @"N";
}

+ (BOOL)isLongScreen{
    CGFloat width = [[UIScreen mainScreen]bounds].size.width;
    CGFloat height = [[UIScreen mainScreen]bounds].size.height;
    
    if( (width/height) < 320.0 / 500.0){
        return YES;
    }
    
    return NO;
    
}

+ (BOOL)isNull:(id)object{
    if([object isKindOfClass:[NSNull class]] || object==nil || [object isEqualToString:@"(null)"]){
        return YES;
    }
    return NO;
}

@end