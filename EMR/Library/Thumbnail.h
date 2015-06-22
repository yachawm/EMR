//
//  Thumbnail.h
//  LeoFinder
//
//  Created by Wenly on 11. 1. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Thumbnail : NSObject {

}

- (UIImage *)thumbFromFile:(NSString*)filename size:(float)length;
+ (UIImage *)thumbFromImage:(UIImage*)image size:(float)length;

@end
