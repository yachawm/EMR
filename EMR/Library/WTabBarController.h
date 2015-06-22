//
//  ProfileStepViewController.h
//  bulcuhk
//
//  Created by Wenly on 12. 11. 29..
//  Copyright (c) 2012년 MangoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum typeWTabBarController{
    typeWTabBarControllerMain = 1,
    typeWTabBarControllerPatients = 2,
}typeWTabBarController;

@interface WTabBarController : UIViewController{
    
}
@property (nonatomic, assign) BOOL lockTabbar;
@property (nonatomic, assign) int type;

@property (nonatomic, retain) NSArray *viewControllers;

@property (nonatomic, assign) int selectedIndex;
@property (retain, nonatomic) IBOutlet UIView *viewTabBar;
@property (nonatomic, retain) NSMutableArray *tabBarButtons;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) CGFloat buttonTitleFontSize;
@property (nonatomic, assign) CGRect tabBarFrame,contentFrame;

@property (nonatomic, retain) UIColor *backgroundColorSelected;
@property (nonatomic, retain) UIColor *backgroundColorDeselected;

@property (nonatomic, retain) UIColor *fontColorSelected;
@property (nonatomic, retain) UIColor *fontColorDeselected;
@property (retain, nonatomic) IBOutlet UIView *viewContent;
@property (retain, nonatomic) UIView *viewBackground;

- (id)initWithNibName:(NSString *)nibNameOrNil viewControllers:(NSArray*)viewControllers buttonTitles:(NSArray*)buttonTitles fontSize:(CGFloat)size tabBarFrame:(CGRect)tabBarFrame contentFrame:(CGRect)contentFrame backgroundView:(UIView*)viewBackground;

- (void)selectIndex:(int)index;

- (void)applyType:(int)type;

- (void)enableAllButtons;

@end
