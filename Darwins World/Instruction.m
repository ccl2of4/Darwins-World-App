//
//  Instruction.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "Instruction.h"
#import "Species.h"


@implementation Instruction

@dynamic index;
@dynamic param;
@dynamic type;
@dynamic species;

static NSDictionary *mapping;

+ (void) initializeMapping {
    mapping = @{
        @"hop" : @(InstructionTypeHop),
        @"left" : @(InstructionTypeLeft),
        @"right" : @(InstructionTypeRight),
        @"infect" : @(InstructionTypeInfect),
        @"ifempty" : @(InstructionTypeIfEmpty),
        @"ifwall" : @(InstructionTypeIfWall),
        @"ifenemy" : @(InstructionTypeIfEnemy),
        @"ifrandom" : @(InstructionTypeIfRandom),
        @"go" : @(InstructionTypeGo)
    };

}

+ (NSString *)stringForType:(InstructionType)type {
    if (!mapping) {
        [Instruction initializeMapping];
    }
    return [[mapping allKeysForObject:@(type)] firstObject];
}

+ (InstructionType)typeForString:(NSString *)string {
    if (!mapping) {
        [Instruction initializeMapping];
    }
    id result = mapping[string];
    return result ? [result unsignedIntegerValue] : InstructionTypeUndefined;
}

- (BOOL)isActionInstruction {
    InstructionType type = [[self type] unsignedIntegerValue];
    return (
        type == InstructionTypeHop      ||
        type == InstructionTypeLeft     ||
        type == InstructionTypeRight    ||
        type == InstructionTypeInfect
    );
}

-(BOOL)isControlInstruction {
    return ![self isActionInstruction];
}

-(NSString *)description {
    NSString *typeString = [Instruction stringForType:[[self type] unsignedIntegerValue]];
    NSString *paramString = @"";
    
    InstructionType type = [[self type] unsignedIntegerValue];
    if (type == InstructionTypeIfEmpty  ||
        type == InstructionTypeIfWall   ||
        type == InstructionTypeIfEnemy  ||
        type == InstructionTypeIfRandom ||
        type == InstructionTypeGo)
    {
            paramString = [NSString stringWithFormat:@"%d",[[self param] integerValue]];
    }
    
    return [NSString stringWithFormat:@"%@ %@",typeString, paramString];
}

@end
