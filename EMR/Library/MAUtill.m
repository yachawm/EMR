/**
 * @brief MangoUtil
 * @param <#Parameter#>
 * @return <#Return#>
 * @remark <#Remark#>
 * @see <#See#>
 * @author Keun young Kim.
 */
#import "MAUtill.h"



@implementation MAUtill


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
    aModalView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)]autorelease];
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
//+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
//{
//    const char* filePath = [[URL path] fileSystemRepresentation];
//    
//    const char* attrName = "com.apple.MobileBackup";
//    u_int8_t attrValue = 1;
//
//    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//    return result == 0;
//}

+(NSString *)getDocumentFilePath:(NSString *)fileName
{
    
    //    NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * documentFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSLog(@"documentFolderPath:%@", documentFolderPath);
    //	NSString * myPath = [documentFolderPath stringByAppendingPathComponent:@"mangoapps"];
    NSURL *pathURL= [NSURL fileURLWithPath:documentFolderPath];
    [self addSkipBackupAttributeToItemAtURL:pathURL];
    
    NSString * filePath = [documentFolderPath stringByAppendingPathComponent:fileName];
    
    NSLog(@"docpath:%@", filePath);
    return filePath;
}

#pragma mark file Access
+(BOOL)copyFromResToDoc:(NSString*)fileName reCopy:(BOOL)isReCopy
{
    
    [self printNull];
    BOOL success ;
    NSLog(@"########### 데이터 파일 생성 start");
    
    NSError * error;  
	NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSString * toPath = [self getDocumentFilePath:fileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exit = [fileManager fileExistsAtPath:toPath];
    
    if(exit&&isReCopy)
    {
        if (exit) {
            NSLog(@"데이터 파일 제거 ");  
            success = [fileManager removeItemAtPath:toPath error:&error];
            if(!success) {
                
                NSLog(@"remove Error : %@", [error localizedDescription]);
                
            }
        }
        NSLog(@"데이터 파일 다시 복사 ");  
        success = [fileManager copyItemAtPath:defaultDBPath toPath:toPath error:&error];  
        if(!success) {
            
            NSLog(@"Copy Error : %@", [error localizedDescription]);
        }
    }else if(!exit) 
    {
        NSLog(@"데이터 파일 복사 ");  
        success = [fileManager copyItemAtPath:defaultDBPath toPath:toPath error:&error];   
        
        if(!success) {
            
            NSLog(@"Copy Error : %@", [error localizedDescription]);
            
        }
    }
    
    NSLog(@"\n filePath1:%@\n myPath:%@",defaultDBPath,toPath);    
    NSLog(@"########### 데이터 파일 생성 end");
    return success;
    //    return [self initWithPath: defaultDBPath];
    
    
}
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
    [formatter release];
    
    
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
    
    
    [formatter release];
    
    
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
    formatter.locale =  [[[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"] autorelease]; 
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate]; 
    
    
    NSString * strMonthDay = [[[NSString alloc]initWithFormat:@"%@.%@.%@",
                              [com year],
                              ([com month]<10)?[NSString stringWithFormat:@"0%d",[com month]]:[NSString stringWithFormat:@"%d",[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%d",[com day]]:[NSString stringWithFormat:@"%d",[com day]]]autorelease];
    //[[NSString alloc]initWithFormat:@"%d.%d %d:%d",[com month],[com day], [com hour], [com minute]];
    
    NSLog(@"strMonthDay:%@",strMonthDay);
    [formatter release];
    return strMonthDay;
}

+(NSString*)setDateFormatMMDD:(NSString*)strDateTime
{
    
    NSDateComponents *com;
    NSDateFormatter * formatter= [[[NSDateFormatter alloc] init]autorelease];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   * fromDate = [formatter dateFromString:strDateTime];
    NSLog(@"fromDate:%@",fromDate);
    formatter.locale =  [[[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"] autorelease]; 
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate]; 
    
    
    NSString * strMonthDay = [[[NSString alloc]initWithFormat:@"%@.%@ %@:%@",
                              ([com month]<10)?[NSString stringWithFormat:@"0%d",[com month]]:[NSString stringWithFormat:@"%d",[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%d",[com day]]:[NSString stringWithFormat:@"%d",[com day]], 
                              ([com hour]<10)?[NSString stringWithFormat:@"0%d",[com hour]]:[NSString stringWithFormat:@"%d",[com hour]], 
                              ([com minute]<10)?[NSString stringWithFormat:@"0%d",[com minute]]:[NSString stringWithFormat:@"%d",[com minute]]]autorelease];
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
    formatter.locale =  [[[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"] autorelease]; 
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate]; 
    
    
    NSString * strMonthDay = [[[NSString alloc]initWithFormat:@"%@.%@ %@:%@:%@",
                              ([com month]<10)?[NSString stringWithFormat:@"0%d",[com month]]:[NSString stringWithFormat:@"%d",[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%d",[com day]]:[NSString stringWithFormat:@"%d",[com day]], 
                              ([com hour]<10)?[NSString stringWithFormat:@"0%d",[com hour]]:[NSString stringWithFormat:@"%d",[com hour]], 
                              ([com minute]<10)?[NSString stringWithFormat:@"0%d",[com minute]]:[NSString stringWithFormat:@"%d",[com minute]], 
                              ([com second]<10)?[NSString stringWithFormat:@"0%d",[com second]]:[NSString stringWithFormat:@"%d",[com second]]] autorelease];
    
    NSLog(@"strMonthDay:%@",strMonthDay);
    [formatter release];
    return strMonthDay;
}

+(NSString*)setDateFormatMMDDHHmm2:(NSString*)strDateTime
{
    NSDateComponents *com;
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   * fromDate = [formatter dateFromString:strDateTime];
    NSLog(@"fromDate:%@",fromDate);
    formatter.locale =  [[[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"] autorelease]; 
    NSLog(@"fromDate:%@",fromDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit|kCFCalendarUnitSecond;
    com  = [calendar components:unitFlags fromDate:fromDate]; 
    
    NSString * strMonthDay = [[[NSString alloc]initWithFormat:@"%d.%@.%@ %@:%@:%@",
                              [com year], 
                              ([com month]<10)?[NSString stringWithFormat:@"0%d",[com month]]:[NSString stringWithFormat:@"%d",[com month]],
                              ([com day]<10)?[NSString stringWithFormat:@"0%d",[com day]]:[NSString stringWithFormat:@"%d",[com day]], 
                              ([com hour]<10)?[NSString stringWithFormat:@"0%d",[com hour]]:[NSString stringWithFormat:@"%d",[com hour]], 
                              ([com minute]<10)?[NSString stringWithFormat:@"0%d",[com minute]]:[NSString stringWithFormat:@"%d",[com minute]], 
                              ([com second]<10)?[NSString stringWithFormat:@"0%d",[com second]]:[NSString stringWithFormat:@"%d",[com second]]]autorelease];
    
    NSLog(@"strMonthDay:%@",strMonthDay);
    [formatter release];
    return strMonthDay;
}

+(NSString *)getStringFromToday
{
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString  * strToDate = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
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
/**
 * @brief 레이블 높이를 구한다.
 
 * @param 
 * @return 
 
 * @section 
 */
+(CGFloat )getLabelHeightFromText:(NSString *)str fontSize:(float)aFontSize labelWidth:(CGFloat)aWidth
{
 
    
    CGFloat height = ceilf([str sizeWithFont:[UIFont systemFontOfSize:aFontSize] constrainedToSize:CGSizeMake(aWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
//    height += kAttributedTableViewCellVerticalMargin;
    return height;

}
/**
 * @brief setStringTolbResize
 
 * @param <#Parameter#>
 * @return UILabel
 
 * @section UILabel의 텍스트 사이즈 만큼 크기를 변경하여 UILabel 생성
 */

+(UILabel * )getLabelResizeFromText:(NSString *)str fontSize:(float)aFontSize labelRect:(CGRect)aRect
//- (UILabel * )_setStringTolbResize:(NSString *)str fontSize:(float)aFontSize defaultHeight:(float)aHeight defaultWidth:(float)aWidth 
{
    //계산할 문자열이 차지할 공간에 제한을 둘 넓이와 높이를 정한다.
    //예제에서는 Label의 사이즈 제한을 280, 460으로 해두었다.
    //만약 가로나 세로의 길이가 저 수치를 넘어가면 그 이상으로 Label의 사이즈를 크게 만들지 않는다.
    CGSize constraintSize = CGSizeMake(aRect.size.width,3000000.f);
    
    //새로운 Label의 사이즈를 계산한다.
    //NSString 메소드를 이용하여 계산을 하며 길이 계산을 제공하는 아래 메소드를 포함 총 5개이다.
    //아래에 필요한 인자는 출력하고자 하는 문자열, 폰트크기, 제한사이즈, 줄바꿈 정책이다.
    //    CGSize newSize = [str sizeWithFont:[UIFont systemFontOfSize:aFontSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeClip]; 
    CGSize newSize = [str sizeWithFont:[UIFont systemFontOfSize:aFontSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeCharacterWrap];
    
    //위의 계산으로 얻은 사이즈를 이용해서 실제 Label에 적용할 높이를 정한다.
    //Max함수를 이용해서 새로히 얻은 높이와 본래 Label의 높이를 비교하여 높은 값을 가져온다.
    CGFloat labelHeight = MAX(newSize.height, aRect.size.height);
    NSLog(@"newSize.height:%f,labelHeight:%f",newSize.height,labelHeight);
    
    //위에 결과로 얻은 새로운 높이를 Label에 적용한다.
    UILabel * lblResize = [[[UILabel alloc]initWithFrame:CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, labelHeight)]autorelease];
    //    [lbResize setFrame:CGRectMake(lbResize.frame.origin.x, lbResize.frame.origin.y, lbResize.frame.size.width, labelHeight)];
    
    
    //실제 화면에 어떻게 자리를 잡고 있는지 확인하기 위한 배경색 지정
    
    
    //Label에 출력할 폰트 지정(폰트를 꼭 지정해 줘야한다
    //아래나오지만 가변적인 문자열이 차지할 공간을 계산하는데 필요한 인자중에 하나가 사용할 폰트의 사이즈이기 때문이다.
    [lblResize setFont:[UIFont systemFontOfSize:aFontSize]];
    lblResize.backgroundColor = [UIColor clearColor];
    //Label에 문자열을 채워나가다 줄바꿈을 해야 할 때가 왔을 때 줄바꿈의 정책에 대해서 지정한다.
    //이 또한 지정해줘야하며 가변적 문자열이 차지할 공간을 계산하는데 필요한 인자중에 하나이기 때문이다.
    [lblResize setLineBreakMode:UILineBreakModeCharacterWrap];
    
    //setNumberOfLines는 Label에서 몇번째 줄까지 표현할것인가를 정한다.
    //0으로 지정할 경우 무한대
    [lblResize setNumberOfLines:0];
    
    //Label에 원하는 문자를 출력한다.
    [lblResize setText:str];
    
    return lblResize;
    //    [self.view addSubview:lblResize];
}

+(UILabel * )getLabelResize:(UILabel *)lblResize  fontSize:(float)aFontSize
//- (UILabel * )_setStringTolbResize:(NSString *)str fontSize:(float)aFontSize defaultHeight:(float)aHeight defaultWidth:(float)aWidth 
{
    //계산할 문자열이 차지할 공간에 제한을 둘 넓이와 높이를 정한다.
    //예제에서는 Label의 사이즈 제한을 280, 460으로 해두었다.
    //만약 가로나 세로의 길이가 저 수치를 넘어가면 그 이상으로 Label의 사이즈를 크게 만들지 않는다.
    CGSize constraintSize = CGSizeMake(lblResize.frame.size.width,3000000.f);
    
    //새로운 Label의 사이즈를 계산한다.
    //NSString 메소드를 이용하여 계산을 하며 길이 계산을 제공하는 아래 메소드를 포함 총 5개이다.
    //아래에 필요한 인자는 출력하고자 하는 문자열, 폰트크기, 제한사이즈, 줄바꿈 정책이다.
    //    CGSize newSize = [str sizeWithFont:[UIFont systemFontOfSize:aFontSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeClip]; 
    

    CGSize newSize = [lblResize.text sizeWithFont:[UIFont systemFontOfSize:aFontSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeCharacterWrap];
    
    //위의 계산으로 얻은 사이즈를 이용해서 실제 Label에 적용할 높이를 정한다.
    //Max함수를 이용해서 새로히 얻은 높이와 본래 Label의 높이를 비교하여 높은 값을 가져온다.
    CGFloat labelHeight = MAX(newSize.height, lblResize.frame.size.height);
    NSLog(@"newSize.height:%f,labelHeight:%f",newSize.height,labelHeight);
    
    //위에 결과로 얻은 새로운 높이를 Label에 적용한다.
    UILabel * lblNewResize = [[[UILabel alloc]initWithFrame:CGRectMake(lblResize.frame.origin.x, lblResize.frame.origin.y, lblResize.frame.size.width, labelHeight)]autorelease];
    //    [lbResize setFrame:CGRectMake(lbResize.frame.origin.x, lbResize.frame.origin.y, lbResize.frame.size.width, labelHeight)];
    
    
    //실제 화면에 어떻게 자리를 잡고 있는지 확인하기 위한 배경색 지정
    
    
    //Label에 출력할 폰트 지정(폰트를 꼭 지정해 줘야한다
    //아래나오지만 가변적인 문자열이 차지할 공간을 계산하는데 필요한 인자중에 하나가 사용할 폰트의 사이즈이기 때문이다.
    [lblNewResize setFont:[UIFont systemFontOfSize:aFontSize]];
    lblNewResize.backgroundColor = [UIColor clearColor];
    //Label에 문자열을 채워나가다 줄바꿈을 해야 할 때가 왔을 때 줄바꿈의 정책에 대해서 지정한다.
    //이 또한 지정해줘야하며 가변적 문자열이 차지할 공간을 계산하는데 필요한 인자중에 하나이기 때문이다.
    [lblNewResize setLineBreakMode:UILineBreakModeCharacterWrap];
    
    //setNumberOfLines는 Label에서 몇번째 줄까지 표현할것인가를 정한다.
    //0으로 지정할 경우 무한대
    [lblNewResize setNumberOfLines:0];
    
    //Label에 원하는 문자를 출력한다.
    [lblNewResize setText:lblResize.text];
    
    return lblNewResize;
    //    [self.view addSubview:lblResize];
}
+(NSString*)getMoneyFormatFromString:(NSString*)strNumber
{
    int nTmp = [strNumber intValue];
    NSNumberFormatter *fmt = [[[NSNumberFormatter alloc] init]autorelease];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatedString = [fmt stringFromNumber:[NSNumber numberWithInt:nTmp]];
    
    return formatedString;
    
}

+(UILabel*)getMoneyFormatFromLabel:(UILabel*)lblStr
{
    int nTmp = [lblStr.text intValue];
    NSNumberFormatter *fmt = [[[NSNumberFormatter alloc] init]autorelease];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatedString = [fmt stringFromNumber:[NSNumber numberWithInt:nTmp]];
    lblStr.text = formatedString;
    
    return lblStr;
    
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

@end
