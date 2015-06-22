//
//  Ruler.h
//  Ruler
//
//  Created by Wenly on 2014. 7. 11..
//
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>

@interface Ruler : NSObject<UIAccelerometerDelegate>{
    BOOL proceed;
	double cutOffA;
	double cutOffR;
	double aax;
	double aay;
	double aaz;
	double baax;
	double baay;
	double baaz;
	double ax;
	double ay;
	double az;
	double bax;
	double bay;
	double baz;
	double tax;
	double tay;
	double taz;
	double btax;
	double btay;
	double btaz;
	double tax1;
	double tay1;
	double taz1;
	double tax2;
	double tay2;
	double taz2;
	double tax3;
	double tay3;
	double taz3;
	double vx;
	double vy;
	double vz;
	double bvx;
	double bvy;
	double bvz;
	double sx;
	double sy;
	double sz;
	double rx;
	double ry;
	double rz;
	double brx;
	double bry;
	double brz;
	double angleX;
	double angleY;
	double angleZ;
	double startGravityAngleX;
	double startGravityAngleY;
	double startGravityAngleZ;
	double changedAngleX;
	double changedAngleY;
	double changedAngleZ;
	double dist;
	double time;
	double recordTime;
	double accuracy;
	double iG;
	NSTimer *timer;
	double accelRecord[1000][3];
	double rotRecord[1000][3];
	int frameCount;
	int steadyCount;
	double averageAX;
	double averageAY;
	double averageAZ;
	double averageRX;
	double averageRY;
	double averageRZ;
	
	CMAttitude *referenceAttitude;
	CMDeviceMotion *deviceMotion;
    BOOL didOpenApp;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) double sx,sy,sz,vx,vy,vz,ax,ay,az,aax,aay,aaz;
@property (nonatomic, assign) CMMotionManager *motionManager;
@property (nonatomic, retain) NSMutableArray *motionData;
@property (nonatomic, assign) float totalForce;


- (void) record_Time;

- (void)recordAcceleration:(UIAcceleration *)acceleration;

- (void)recordRotationRateX:(double)X Y:(double)Y Z:(double)Z;

- (BOOL)accelerationIsSteady;

- (void)getCurrentAngle;

- (NSDictionary*)dictionaryPosition;

- (void) startRecord;

- (void) stopRecord;

- (void)openAppIfNeeded;

- (void)openApp;

@end
