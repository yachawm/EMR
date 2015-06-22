//
//  Toast.h
//

//

#import <UIKit/UIKit.h>

typedef enum {ToastAlignCenter = 0, ToastAlignTop, ToastAlignBottom } ToastAlign;

@interface Toast : UIWindow
{
	NSString*	_message;
	CGFloat		_fontSize;
	UIColor*	_backgroundColor;
	ToastAlign	_align;
	
	NSTimer*		_timer;	
	NSTimeInterval	_duration;
}

+ (id)toastWithMessage:(NSString*)message 
			  duration:(NSTimeInterval)duration 
				 align:(ToastAlign)align
			  fontSize:(CGFloat)fontSize
	   backgroundColor:(UIColor*)backgroundColor;

- (id)initWithMessage:(NSString*)message 
			 duration:(NSTimeInterval)duration 
				align:(ToastAlign)align
			 fontSize:(CGFloat)fontSize 
	  backgroundColor:(UIColor*)backgroundColor;

- (void)show;
- (void)cancel;
@end

extern UIView* g_ToastParentView;

#define TOAST_SHORT(msg)					[[Toast toastWithMessage:msg duration:2.0 align:ToastAlignBottom fontSize:16.0f backgroundColor:nil] show];
#define TOAST_LONG(msg)						[[Toast toastWithMessage:msg duration:5.0 align:ToastAlignBottom fontSize:16.0f backgroundColor:nil] show];
#define TOAST(msg, duration_)				[[Toast toastWithMessage:msg duration:duration_ align:ToastAlignBottom fontSize:16.0f backgroundColor:nil] show];


