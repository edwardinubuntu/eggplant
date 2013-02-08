//
//  CoreDataStack.h
//  Derived from Core Data Template Code
//
//  Created by Ben on 10/23/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (nonatomic, readonly, strong) NSString *modelName;
@property (nonatomic, readonly, strong) NSString *fileName;
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Create CoreDataStack with provided modelName.xcdatamodeld and save as fileName.sqlite
+ (id)coreDataStackWithModelName:(NSString *)modelName fileName:(NSString *)fileName;
// Use model name as the file name on the storage
+ (id)coreDataStackWithModelName:(NSString *)modelName;
// Designated initializer
- (id)initWithModelName:(NSString *)modelName fileName:(NSString *)fileName;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
