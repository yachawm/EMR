//
//  Coredata.m
//  YUMC-R
//
//  Created by Wenly on 2014. 2. 14..
//  Copyright (c) 2014년 spacesoft. All rights reserved.
//

#import "Coredata.h"
#import "AppDelegate.h"
#import "WManagedObject.h"

@implementation Coredata

static Coredata *singleTone= nil;

+(Coredata *)manager
{
    @synchronized([Coredata class]) // 오직 하나의 쓰레드만 접근할 수 있도록 함.
    {
        if(singleTone==nil)
        {
            singleTone = [[self alloc] init];
            if (nil != singleTone) {
                
            }
        }
    }
    return singleTone;
    
}

- (id)init
{
	if((self = [super init]))// 초기화 선언부분
	{
    
	}
	
	return self;
}

/**
 * @brief identifier 순서로 정렬하여 해당 엔티티의 모든 자료를 반환
 * @param (NSString*)entityName
 * @return (NSArray*)
 * @author Chang-hyeok Yang
 */
- (NSArray*)allObjectsFromEntity:(NSString*)entityName{
    return [self allObjectsFromEntity:entityName sortKey:@"identifier" ascending:YES];
}



/**
 * @brief key 기준 순서로 정렬하여 해당 엔티티의 모든 자료를 반환
 * @param (NSString*)entityName sortKey:(NSString*)key ascending:(BOOL)ascending
 * @return (NSArray*)
 * @author Chang-hyeok Yang
 */
- (NSArray*)allObjectsFromEntity:(NSString*)entityName sortKey:(NSString*)key ascending:(BOOL)ascending{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                   ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}


/**
 * @brief key 기준 순서로 정렬하여 해당 엔티티의 모든 자료를 반환
 * @param (NSString*)entityName sortKey:(NSString*)key ascending:(BOOL)ascending
 * @return (NSArray*)
 * @author Chang-hyeok Yang
 */
- (NSArray*)sortArray:(NSArray*)array sortKey:(NSString*)key ascending:(BOOL)ascending{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                   ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}

- (NSArray*)sortArrayByIdentifier:(NSArray*)array{
    return [self sortArray:array sortKey:@"identifier" ascending:YES];
}

/**
 * @brief identfier 로 해당 엔티티의 데이터 하나를 반환
 * @param (NSString*)entityName (NSString*)identifier
 * @return (NSManagedObject*)
 * @author Chang-hyeok Yang
 */
- (NSManagedObject*)objectFromEntity:(NSString*)entityName withIdentifier:(NSString*)identifier{
    return [self objectFromEntity:entityName withKey:@"identifier" value:identifier];
}

/**
 * @brief identfier 로 해당 엔티티의 데이터 하나를 반환
 * @param (NSString*)entityName (NSString*)identifier
 * @return (NSManagedObject*)
 * @author Chang-hyeok Yang
 */
- (NSManagedObject*)objectFromEntity:(NSString*)entityName withKey:(NSString*)key value:(id)value{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString *format = nil;
    if ([value isMemberOfClass:[NSNumber class]]){
        format = [NSString stringWithFormat:@"%@ == %@",key,value];
    }
    else{
        format = [NSString stringWithFormat:@"%@ == \"%@\"",key,value];
    }
    
    NSLog(@"format = %@",format);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
    }
    //[fetchRequest release];
    if (fetchedObjects.count==0) {
        return nil;
    }
    else if (fetchedObjects.count==1) {
        return [fetchedObjects lastObject];
    }
    else{
        NSLog(@"object %@ is not unique! count = %d",entityName,fetchedObjects.count);
        return nil;
    }
    return nil;
}

/**
 * @brief 해당 엔티티의 코어 데이터 하나를 생성하여 반환
 * @param (NSString*)entityName
 * @return (NSManagedObject*)
 * @author Chang-hyeok Yang
 */
- (NSManagedObject*)createObjectFromEntity:(NSString*)entityName{
    
    NSNumber *identifier = [NSNumber numberWithInt:[[self allObjectsFromEntity:entityName]count]];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    WManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:appDelegate.managedObjectContext];
    
    [object setIdentifier:identifier];
    
    NSLog(@"createObjectFromEntity = %@ identifier = %@",entityName,object.identifier);
    
    return object;
}


/**
 * @brief 메모리에 있는 코어데이터 객체들을 영구저장한다.
 * @param
 * @return
 * @author Chang-hyeok Yang
 */
- (void)saveCoredata{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
    
    if (managedObjectContext != nil) {
        
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
    }
    
}

- (void)deleteAllObjectsFromEntity:(NSString*)entityName{
    for (NSManagedObject *object in [self allObjectsFromEntity:entityName]) {
        [self.appDelegate.managedObjectContext deleteObject:object];
    }
}



@end
