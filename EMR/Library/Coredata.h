//
//  Coredata.h
//  YUMC-R
//
//  Created by Wenly on 2014. 2. 14..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppDelegate;

@interface Coredata : NSObject

@property (nonatomic, retain) AppDelegate *appDelegate;

+(Coredata *) manager;

- (NSArray*)allObjectsFromEntity:(NSString*)entityName;
- (NSArray*)allObjectsFromEntity:(NSString*)entityName sortKey:(NSString*)key ascending:(BOOL)ascending;
- (NSManagedObject*)objectFromEntity:(NSString*)entityName withIdentifier:(NSString*)identifier;

- (NSManagedObject*)objectFromEntity:(NSString*)entityName withKey:(NSString*)key value:(id)value;

- (NSManagedObject*)createObjectFromEntity:(NSString*)entityName;
- (NSArray*)sortArrayByIdentifier:(NSArray*)array;
- (NSArray*)sortArray:(NSArray*)array sortKey:(NSString*)key ascending:(BOOL)ascending;

- (void)saveCoredata;


@end
