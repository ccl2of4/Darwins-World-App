//
//  Species.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "Species.h"
#import "Instruction.h"


@implementation Species

@dynamic name;
@dynamic instructions;

-(NSArray *)sortedInstructions {
    return [[[self instructions] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 index] < [obj2 index];
    }];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[Species class]] && [[object name] isEqualToString:[self name]];
}

@end
