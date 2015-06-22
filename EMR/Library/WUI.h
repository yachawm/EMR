//
//  UIManager.h
//  SPC
//
//  Created by Wenly on 2014. 12. 2..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"



@class ViewController;

@interface WUI : NSObject

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) ViewController *rootViewController;
@property (nonatomic, retain) NSMutableArray *viewControllers;


+(WUI *)manager;


- (ViewControllerCommon*)currentViewController;

- (void)presentViewController:(ViewControllerCommon*)viewController animate:(BOOL)animate;


- (void)dismissViewControllerAnimate:(BOOL)animate;

- (void)keepMainButtonFront;

- (void)keepMainTopbarFront;

- (void)addMainTopbarFrontToView:(UIView*)view;


@end
