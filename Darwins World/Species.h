//
//  Species.h
//  Darwins World
//
//  Created by Connor Lirot on 11/10/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Instruction;

@interface Species : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *instructions;
@end

@interface Species (CoreDataGeneratedAccessors)

- (void)addInstructionsObject:(Instruction *)value;
- (void)removeInstructionsObject:(Instruction *)value;
- (void)addInstructions:(NSSet *)values;
- (void)removeInstructions:(NSSet *)values;

@end
