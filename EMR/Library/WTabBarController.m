//
//  ProfileStepViewController.m
//  bulcuhk
//
//  Created by Wenly on 12. 11. 29..
//  Copyright (c) 2012년 MangoApps. All rights reserved.
//

#import "WtabBarController.h"
#import "Session.h"

@interface WTabBarController ()

@end

@implementation WTabBarController

@synthesize selectedIndex;

- (void)dealloc{
    [_viewTabBar release];
    [_viewControllers release];
    [_tabBarButtons release];
    [_viewContent release];
    [_viewBackground release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil viewControllers:(NSArray*)viewControllers buttonTitles:(NSArray*)buttonTitles fontSize:(CGFloat)size tabBarFrame:(CGRect)tabBarFrame contentFrame:(CGRect)contentFrame backgroundView:(UIView*)viewBackground{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if  (self){
        self.viewControllers = viewControllers;
        
        self.buttonTitles = buttonTitles;
        self.buttonTitleFontSize = size;
        self.backgroundColorDeselected = [UIColor whiteColor];
        self.backgroundColorSelected = [UIColor orangeColor];
        self.fontColorSelected = [UIColor whiteColor];
        self.fontColorDeselected = [UIColor blackColor];
        self.tabBarFrame = tabBarFrame;
        self.contentFrame = contentFrame;
        
        self.viewBackground = viewBackground;
        
        if(contentFrame.size.width==0 && contentFrame.size.height==0){
            self.contentFrame = self.view.frame;
        }
        
        for (UIViewController *viewController in viewControllers) {
            viewController.view.frame = CGRectMake(0, 0, contentFrame.size.width, contentFrame.size.height);
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.viewBackground!=nil) {
        
        [self.view insertSubview:self.viewBackground atIndex:0];
        
    }
    
    _tabBarButtons = [[NSMutableArray alloc]init];

    self.viewTabBar.frame = self.tabBarFrame;
    self.viewContent.frame = self.contentFrame;
    
    for(NSString *title in self.buttonTitles){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:self.buttonTitleFontSize]];
        
        button.tag = [self.buttonTitles indexOfObject:title];
        [button.titleLabel setNumberOfLines:0];
        [self.viewTabBar addSubview:button];
        
        CGFloat width = self.viewTabBar.frame.size.width/self.buttonTitles.count;
        CGFloat height = self.viewTabBar.frame.size.height;
        button.frame = CGRectMake(button.tag*width, 0, width, height);
        
        [button addTarget:self action:@selector(actiontabBar:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarButtons addObject:button];
        
    }
    
    [self inittabBar];
    
    [self applyType:self.type];
	// Do any additional setup after loading the view.
}

- (void)inittabBar{
    for(UIButton *button in _tabBarButtons){
        if(button.tag==0){
            if(button.tag==0){
                self.selectedIndex = -1;
                [self actiontabBar:button];
            }
        }
    }
}

- (void)actiontabBar:(UIButton*)button{
    //if(self.selectedIndex==button.tag)return;
    [self selectIndex:button.tag];
}

- (void)selectIndex:(int)index{
    if (self.lockTabbar) {
        return;
    }
    self.selectedIndex = index;
    
    for(UIButton *aButton in self.tabBarButtons){
        if(aButton.tag==index){
            [self setButton:aButton selected:YES];
        }
        else{
            [self setButton:aButton selected:NO];
        }
    }
    
    if (index < self.viewControllers.count) {
        for (UIView *view in self.viewContent.subviews) {
            if(view != self.viewTabBar){
                [view removeFromSuperview];
            }
        }
        
        id frontObject = [self.viewControllers objectAtIndex:index];
        UIViewController *frontViewController = frontObject;
        
//        if(frontObject == [[Session manager] viewControllerVitalSign]){
//            [[[Session manager]viewControllerVitalSign] initForNewPatient];
//        }
//        else if(frontObject == [[Session manager] viewControllerPrescribe]){
//            [[[Session manager]viewControllerPrescribe] initForNewPatient];
//        }
//        else if(frontObject == [[Session manager] viewControllerResult]){
//            [[[Session manager]viewControllerResult] initForNewPatient];
//        }
//        else if(frontObject == [[Session manager] viewControllerNurse]){
//            [[[Session manager]viewControllerNurse] initForNewPatient];
//        }
//        else if(frontObject == [[Session manager] viewControllerConsult]){
//            [[[Session manager]viewControllerConsult] initForNewPatient];
//        }
//        else if(frontObject == [[Session manager] viewControllerProgress]){
//            [[[Session manager]viewControllerProgress] initForNewPatient];
//        }

        [[Session manager]initAllPages];
        
        [self.viewContent addSubview:frontViewController.view];
        
        [self.viewContent bringSubviewToFront:self.viewTabBar];
    }
    
    if (self.type==typeWTabBarControllerMain) {
        if (index==0) {
//            [[[Session manager]tabBarControllerPatients]selectIndex:0];// Patient 탭을 누르면 안쪽의 환자목록 탭을 보여주어야 한다.
        }
    }
    else if (self.type==typeWTabBarControllerPatients) {
        UIButton *button = [self buttonWithTag:index];
        if (button.tag < 5) {
            [self setTitle:button.titleLabel.text];
        }
        else if(button.tag==5){
            [self setTitle:@"협진조회"];
        }
        else if(button.tag==6){
            [self setTitle:@"Progress Note"];
        }
    }
}

- (UIButton*)buttonWithTag:(int)tag{
    for (UIButton *button in self.tabBarButtons) {
        if (button.tag==tag) {
            return button;
        }
    }
    return nil;
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    
//    ViewPatientCommon *common = (ViewPatientCommon*)self.viewBackground;
//    
//    common.viewToolbar.labelTitle.text = title;
    
}

- (void)setButton:(UIButton*)button selected:(BOOL)select{

    [button setSelected:select];
    
    if (select){
        NSLog(@"button %d select %d",button.tag, select);
        //[button setBackgroundColor:self.backgroundColorSelected];
        //[button setTitleColor:self.fontColorSelected forState:UIControlStateNormal];
        
    }
    else{
        NSLog(@"button %d deselect %d",button.tag, select);
        //[button setBackgroundColor:self.backgroundColorDeselected];
        //[button setTitleColor:self.fontColorDeselected forState:UIControlStateNormal];
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyType:(int)type{
    self.type = type;
    if (self.type==typeWTabBarControllerMain) {
        for (UIButton *button in self.tabBarButtons) {
            
            [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
            
            NSString *imageFilenameNormal = [NSString stringWithFormat:@"navi_0%d.png",button.tag+1];
            NSString *imageFilenameSelected = [NSString stringWithFormat:@"navi_ov_0%d.png",button.tag+1];
            
            [button setBackgroundImage:[UIImage imageNamed:imageFilenameNormal] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:imageFilenameSelected] forState:UIControlStateSelected];
            
        }
    }
    else if (self.type==typeWTabBarControllerPatients) {
        for (UIButton *button in self.tabBarButtons) {
            
            [button setBackgroundImage:[UIImage imageNamed:@"menu_off_bg.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"menu_on_bg.png"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:35/255.0 green:135/255.0 blue:203/255.0 alpha:1] forState:UIControlStateSelected];
            
            [button setEnabled:NO];
            
            switch (button.tag) {
                case 0:
                    button.hidden = YES;
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
                case 3:
                    
                    break;
                case 4:
                    
                    break;
                case 5:
                    
                    break;
                case 6:
                    
                    break;
                case 7:
                    button.hidden = YES;
                    break;
                case 8:
                    button.hidden = YES;
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)enableAllButtons{
    for (UIButton *button in self.tabBarButtons) {
        button.enabled = YES;
    }
}

@end
