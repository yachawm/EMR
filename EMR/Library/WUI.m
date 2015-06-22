//
//  UIManager.m
//  SPC
//
//  Created by Wenly on 2014. 12. 2..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import "WUI.h"
#import "ViewControllerCommon.h"
#import "ViewController.h"

#define kAnimationDuration 0.35


@implementation WUI

static WUI *singleTon= nil;

+(WUI *)manager
{
    @synchronized([WUI class]) // 오직 하나의 쓰레드만 접근할 수 있도록 함.
    {
        
        if(singleTon==nil)
        {
            
            singleTon = [[self alloc] init];
            if (nil != singleTon) {
                
            }
        }
    }
    return singleTon;
    
}

- (id)init
{
    if((self = [super init]) )// 초기화 선언부분
    {
        _viewControllers = [[NSMutableArray alloc]init];
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        self.rootViewController = (ViewController*)self.appDelegate.window.rootViewController;
        
        
        
        [self performSelector:@selector(didLoaded) withObject:nil afterDelay:0.1];
        
    }
    return self;
}

- (void)didLoaded{
    
}

/**
 * @brief 새로운 뷰를 띄운다.
 * @param (ViewControllerCommon*)viewController animate:(BOOL)animate
 * @return
 * @author Chang-hyeok Yang
 */
- (void)presentViewController:(ViewControllerCommon*)viewController animate:(BOOL)animate{
    
    ViewControllerCommon *prevViewController = nil;
    
    if (self.viewControllers.count>0) {
        prevViewController = self.viewControllers.lastObject;
    }
    
    viewController.view.tag = self.viewControllers.count;
    
    [self.viewControllers addObject:viewController];
    
    
    if (viewController.typePresent==kTypePresentApple) {
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (prevViewController!=nil && prevViewController.typePresent==kTypePresentApple) {
            [prevViewController presentViewController:viewController animated:animate completion:nil];
        }
        else{
            [self.rootViewController presentViewController:viewController animated:animate completion:nil];
        }
        
        
    }
    else{
        if(animate) {
            viewController.view.alpha = 0;
        }
        
        [self.rootViewController.view addSubview:viewController.view];
        
        if ([WUtil isiPhone5]==NO) {
            viewController.view.frame = CGRectMake(0, 0, 320, 480);
        }
        
        //[self.appDelegate.window.rootViewController presentViewController:viewController animated:animate completion:nil];
        
        if(animate) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kAnimationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            viewController.view.alpha = 1;
            [UIView commitAnimations];
        }

    }
    
    
    [self controlViewMemory];
}

/**
 * @brief 현재 뷰를 다른 뷰로 교환한 후 제거한다.
 * @param (ViewControllerCommon*)toViewController animate:(BOOL)animate
 * @return
 * @author Chang-hyeok Yang
 */
- (void)changeViewControllerTo:(ViewControllerCommon*)toViewController animate:(BOOL)animate{
    
    if (self.viewControllers.count==0) {
        return;
    }
    
    ViewControllerCommon *viewController = [self.viewControllers lastObject];
    
    toViewController.view.tag = viewController.view.tag;
    
    [self.viewControllers addObject:toViewController];
    
    toViewController.view.tag = [self.viewControllers indexOfObject:toViewController];
    
    if(animate) {
        viewController.view.alpha = 1;
        toViewController.view.alpha = 0;
    }
    
    [self.rootViewController.view addSubview:toViewController.view];
    
    if ([WUtil isiPhone5]==NO) {
        toViewController.view.frame = CGRectMake(0, 0, 320, 480);
    }
    
    if(animate) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(changeLastViewControllerFinish)];
        viewController.view.alpha = 1;
        toViewController.view.alpha = 1;
        [UIView commitAnimations];
    }
    else{
        [self changeLastViewControllerFinish];
    }
}

/**
 * @brief 현재 뷰를 제거한다.
 * @param (BOOL)animate
 * @return
 * @author Chang-hyeok Yang
 */
- (void)dismissViewControllerAnimate:(BOOL)animate{
    
    ViewControllerCommon *viewController = [self.viewControllers lastObject];
    
    if (viewController.typePresent==kTypePresentApple) {
        [self.rootViewController dismissViewControllerAnimated:animate completion:^
        {
            [self removeLastViewController];
        }];
        
    }
    else{
        if(animate) {
            viewController.view.alpha = 1;
        }
        
        if(animate) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kAnimationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeLastViewController)];
            viewController.view.alpha = 0;
            [UIView commitAnimations];
        }
        else{
            [self removeLastViewController];
        }
    }
    
    
}

- (void)removeLastViewController{
    
    ViewControllerCommon *viewController = [self.viewControllers lastObject];
    [viewController.view removeFromSuperview];
    NSLog(@"before remove viewController.retainCount = %d",viewController.retainCount);
    [self.viewControllers removeObject:viewController];
    NSLog(@"after remove viewController.retainCount = %d",viewController.retainCount);
    //viewController = nil;
    
    [self controlViewMemory];
}

- (void)changeLastViewControllerFinish{
    
    if (self.viewControllers.count>1) {
        ViewControllerCommon *viewController = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
        
        [viewController.view removeFromSuperview];
        [self.viewControllers removeObject:viewController];
        //viewController = nil;

    }
    
    [self controlViewMemory];
    
}

/**
 * @brief 뷰가 여러개일 경우 뒤의 보이지 않는 뷰는 숨겨서 연산하지 않게 한다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)controlViewMemory{
    //return;
    for (ViewControllerCommon* vc in self.viewControllers) {
        int index = [self.viewControllers indexOfObject:vc];//vc.view.tag;
        if (index > 1) {
            NSLog(@"index[%d] hidden yes", index);
            vc.view.hidden = YES;
        }
        else{
            vc.view.hidden = NO;
        }
    }
}

/**
 * @brief 메인 네비게이션 버튼을 맨 앞으로 재정렬한다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)keepMainButtonFront{
//    for (UIButton *button in self.rootViewController.menuButtons) {
//        [self.rootViewController.view bringSubviewToFront:button];
//    }
}

/**
 * @brief 메인 탑 바를 맨 앞으로 재정렬한다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)keepMainTopbarFront{
    
//    [self.rootViewController.view bringSubviewToFront:self.rootViewController.viewTopBar];
    //[self keepMainTopbarFrontToView:self.rootViewController.view];
}

/**
 * @brief 메인 탑 바를 특정 뷰에 추가한다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)addMainTopbarFrontToView:(UIView*)view{
    UIView *viewTopBar = [WUtil loadViewFromNibName:@"ViewTopBar"];
    viewTopBar.frame = CGRectMake(viewTopBar.frame.origin.x, 20, viewTopBar.frame.size.width, viewTopBar.frame.size.height);
    [view addSubview:viewTopBar];
    
}

- (ViewControllerCommon*)currentViewController{
    if (self.viewControllers.count>0) {
        return self.viewControllers.lastObject;
    }
    return self.rootViewController;
}

@end
