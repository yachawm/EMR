//
//  Ruler.m
//  Ruler
//
//  Created by Wenly on 2014. 7. 11..
//
//

#import "Ruler.h"
#import "Session.h"

#define G 9.80665
#define PI 3.141592



@implementation Ruler

@synthesize sx, sy, sz, vx, vy, vz, ax, ay, az, aax, aay, aaz;
@synthesize motionManager,totalForce;

- (void)recordAcceleration:(UIAcceleration *)acceleration{
	int i = frameCount;
	accelRecord[i][0] = acceleration.x;
	accelRecord[i][1] = acceleration.y;
	accelRecord[i][2] = acceleration.z;
}

- (void)recordRotationRateX:(double)X Y:(double)Y Z:(double)Z{
	int i = frameCount;
	rotRecord[i][0] = motionManager.gyroData.rotationRate.x;
	rotRecord[i][1] = motionManager.gyroData.rotationRate.y;
	rotRecord[i][2] = motionManager.gyroData.rotationRate.z;
}

- (BOOL)accelerationIsSteady{
	steadyCount = accuracy/5; // steadyCount should be not bigger than accuracy at this version.
	int j;
	int k = frameCount; //current record
	double errorX = 0;
	double errorY = 0;
	double errorZ = 0;
	int i = k;
	for ( ; i < k+steadyCount-1 ; i++) {
		if (i < accuracy) {
			j = i;
		}
		else {
			j = i-accuracy;
		}
		if (j!=accuracy-1) {
			errorX += (accelRecord[j][0] - accelRecord[j+1][0])*(accelRecord[j][0] - accelRecord[j+1][0]);
			errorY += (accelRecord[j][1] - accelRecord[j+1][1])*(accelRecord[j][1] - accelRecord[j+1][1]);
			errorZ += (accelRecord[j][2] - accelRecord[j+1][2])*(accelRecord[j][2] - accelRecord[j+1][2]);
		}
		else {
			errorX += (accelRecord[j][0] - accelRecord[0][0])*(accelRecord[j][0] - accelRecord[0][0]);
			errorY += (accelRecord[j][1] - accelRecord[0][1])*(accelRecord[j][1] - accelRecord[0][1]);
			errorZ += (accelRecord[j][2] - accelRecord[0][2])*(accelRecord[j][2] - accelRecord[0][2]);
		}
	}
	
	//NSLog(@"errorX = %.3f",errorX);
	//NSLog(@"errorY = %.3f",errorY);
	//NSLog(@"errorZ = %.3f",errorZ);
	//NSLog(@"errorX + errorY + errorZ = %.3f",errorX+errorY+errorZ);
	if (errorX + errorY + errorZ < 0.005) {
		return TRUE;
	}
	return FALSE;
}

- (void)getCurrentAngle{
	int frame;
	if (frameCount < steadyCount) {
		frame = frameCount + accuracy - steadyCount;
	}
	else {
		frame = frameCount - steadyCount;
	}
	
	averageAX = 0;
	averageAY = 0;
	averageAZ = 0;
	averageRX = 0;
	averageRY = 0;
	averageRZ = 0;
	
	for (int i = 0 ; i < steadyCount; i++, frame++) {
		if (frame == accuracy) {
			frame -= accuracy;
		}
		averageAX += accelRecord[frame][0];
		averageAY += accelRecord[frame][1];
		averageAZ += accelRecord[frame][2];
		averageRX += rotRecord[frame][0];
		averageRY += rotRecord[frame][1];
		averageRZ += rotRecord[frame][2];
	}
	
	averageAX /= steadyCount;
	averageAY /= steadyCount;
	averageAZ /= steadyCount;
	averageRX /= steadyCount;
	averageRY /= steadyCount;
	averageRZ /= steadyCount;
	
	ax = averageAX;
	ay = averageAY;
	az = averageAZ;
	
	//NSLog(@"averageRX : %f",averageRX);
	//NSLog(@"averageRY : %f",averageRY);
	//NSLog(@"averageRZ : %f",averageRZ);
	
	double vect = sqrt(ax*ax + ay*ay + az*az);
	iG = G / vect; // correct iPhone's G-force recognization.
	
	ax /= vect;
	ay /= vect;
	az /= vect;
	
	angleX = atan(az/ay);
	angleY = atan(ax/az);
	angleZ = atan(ay/ax);
	
	//NSLog(@"tan(-PI/4) = %f atan(100000000) = %f",tan(PI*1.25), atan(100000000)); // 180 degree = PI
	if (ay < 0) {
		angleX += PI;
	}
	if (az < 0) {
		angleY += PI;
	}
	if (ax < 0) {
		angleZ += PI;
	}
	
	if (angleX < 0) {
		angleX += 2*PI;
	}
	if (angleY < 0) {
		angleY += 2*PI;
	}
	if (angleZ < 0) {
		angleZ += 2*PI;
	}
	if (angleX >= 360) {
		angleX -= 2*PI;
	}
	if (angleY >= 360) {
		angleY -= 2*PI;
	}
	if (angleZ >= 360) {
		angleZ -= 2*PI;
	}
	
	startGravityAngleX = angleX;
	startGravityAngleY = angleY;
	startGravityAngleZ = angleZ;
	
	//NSLog(@"angleX = %.2f angleY = %.2f angleZ = %.2f",angleX*180/PI, angleY*180/PI, angleZ*180/PI);
	//NSLog(@"ax = %f ay = %f az = %f",ax,ay,az);
	ax = 0;
	ay = 0;
	az = 0;
}

