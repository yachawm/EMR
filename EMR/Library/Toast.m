//
//  Toast.m
//


#import "Toast.h"
#import <QuartzCore/CALayer.h>

#define INFLATE_WIDTH			20
#define INFLATE_HEIGHT			50

#define MARGIN_WIDTH			15
#define MARGIN_HEIGHT			10

#define BACKGROUND_ALPHA		0.9f
#define ANIMATION_DURATION		0.3f

#define UIColorMake(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:(float)a/255]
#define CGMakeInflateRect(rc, xx, yy) CGRectMake(rc.origin.x - (xx), rc.origin.y - (yy), rc.size.width + (xx)*2, rc.size.height + (yy)*2)


static NSMutableSet* g_toasts = nil;

@implementation Toast

+ (id)toastWithMessage:(NSString*)message duration:(NSTimeInterval)duration align:(ToastAlign)align fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor
{
    return [[Toast alloc] initWithMessage:message duration:duration align:align fontSize:fontSize backgroundColor:backgroundColor];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_timer invalidate];
//	[_timer release];
//	[_message release];
//	[_backgroundColor release];
//	
//    [super dealloc];
}

- (id)initWithMessage:(NSString*)message duration:(NSTimeInterval)duration align:(ToastAlign)align fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor
{
	if([message length] == 0)
	{
//		[self release];
		return nil;
	}
	
    if(self = [super init])
	{
		@synchronized([Toast class])
		{
			for(Toast* t in g_toasts)
				[t cancel];
			
			if(g_toasts == nil)
				g_toasts = [[NSMutableSet alloc] initWithCapacity:1];
			
			[g_toasts addObject:self];
		}
		
		_align = align;
		_message = [message copy];
				
		_duration = duration;
		_fontSize = fontSize;
        _backgroundColor = backgroundColor;
		
		self.userInteractionEnabled = NO;
		self.clipsToBounds = YES;
		self.layer.cornerRadius = 5;
		self.layer.borderWidth = 0;  //테두리 선
		self.layer.borderColor = [UIColorMake(10, 10, 10, 230) CGColor];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didChangeStatusBarOrientationNotification:)
													 name:UIApplicationDidChangeStatusBarOrientationNotification
												   object:nil];
    }
    return self;
}

- (void)close
{
	@synchronized([Toast class])
	{
		[g_toasts removeObject:self];
		if([g_toasts count] == 0)
		{
//			[g_toasts release];
			g_toasts = nil;
		}
	}
	
	[_timer invalidate];
//	[_timer release];
	_timer = nil;
	[self removeFromSuperview];
}

- (void)cancel
{
	self.hidden = YES;
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{	
	if (orientation == UIInterfaceOrientationLandscapeLeft)
		return CGAffineTransformMakeRotation(M_PI*1.5);
	else if (orientation == UIInterfaceOrientationLandscapeRight)
		return CGAffineTransformMakeRotation(M_PI/2);
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		return CGAffineTransformMakeRotation(-M_PI);
	else
		return CGAffineTransformIdentity;
}

- (void)calculateFrame:(UIInterfaceOrientation)orientation
{
	CGRect parentFrame = [UIScreen mainScreen].bounds;	   
	CGRect parentRotate;
	
	CGFloat width = parentFrame.size.width;
	CGFloat height = parentFrame.size.height;
	
	BOOL landscape = UIInterfaceOrientationIsLandscape(orientation);
	
	if(landscape)
		parentRotate = CGRectMake(0, 0, parentFrame.size.height, parentFrame.size.width);
	else
		parentRotate = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);
	
	CGRect inflateFrame = CGMakeInflateRect(parentRotate, -(INFLATE_WIDTH+MARGIN_WIDTH), -(INFLATE_HEIGHT+MARGIN_HEIGHT));
	CGRect frame = inflateFrame;
	
	CGSize size = [_message sizeWithFont:[UIFont systemFontOfSize:_fontSize] constrainedToSize:frame.size lineBreakMode:UILineBreakModeWordWrap];	

	CGRect bounds = CGMakeInflateRect(CGRectMake(MARGIN_WIDTH, MARGIN_HEIGHT, size.width, size.height), MARGIN_WIDTH, MARGIN_HEIGHT);
	
	CGPoint point = CGPointMake((parentFrame.size.width)/2, parentFrame.size.height/2);
	
	if(_align == ToastAlignTop)
	{
		if(landscape)
			point = CGPointMake(parentFrame.size.width/2, bounds.size.height/2 + INFLATE_HEIGHT + (height-width)/2-10);
		else
			point = CGPointMake(parentFrame.size.width/2, bounds.size.height/2 + INFLATE_HEIGHT-10);
	}
	else if(_align == ToastAlignBottom)
	{
		if(landscape)
			point = CGPointMake(parentFrame.size.width/2, parentFrame.size.height - (bounds.size.height/2 + INFLATE_HEIGHT) - (height-width)/2);
		else
			point = CGPointMake(parentFrame.size.width/2, parentFrame.size.height - (bounds.size.height/2 + INFLATE_HEIGHT));
	}
	
	point = CGPointApplyAffineTransform(point, CGAffineTransformMakeTranslation(-(width/2), -(height/2)));
	point = CGPointApplyAffineTransform(point, [self transformForOrientation:orientation]);
	point = CGPointApplyAffineTransform(point, CGAffineTransformMakeTranslation(width/2, height/2));
	
	frame = CGRectMake(point.x-bounds.size.width/2, point.y-bounds.size.height/2, bounds.size.width, bounds.size.height);
	
	self.frame = frame;
	self.transform = [self transformForOrientation:orientation];	
}

- (void)didChangeStatusBarOrientationNotification:(NSNotification*)notification
{
	//UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	//[self calculateFrame:orientation];
	[self cancel];
}

- (void)fadeInAnimationStopped
{
//	[_timer release];
    _timer = nil;
	_timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(timerFired:) userInfo:nil repeats:NO]
			  ;
}

- (void)fadeOutAnimationStopped
{
	[self close];
}

- (void)timerFired:(NSTimer*)timer
{
	self.alpha = BACKGROUND_ALPHA;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:ANIMATION_DURATION];
	[UIView setAnimationDidStopSelector:@selector(fadeOutAnimationStopped)];
	self.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)show
{	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	self.backgroundColor = _backgroundColor ? _backgroundColor : [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.9];
	self.alpha = 0.0;
	
	[self calculateFrame:orientation];
	
	UILabel* labelMessage = [[UILabel alloc] initWithFrame:CGMakeInflateRect(self.bounds, -MARGIN_WIDTH, -MARGIN_HEIGHT)];
	labelMessage.text = _message;
	labelMessage.font = [UIFont systemFontOfSize:_fontSize];
	labelMessage.textColor = [UIColor whiteColor];
	labelMessage.backgroundColor = [UIColor clearColor];
//	labelMessage.shadowColor = [UIColor blackColor];
	labelMessage.lineBreakMode = UILineBreakModeWordWrap;
	labelMessage.numberOfLines = 0;
	
	[self addSubview:labelMessage];
//	[labelMessage release];
	
	self.windowLevel = UIWindowLevelAlert;
	self.hidden = NO;
	self.transform = CGAffineTransformScale([self transformForOrientation:orientation], 0.9, 0.9);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:ANIMATION_DURATION];
	[UIView setAnimationDidStopSelector:@selector(fadeInAnimationStopped)];
	self.alpha = BACKGROUND_ALPHA;
	self.transform = CGAffineTransformScale([self transformForOrientation:orientation], 1, 1);
	[UIView commitAnimations];
}

@end
