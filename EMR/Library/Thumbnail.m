//
//  Thumbnail.m
//  LeoFinder
//
//  Created by Wenly on 11. 1. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Thumbnail.h"

@implementation Thumbnail
- (UIImage *)thumbFromFile:(NSString*)filename size:(float)length{
	UIImage *thumbnail;
	//couldn’t find a previously created thumb image so create one first…
	UIImage *mainImage = [UIImage imageWithContentsOfFile:filename];
	UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
	BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
	float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
	// creating a square context the size of the final image which we will then
	// manipulate and transform before drawing in the original image
	UIGraphicsBeginImageContext(CGSizeMake(length, length));
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextClipToRect( currentContext, clippedRect);
	CGFloat scaleFactor = length/sideFull;
	if (widthGreaterThanHeight) {
		//a landscape image – make context shift the original image to the left when drawn into the context
		CGContextTranslateCTM(currentContext, -((mainImage.size.width - sideFull) / 2) * scaleFactor, 0);
	}
	else {
		//a portfolio image – make context shift the original image upwards when drawn into the context
		CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height - sideFull) / 2) * scaleFactor);
	}
	//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
	CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
	[mainImageView.layer renderInContext:currentContext];
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *imageData = UIImagePNGRepresentation(thumbnail);
	NSString *thumbImageName = [NSString stringWithFormat:@"%dX%d%@",(int)length,(int)length,filename];
	[imageData writeToFile:thumbImageName atomically:YES];
	thumbnail = [UIImage imageWithContentsOfFile:thumbImageName];
    
//    [mainImageView release];
    
	return thumbnail;
}

+ (UIImage *)thumbFromImage:(UIImage*)image size:(float)length{
	UIImage *thumbnail;
	//couldn’t find a previously created thumb image so create one first…
	UIImage *mainImage = image;
	UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
	BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
	float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
	// creating a square context the size of the final image which we will then
	// manipulate and transform before drawing in the original image
	UIGraphicsBeginImageContext(CGSizeMake(length, length));
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextClipToRect( currentContext, clippedRect);
	CGFloat scaleFactor = length/sideFull;
	if (widthGreaterThanHeight) {
		//a landscape image – make context shift the original image to the left when drawn into the context
		CGContextTranslateCTM(currentContext, -((mainImage.size.width - sideFull) / 2) * scaleFactor, 0);
	}
	else {
		//a portfolio image – make context shift the original image upwards when drawn into the context
		CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height - sideFull) / 2) * scaleFactor);
	}
	//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
	CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
	[mainImageView.layer renderInContext:currentContext];
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return thumbnail;
}

/*
- (UIImage *)thumbWithSideOfLength:(float)length fileName:(NSString*)filename {
	NSString *subdir = @”my/images/directory”;
	//NSString *filename = @”myOriginalImage.png”;
	NSString *fullPathToThumbImage = 
	[subdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%dx%d%@",(int) length, (int) length,filename]];
	NSString *fullPathToMainImage = [subdir stringByAppendingPathComponent:filename];
    UIImage *thumbnail;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:fullPathToThumbImage] == YES) {
		thumbnail = [UIImage imageWithContentsOfFile:fullPathToThumbImage];
	}
	else {
		//couldn’t find a previously created thumb image so create one first…
		UIImage *mainImage = [UIImage imageWithContentsOfFile:fullPathToMainImage];
		UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
		BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
		float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
		CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
		// creating a square context the size of the final image which we will then
		// manipulate and transform before drawing in the original image
		UIGraphicsBeginImageContext(CGSizeMake(length, length));
		CGContextRef currentContext = UIGraphicsGetCurrentContext();
		CGContextClipToRect( currentContext, clippedRect);
		CGFloat scaleFactor = length/sideFull;
		if (widthGreaterThanHeight) {
			//a landscape image – make context shift the original image to the left when drawn into the context
			CGContextTranslateCTM(currentContext, -((mainImage.size.width – sideFull) / 2) * scaleFactor, 0);
		else {
			//a portfolio image – make context shift the original image upwards when drawn into the context
			CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height – sideFull) / 2) * scaleFactor);
		}
		//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
		CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
		[mainImageView.layer renderInContext:currentContext];
		thumbnail = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		NSData *imageData = UIImagePNGRepresentation(thumbnail);
		[imageData writeToFile:fullPathToThumbImage atomically:YES];
		thumbnail = [UIImage imageWithContentsOfFile:fullPathToThumbImage];
	}
	return thumbnail;
}
*/
@end