- (void)startAccelerationCollection {
    
}

- (void) startRecord{
	
    
    
    proceed = NO;
    dist = sqrt(sx*sx + sy*sy + sz*sz);
    //distance.text = [NSString stringWithFormat:@"%.9f m",dist];
    //timer = nil;
    //[motionManager stopGyroUpdates];
    time = 0;
    
    
    aax = 0;
	aay = 0;
	aaz = 0;
	baax = 0;
	baay = 0;
	baaz = 0;
	
	tax = 0;
	tay = 0;
	taz = 0;
	btax = 0;
	btay = 0;
	btaz = 0;
	
	ax = 0;
	ay = 0;
	az = 0;
	bax = 0;
	bay = 0;
	baz = 0;
	
	rx = 0;
	ry = 0;
	rz = 0;
	brx = 0;
	bry = 0;
	brz = 0;
	
	vx = 0;
	vy = 0;
	vz = 0;
	bvx = 0;
	bvy = 0;
	bvz = 0;
	sx = 0;
	sy = 0;
	sz = 0;
	angleX = 0;
	angleY = 0;
	angleZ = 0;
	deviceMotion = motionManager.deviceMotion;
	CMAttitude *attitude = deviceMotion.attitude;
	referenceAttitude = [attitude retain];
	frameCount = 0;
	cutOffA = 0.0002;
	cutOffR = 0.03;
	//filter = [[[filter class]alloc] initWithSampleRate:50 cutoffFrequency:5.0];
    
    
    accuracy = 100;
	//accelRecord = malloc(sizeof(double) * 100);
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/accuracy];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	motionManager = [[CMMotionManager alloc] init];
	[motionManager setGyroUpdateInterval:1/accuracy];
	referenceAttitude = nil;
	[motionManager startGyroUpdates];
    [motionManager startMagnetometerUpdates];

    
    if (_motionData==nil) {
        _motionData = [[NSMutableArray alloc]init];
    }
    
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                             withHandler:^(CMAccelerometerData *data, NSError *error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self.motionData addObject:data];
                                                     NSLog(@"data = %@",data);
                                                     //[self openAppIfNeeded];
                                                 });
                                             }];


}

- (void)openAppIfNeeded{
    
    int i = self.motionData.count -10;
    
    if (i < 0) {
        i = 0;
    }
    
    totalForce = 0;
    
    for (; self.motionData.count>0 && i < self.motionData.count-1; i++) {
        CMAccelerometerData *data = [self.motionData objectAtIndex:i];
        totalForce += sqrtf( pow(data.acceleration.x,2) + pow(data.acceleration.y,2) + pow(data.acceleration.z,2));
    }
    
    NSLog(@"totalForce = %f",totalForce);
    
    if (totalForce>20.0 && didOpenApp!=YES) {
        //[self openApp];
    }
}

- (void)openApp{
    NSLog(@"open App");
    didOpenApp = YES;
    [[Session manager]openAppWithURLScheme:@"kr.spacesoft.ks" withIdentifier:@"kr.spacesoft.ks"];
    [self performSelector:@selector(releaseOpenAppLock) withObject:nil afterDelay:3];
}

- (void)releaseOpenAppLock{
    NSLog(@"releaseOpenAppLock");
    didOpenApp = NO;
}

- (void) stopRecord{
	[motionManager stopGyroUpdates];
    [motionManager release];
    motionManager = nil;
	[referenceAttitude release];
    referenceAttitude = nil;
}


