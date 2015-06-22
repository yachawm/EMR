//
//  SingleTon.h
//  studySingleton
//
//  Created by Wenly on 12. 10. 15..
//  Copyright (c) 2012년 Wenly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "WUtil.h"


@interface Session : NSObject{
    
}



+(Session *) manager;

@property (nonatomic, retain) AppDelegate *appDelegate;

- (void)save;

- (void)load;


- (void)alertMessage:(NSString*)message withAutoClose:(int)second;


@end
