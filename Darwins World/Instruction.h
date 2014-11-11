//
//  Instruction.h
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species;

@interface Instruction : NSManagedObject

typedef enum InstructionType {
    InstructionTypeHop,
    InstructionTypeLeft,
    InstructionTypeRight,
    InstructionTypeInfect,
    InstructionTypeIfEmpty,
    InstructionTypeIfWall,
    InstructionTypeIfEnemy,
    InstructionTypeIfRandom,
    InstructionTypeGo,
    InstructionTypeUndefined,
} InstructionType;

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * param;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Species *species;

- (BOOL) isActionInstruction;
- (BOOL) isControlInstruction;

/* returns nil if invalid instruction type */
+ (NSString *)stringForType:(InstructionType)type;

/* returns InstructionTypeUndefined if invalid string */
+ (InstructionType)typeForString:(NSString *)string;

@end