// UIAccelerometerDelegate method, called when the device accelerates.
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	frameCount++;
	if (frameCount >= accuracy) {
		frameCount-= accuracy;
	}
	[self recordAcceleration:acceleration];
	//NSLog(@"recordRotationRate");
	NSLog(@"X:%f Y:%f Z:%f",motionManager.gyroData.rotationRate.x,motionManager.gyroData.rotationRate.y,motionManager.gyroData.rotationRate.z);
	[self recordRotationRateX:motionManager.gyroData.rotationRate.x
							Y:motionManager.gyroData.rotationRate.y
							Z:motionManager.gyroData.rotationRate.z];
	
	if (!proceed) {
		// 바로 이전의 데이터를 저장.
		baax = aax; // 가속도 변화량
		baay = aay;
		baaz = aaz;
		btax = tax;
		btay = tay;
		btaz = taz;
		bax = ax; // 가속도
		bay = ay;
		baz = az;
		
		tax = acceleration.x;
		tay = acceleration.y;
		taz = acceleration.z;
		
		// 가속도를 한번 더 적분하여 데이터를 산출하도록 하자.
		
		aax = tax - btax;
		aay = tay - btay;
		aaz = taz - btaz;
		
		//NSLog(@"aax = %.3f aay = %.3f aaz = %.3f",aax,aay,aaz);
		ax = ( aax + ( ( aax - baax ) / 2 ) ) / accuracy;
		ay = ( aay + ( ( aay - baay ) / 2 ) ) / accuracy;
		az = ( aaz + ( ( aaz - baaz ) / 2 ) ) / accuracy;
		
		if ([self accelerationIsSteady]){
			
			if ( frameCount%((int)(accuracy/10)) == 0) {
				[self getCurrentAngle];
			}
			
//			if(![[btnStart currentTitle] compare:@"WAIT"]) {
//				[btnStart setEnabled:YES];
//				[btnStart setTitle:@"START" forState:UIControlStateNormal];
//				[btnStart setTitle:@"START" forState:UIControlStateSelected];
//				[btnStart setTitle:@"START" forState:UIControlStateHighlighted];
//                
//			}
			
		}
//		else if (![[btnStart currentTitle] compare:@"START"]){
//			[btnStart setEnabled:NO];
//			[btnStart setTitle:@"WAIT" forState:UIControlStateNormal];
//			[btnStart setTitle:@"WAIT" forState:UIControlStateSelected];
//			[btnStart setTitle:@"WAIT" forState:UIControlStateHighlighted];
//		}
	}
	//NSLog(@"accelerometer activated");
	else
	{
		// 바로 이전의 데이터를 저장.
		baax = aax; // 가속도 변화량
		baay = aay;
		baaz = aaz;
		btax = tax;
		btay = tay;
		btaz = taz;
		bax = ax; // 가속도
		bay = ay;
		baz = az;
		bvx = vx; // 속도
		bvy = vy;
		bvz = vz;
		brx = rx; // 각가속도
		bry = ry;
		brz = rz;
		
		tax = acceleration.x;
		tay = acceleration.y;
		taz = acceleration.z;
		
		/* 각가속도를 이용한 위치 인식은 오차가 너무 커서 하드웨어가 더 정밀해지지 않는 이상 힘들다.
		 
         changedAngleX = angleX - startGravityAngleX; // 각도 변화량
         changedAngleY = angleY - startGravityAngleY;
         changedAngleZ = angleZ - startGravityAngleZ;
         
         // 아이폰의 각도가 바뀌어도 상관 없도록 보정해준다.
         
         tax = acceleration.x;
         tay = acceleration.y;
         taz = acceleration.z;
         
         tax1=tax;
         tay1=taz*sin(changedAngleX)-tay*cos(changedAngleX);
         taz1=taz*cos(changedAngleX)+tay*sin(changedAngleX);
         
         tax2=tax1*cos(changedAngleY)+taz1*sin(changedAngleY);
         tay2=tay1;
         taz2=tax1*sin(changedAngleY)-taz1*cos(changedAngleY);
         
         tax3=tay2*sin(changedAngleZ)-tax2*cos(changedAngleZ);
         tay3=tay2*cos(changedAngleZ)+tax2*sin(changedAngleZ);
         taz3=-taz2;
         
         ax = (tax3 - averageAX) * iG; // 중력을 제거함.
         ay = (tay3 - averageAY) * iG; // 아이폰의 각도가 바뀌어도 교정이 되면서 중력도 제거됨.
         az = (taz3 - averageAZ) * iG;
         
         */
		
		// 가속도를 한번 더 적분하여 데이터를 산출하도록 하자.
		
		aax = tax - btax;
		aay = tay - btay;
		aaz = taz - btaz;
		
		//NSLog(@"aax = %.3f aay = %.3f aaz = %.3f",aax,aay,aaz);
		ax = ( aax + ( ( aax - baax ) / 2 ) ) / accuracy;
		ay = ( aay + ( ( aay - baay ) / 2 ) ) / accuracy;
		az = ( aaz + ( ( aaz - baaz ) / 2 ) ) / accuracy;
		
		if (fabs(ax) <= cutOffA) {
			if (ax > 0) {
				ax -= cutOffA;
				if (ax < 0) {
					ax = 0;
				}
			}
			else {
				ax += cutOffA;
				if (ax > 0) {
					ax = 0;
				}
			}
		}
		
		if (fabs(ay) <= cutOffA) {
			if (ay > 0) {
				ay -= cutOffA;
				if (ay < 0) {
					ay = 0;
				}
			}
			else {
				ay += cutOffA;
				if (ay > 0) {
					ay = 0;
				}
			}
		}
		
		if (fabs(az) <= cutOffA) {
			if (az > 0) {
				az -= cutOffA;
				if (az < 0) {
					az = 0;
				}
			}
			else {
				az += cutOffA;
				if (az > 0) {
					az = 0;
				}
			}
		}
		
		
		
		rx = motionManager.gyroData.rotationRate.x-averageRX; // 각가속도를 오차 필터링 해서 받아옴.
		ry = motionManager.gyroData.rotationRate.y-averageRY;
		rz = motionManager.gyroData.rotationRate.z-averageRZ;
		
		if (rx > 0) {
			rx -= cutOffR;
			if (rx < 0) {
				rx = 0;
			}
		}
		else {
			rx += cutOffR;
			if (rx > 0) {
				rx = 0;
			}
		}
		if (ry > 0) {
			ry -= cutOffR;
			if (ry < 0) {
				ry = 0;
			}
		}
		else {
			ry += cutOffR;
			if (ry > 0) {
				ry = 0;
			}
		}
		if (rz > 0) {
			rz -= cutOffR;
			if (rz < 0) {
				rz = 0;
			}
		}
		else {
			rz += cutOffR;
			if (rz > 0) {
				rz = 0;
			}
		}
		
		vx += ( ax + ( ( ax - bax ) / 2 ) ) / accuracy;
		vy += ( ay + ( ( ay - bay ) / 2 ) ) / accuracy;
		vz += ( az + ( ( az - baz ) / 2 ) ) / accuracy;
		
		if (ax == 0 && ay == 0 && az == 0){
			vx /= 2;
			vy /= 2;
			vz /= 2;
			/*
             if (frameCount%(int)(steadyCount/4) == 0) {
             if ([self accelerationIsSteady]) {
             [self getCurrentAngle];
             }
             }
			 */
		}
		sx += 10000 * ( vx + ( ( vx - bvx ) / 2 ) ) / accuracy;
		sy += 10000 * ( vy + ( ( vy - bvy ) / 2 ) ) / accuracy;
		sz += 10000 * ( vz + ( ( vz - bvz ) / 2 ) ) / accuracy;
		angleX += ( rx + ( ( rx - brx ) / 2 ) ) / accuracy;
		angleY += ( ry + ( ( ry - bry ) / 2 ) ) / accuracy;
		angleZ += ( rz + ( ( rz - brz ) / 2 ) ) / accuracy;
		
		time += 1/accuracy;
//		lblAX.text = [NSString stringWithFormat:@"ax = %.6f",ax];
//		lblAY.text = [NSString stringWithFormat:@"ay = %.6f",ay];
//		lblAZ.text = [NSString stringWithFormat:@"az = %.6f",az];
//		lblVX.text = [NSString stringWithFormat:@"vx = %.6f",vx];
//		lblVY.text = [NSString stringWithFormat:@"vy = %.6f",vy];
//		lblVZ.text = [NSString stringWithFormat:@"vz = %.6f",vz];
//		lblSX.text = [NSString stringWithFormat:@"sx = %.6f",sx];
//		lblSY.text = [NSString stringWithFormat:@"sy = %.6f",sy];
//		lblSZ.text = [NSString stringWithFormat:@"sz = %.6f",sz];
//		lblRX.text = [NSString stringWithFormat:@"rx = %.3f",rx];
//		lblRY.text = [NSString stringWithFormat:@"ry = %.3f",ry];
//		lblRZ.text = [NSString stringWithFormat:@"rz = %.3f",rz];
//		lblAngleX.text = [NSString stringWithFormat:@"nx = %.2f",angleX*180/PI];
//		lblAngleY.text = [NSString stringWithFormat:@"ny = %.2f",angleY*180/PI];
//		lblAngleZ.text = [NSString stringWithFormat:@"nz = %.2f",angleZ*180/PI];
//		lblTime.text = [NSString stringWithFormat:@"t1 = %.2f s",time];
		//lblRecord.text = [NSString stringWithFormat:@"t2 = %.2f s",recordTime];
		if (frameCount%10 == 0) {
			dist = sqrt(sx*sx + sy*sy + sz*sz);
//			distance.text = [NSString stringWithFormat:@"%.9f m",dist];
		}
	}
}

- (void) viewDidAppear:(BOOL)animated{
	

}

- (void) record_Time{
	recordTime += 1/accuracy;
}

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */





/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	
	[motionManager release];
	[referenceAttitude release];
	[deviceMotion release];
	[timer release];
	
	//free(accelRecord);
	
    [super dealloc];
}


@end
