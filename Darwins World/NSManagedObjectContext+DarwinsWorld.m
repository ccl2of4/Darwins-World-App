//
//  NSManagedObjectContext+DarwinsWorld.m
//  Darwins World
//
//  Created by Connor Lirot on 11/10/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "NSManagedObjectContext+DarwinsWorld.h"
#import "DWAppDelegate.h"

@implementation NSManagedObjectContext (WorkoutTracker)

+ (NSManagedObjectContext *) defaultManagedObjectContext {
    return [appDelegate() managedObjectContext];
}

+ (NSManagedObjectContext *) scratchpadManagedObjectContext {
    NSManagedObjectContext *scratchpadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [scratchpadContext setParentContext:[NSManagedObjectContext defaultManagedObjectContext]];
    return scratchpadContext;
}

+ (NSManagedObjectModel *) managedObjectModel {
    return [appDelegate() managedObjectModel];
}

+ (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    return [appDelegate() persistentStoreCoordinator];
}

+ (NSURL *) applicationDocumentsDirectory {
    return [appDelegate() applicationDocumentsDirectory];
}

static DWAppDelegate *
appDelegate (void) {
    return [[UIApplication sharedApplication] delegate];
}

@end