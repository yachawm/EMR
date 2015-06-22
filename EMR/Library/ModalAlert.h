//
//  MyFriendDetailViewController.h
//  WePic
//
//  Created by KI JOO MOON on 11. 2. 8..
//  Copyright 2011 PnP Soft Inc./Planning Team. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Toast.h"
@interface ModalAlert : NSObject
+ (void)sayToMessageWithToast:(NSString*)msg;
+ (NSString *) ask: (NSString *) question withTextPrompt: (NSString *) prompt;
+ (NSArray *) ask: (NSString *) question withFirstTextPrompt: (NSString *) prompt1 withSecondTextPrompt: (NSString *) prompt2;
+ (NSUInteger) ask: (NSString *) question withCancel: (NSString *) cancelButtonTitle withButtons: (NSArray *) buttons;
+ (void) say: (id)formatstring,...;
+ (BOOL) ask: (id)formatstring,...;
+ (BOOL) confirm: (id)formatstring,...;
@end
