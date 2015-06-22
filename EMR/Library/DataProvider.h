//
//  NetworkProvider.h
//  YUMC-R
//
//  Created by Wenly on 2014. 2. 20..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

- (id)provideData:(id)data ofAPI:(NSString*)api;

+(DataProvider *) manager;



@end



