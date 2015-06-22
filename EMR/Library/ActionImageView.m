//
//  Cherlsoo.m
//  RealFantasy
//
//  Created by Wenly on 11. 8. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionImageView.h"

@implementation ActionImageView

@synthesize name, level, job, title, ax, ay, vx, vy, sx, sy, an, vn, sn, imageOriginal, goToDestination, pointDestination, acceleration, destinationAccel, status, actionType;

- (void) dealloc{
    [imageOriginal release];
    [name release];
    [job release];
    [title release];
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        //self.image = [UIImage imageNamed:@"Normal_100.png"];
        //self.imageOriginal = self.image;
        //self.frame = CGRectMake(160, 160, 160, 160);
        self.ax = 0;
        self.ay = 0;
        self.vx = 0;
        self.vy = 0;
        self.sx = self.frame.origin.x;
        self.sy = self.frame.origin.y;
        
        self.an = 0;
        self.vn = 0;
        self.sn = 0;
        
        self.name = @"Object";
        self.level = 1;
        self.job = @"";
        self.title = @"";
        status=statusStop;
        destinationAccel = 0.1;
    }
    return self;
}

- (void)doAction{
    if (status == statusStop) {
        status = statusActive;
        if (self.imageOriginal == nil) {
            self.imageOriginal = self.image;
            self.sx = self.frame.origin.x;
            self.sy = self.frame.origin.y;
            screenHeight = self.superview.frame.size.height;//[[UIScreen mainScreen]bounds].size.height;
        }
        //an = 2;
        [self doActionThread];// go thread.
    }
    NSLog(@"destinationAccel = %.1f",destinationAccel);
}

- (void)doActionThread{
    if (status==statusActive) {
        ax = 0;
        ay = 0;
        
        if (goToDestination) {
            ax = (pointDestination.x-sx)*destinationAccel;
            ay = ((screenHeight-pointDestination.y)-sy)*destinationAccel;
            if (vx*vx>ax*ax*100) {
                vx=ax*10;
            }
            
            if (vy*vy>ay*ay*100) {
                vy=ay*10;
            }
            
//            if (vy>ay*10||vy<ay*10) {
//                vy=ay*10;
//            }
        }
        //an = 0;
        
        //ax += acceleration.x*accelK;
        //ay += acceleration.y*accelK;
        if (actionType == actionTypeSwing) {
            if (an == 0) {
                an = 2;
            }
            else if (sn > 2) {
                an = -2;
            }
            else if (sn < -2) {
                an = 2;
            }
        }
        else if(actionType == actionTypeRotating){
            an = 0.02;
        }
                
        if (vx > 0) {
            ax -= vx*vx*airK; // Fx
        }
        else{
            ax += vx*vx*airK; // Fx
        }
        if (vy > 0) {
            ay -= vy*vy*airK; // Object가 받는 힘.
        }
        else{
            ay += vy*vy*airK; // Object가 받는 힘.
        }
        if (vn > 0) {
            an -= vn*vn*airNK;
        }
        else{
            an += vn*vn*airNK;
        }
        
        vx += ax; // 속도 변화
        vy += ay;
        
//        if (vx>0.01) {
//            vx -= 0.01;
//        }
//        else if(vx < -0.01){
//            vx += 0.01;
//        }
//        else{
//            vx = 0;
//        }
//        
//        if (vy>0.01) {
//            vy -= 0.01;
//        }
//        else if(vy < -0.01){
//            vy += 0.01;
//        }
//        else{
//            vy = 0;
//        }
        
        
        vn += an;
        
        sx += vx; // 위치 변화.
        sy += vy;
        sn += vn;
        
        if (sx < self.frame.size.width/2) { // 왼쪽 벽에 닿았을 경우.
            sx = self.frame.size.width/2;
            vx = -vx*elasticity;
        }
        else if(sx > 320 - self.frame.size.width/2){
            sx = 320 - self.frame.size.width/2;
            vx = -vx*elasticity;
        }
        
        if (sy < self.frame.size.height/2 + 20) { // 바닥에 닿았을 경우.
            sy = self.frame.size.height/2 + 20;
            vy = -vy*elasticity;
        }
        else if (sy > screenHeight - self.frame.size.height/2){ // 천정에 닿았을 경우.
            sy = screenHeight - self.frame.size.height/2;
            vy = -vy*elasticity;
        }
        
        CGRect newFrame = self.frame;
        newFrame.origin.x = (int)(sx)-self.frame.size.width/2;
        newFrame.origin.y = screenHeight-(int)(sy)-self.frame.size.height/2;
        self.frame = newFrame;
        
        //self.image = [self.imageOriginal imageRotatedByDegrees:sn];
        //NSLog(@"sx = %.1f vx = %.1f ax = %.1f",sx,vx,ax);
        [self performSelector:@selector(doActionThread) withObject:nil afterDelay:0.02];
    }
}

- (void)setDestination:(CGPoint)point{
    pointDestination = point;
}

- (void)gotoDestination:(CGPoint)point{
    pointDestination = point;
    goToDestination = YES;
    destinationAccel = 0.01;
}

- (void)cancelDestination{
    goToDestination = NO;
}

- (void)stopAnimating{
    status=statusStop;
}

- (void)jump{
    vy += 20; 
}
     
     

@end
