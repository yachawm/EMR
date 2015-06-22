//
//  Cherlsoo.h
//  RealFantasy
//
//  Created by Wenly on 11. 8. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage-Extensions.h"

#define airK 0.001
#define airNK 0.002
#define groundNK 0.5
#define elasticity 0.8
#define gForce -1
#define accelK 16

enum status{
    statusStop = 0,
    statusActive = 1
};

enum actionType{
    actionTypeNormal = 0,
    actionTypeSwing = 1,
    actionTypeRotating = 2
    
};

@interface ActionImageView : UIImageView {
    CGFloat screenHeight;
    UIImage *imageOriginal;
    NSString *name;
    int level;
    NSString *job;
    NSString *title;
    
    BOOL goToDestination;
    int status;
    int actionType;
    
    float ax; // 가속도, 혹은 힘. 
    float ay; // a = Acceleration
    
    float vx; // 속도
    float vy; // v = Velocity
    
    float sx; // 위치
    float sy; // s = State
    
    float an; // 각가속도
    float vn; // 각속도
    float sn; // 각도
    
    float destinationAccel;
    
    CGPoint pointDestination;
    UIAcceleration *acceleration;
    
}

@property (nonatomic, assign) int status;
@property (nonatomic, assign) int actionType;
@property (nonatomic, assign) float destinationAccel;
@property (nonatomic, retain) UIAcceleration *acceleration;
@property (nonatomic, assign) BOOL goToDestination;
@property (nonatomic, retain) UIImage *imageOriginal;
@property (nonatomic, assign) float ax, ay, vx, vy, sx, sy, an, vn, sn; // 변수
@property (nonatomic, assign) CGPoint pointDestination;
@property (nonatomic, retain) NSString *name; // 객체
@property (nonatomic, assign) int level;
@property (nonatomic, retain) NSString *job;
@property (nonatomic, retain) NSString *title;

- (void)doAction;
- (void)jump;
- (void)setDestination:(CGPoint)point;
- (void)gotoDestination:(CGPoint)point;
- (void)cancelDestination;
- (void)doActionThread;

@end
