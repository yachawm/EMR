//
//  MyFriendDetailViewController.h
//  WePic
//
//  Created by KI JOO MOON on 11. 2. 8..
//  Copyright 2011 PnP Soft Inc./Planning Team. All rights reserved.
//


#import "ModalAlert.h"
#import <stdarg.h>

#define TEXT_FIELD_TAG	9999

@interface ModalAlertDelegate : NSObject <UIAlertViewDelegate, UITextFieldDelegate>
{
	CFRunLoopRef currentLoop;
	NSString *text;
	NSUInteger index;
}
@property (assign) NSUInteger index;
@property (retain) NSString *text;
@end

@implementation ModalAlertDelegate
@synthesize index;
@synthesize text;


-(id) initWithRunLoop: (CFRunLoopRef)runLoop
{
	if (self = [super init]) currentLoop = runLoop;
	return self;
}

// User pressed button. Retrieve results
-(void)alertView:(UIAlertView*)aView clickedButtonAtIndex:(NSInteger)anIndex
{
	UITextField *tf = (UITextField *)[aView viewWithTag:TEXT_FIELD_TAG];
	if (tf) self.text = tf.text;
	self.index = anIndex;
	CFRunLoopStop(currentLoop);
}

- (BOOL) isLandscape
{
	return ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight);
}

// Move alert into place to allow keyboard to appear
- (void) moveAlert: (UIAlertView *) alertView
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25f];
	if (![self isLandscape])
		alertView.center = CGPointMake(160.0f, 180.0f);
	else
		alertView.center = CGPointMake(240.0f, 190.0f);
	[UIView commitAnimations];
	
	[[alertView viewWithTag:TEXT_FIELD_TAG] becomeFirstResponder];
}

- (void) dealloc
{
	self.text = nil;
//	[super dealloc];
}

@end

@implementation ModalAlert


+ (void)sayToMessageWithToast:(NSString*)msg
{
	[[Toast toastWithMessage:msg
					duration:2.0
					   align:ToastAlignTop
					fontSize:12.0f
			 backgroundColor:[UIColor clearColor]]
	 show];
}


+ (NSUInteger) ask: (NSString *) question withCancel: (NSString *) cancelButtonTitle withButtons: (NSArray *) buttons
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:nil delegate:madelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	for (NSString *buttonTitle in buttons) [alertView addButtonWithTitle:buttonTitle];
	[alertView show];
	
	// Wait for response
	CFRunLoopRun();
	
	// Retrieve answer
	NSUInteger answer = madelegate.index;
//	[alertView release];
//	[madelegate release];
	return answer;
}

+ (void) say: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	[ModalAlert ask:statement withCancel:@"확인" withButtons:nil];
//	[statement release];
}

+ (BOOL) ask: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = ([ModalAlert ask:statement withCancel:nil withButtons:[NSArray arrayWithObjects:@"Yes", @"No", nil]] == 0);
//	[statement release];
	return answer;
}

+ (BOOL) confirm: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = [ModalAlert ask:statement withCancel:@"Cancel" withButtons:[NSArray arrayWithObject:@"OK"]];
//	[statement release];
	return	answer;
}

+(NSString *) textQueryWith: (NSString *)question prompt: (NSString *)prompt button1: (NSString *)button1 button2:(NSString *) button2
{
	// Create alert
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:@"\n" delegate:madelegate cancelButtonTitle:button1 otherButtonTitles:button2, nil];
	
	// Build text field
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
	tf.borderStyle = UITextBorderStyleRoundedRect;
	tf.tag = TEXT_FIELD_TAG;
	tf.placeholder = prompt;
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.keyboardType = UIKeyboardTypeAlphabet;
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	// Show alert and wait for it to finish displaying
	[alertView show];
	while (CGRectEqualToRect(alertView.bounds, CGRectZero));
	
	// Find the center for the text field and add it
	CGRect bounds = alertView.bounds;
	tf.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 10.0f);
	[alertView addSubview:tf];
//	[tf release];
	
	// Set the field to first responder and move it into place
	[madelegate performSelector:@selector(moveAlert:) withObject:alertView afterDelay: 0.7f];
	
	// Start the run loop
	CFRunLoopRun();
	
	// Retrieve the user choices
	NSUInteger index = madelegate.index;
    NSString *answer = [madelegate.text copy];// autorelease];
	if (index == 0) answer = nil; // assumes cancel in position 0
	
//	[alertView release];
//	[madelegate release];
	return answer;
}


//create by MangoApps
+(NSArray *) textQueryWith: (NSString *)question prompt1: (NSString *)prompt1 prompt2: (NSString *)prompt2 button1: (NSString *)button1 button2:(NSString *) button2
{
	// Create alert
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:@"\n\n\n\n" delegate:madelegate cancelButtonTitle:button1 otherButtonTitles:button2, nil];
	
	// Build text field 1
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
	tf.borderStyle = UITextBorderStyleRoundedRect;
	tf.tag = TEXT_FIELD_TAG;
	tf.placeholder = prompt1;
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.keyboardType = UIKeyboardTypeAlphabet;
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	// Build text field 2
	UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 35.0f, 260.0f, 30.0f)];
	tf2.borderStyle = UITextBorderStyleRoundedRect;
	tf2.tag = TEXT_FIELD_TAG;
	tf2.placeholder = prompt2;
	tf2.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf2.keyboardType = UIKeyboardTypeAlphabet;
	tf2.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf2.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf2.autocorrectionType = UITextAutocorrectionTypeNo;
	tf2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	// Show alert and wait for it to finish displaying
	[alertView show];
	while (CGRectEqualToRect(alertView.bounds, CGRectZero));
	
	// Find the center for the text field and add it
	CGRect bounds = alertView.bounds;
	tf.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 30.0f);
	tf2.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f + 10.0f);
	[alertView addSubview:tf];
	[alertView addSubview:tf2];
//	[tf release];
//	[tf2 release];
	
	// Set the field to first responder and move it into place
	[madelegate performSelector:@selector(moveAlert:) withObject:alertView afterDelay: 0.7f];
	
	// Start the run loop
	CFRunLoopRun();
	
	// Retrieve the user choices
	NSUInteger index = madelegate.index;
	
	
	NSLog(@"index : %lu ", (unsigned long)index);
	
    NSArray *resultArray = [[NSArray alloc]initWithObjects:tf.text, tf2.text, nil];
	
	if (index == 0)
	{
		resultArray = nil; // assumes cancel in position 0
		
	}
	
//	[alertView release];
//	[madelegate release];
	
	return resultArray;
}

+ (NSString *) ask: (NSString *) question withTextPrompt: (NSString *) prompt
{
	return [ModalAlert textQueryWith:question prompt:prompt button1:@"Cancel" button2:@"OK"];
}

+ (NSArray *) ask: (NSString *) question withFirstTextPrompt: (NSString *) prompt1 withSecondTextPrompt: (NSString *) prompt2
{
	return [ModalAlert textQueryWith:question prompt1:prompt1 prompt2:prompt2 button1:@"Cancel" button2:@"OK"];
}

@end