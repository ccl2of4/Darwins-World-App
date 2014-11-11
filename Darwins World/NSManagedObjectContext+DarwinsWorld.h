//
//  NSManagedObjectContext+DarwinsWorld.h
//  Darwins World
//
//  Created by Connor Lirot on 11/10/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (WorkoutTracker)

+ (NSManagedObjectContext *)defaultManagedObjectContext;
+ (NSManagedObjectContext *)scratchpadManagedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSURL *)applicationDocumentsDirectory;

@end