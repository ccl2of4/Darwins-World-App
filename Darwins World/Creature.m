//
//  Creature.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "Creature.h"
#import "Instruction.h"

@interface Creature ()

@property (readwrite, nonatomic) Species *species;
@property (nonatomic) NSUInteger programCounter;

@end

@implementation Creature

- (void) handleTurn {
    while (true) {
        NSArray *instructions = [self.species sortedInstructions];
        
        assert (self.programCounter < [instructions count]);
        Instruction *instruction = [instructions objectAtIndex:[self programCounter]];
        
        ++self.programCounter;
        
        switch ([[instruction type] unsignedIntegerValue]) {
            case InstructionTypeHop : {
                if ([self.delegate creatureIsFacingEmpty:self])
                    [self.delegate creatureHop:self];
                break;
            }
            case InstructionTypeLeft : {
                [self rotateLeft];
                break;
            }
            case InstructionTypeRight : {
                [self rotateRight];
                break;
            }
            case InstructionTypeInfect : {
                Creature *victim = [self.delegate enemyInFrontOfCreature:self];
                if (victim)
                    [self infectCreature:victim];
                break;
            }
            case InstructionTypeIfEmpty : {
                unsigned n = [[instruction param] unsignedIntegerValue];
                if ([self.delegate creatureIsFacingEmpty:self])
                    self.programCounter = n;
                break;
            }
            case InstructionTypeIfWall : {
                unsigned n = [[instruction param] unsignedIntegerValue];
                if ([self.delegate creatureIsFacingWall:self])
                    self.programCounter = n;
                break;
            }
            case InstructionTypeIfRandom : {
                unsigned n = [[instruction param] unsignedIntegerValue];
                if (rand () & 0x1)
                    self.programCounter = n;
                break;
            }
            case InstructionTypeIfEnemy : {
                unsigned n = [[instruction param] unsignedIntegerValue];
                if ([self.delegate enemyInFrontOfCreature:self])
                    self.programCounter = n;
                break;
            }
            case InstructionTypeGo : {
                unsigned n = [[instruction param] unsignedIntegerValue];
                self.programCounter = n;
                break;
            }
            default: assert (false);
        }
        
        if ([instruction isActionInstruction]) break;
    }
}

- (void) rotateRight {
    if (++self.direction > CreatureDirectionWest)
        self.direction = CreatureDirectionNorth;
}

- (void) rotateLeft {
    if (--self.direction < CreatureDirectionNorth)
        self.direction = CreatureDirectionWest;
}

- (void)infectCreature:(Creature *)victim {
    assert(![[victim species] isEqual:[self species]]);
    
    [victim setSpecies:[self species]];
    [victim setProgramCounter:0];
}

@end
