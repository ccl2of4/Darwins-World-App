//
//  Creature.h
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Species.h"

@class Creature;

@protocol CreatureDelegate <NSObject>

- (void) creatureHop:(Creature *)creature;
- (BOOL) creatureIsFacingEmpty:(Creature *)creature;
- (BOOL) creatureIsFacingWall:(Creature *)creature;
- (Creature *) enemyInFrontOfCreature:(Creature *)creature;

@end

@interface Creature : NSObject

typedef enum CreatureDirection {
    CreatureDirectionNorth,
    CreatureDirectionEast,
    CreatureDirectionSouth,
    CreatureDirectionWest
} CreatureDirection;

@property (weak, nonatomic) id<CreatureDelegate> delegate;
@property (readonly, nonatomic) Species *species;
@property (nonatomic) CreatureDirection direction;

- (void)rotateLeft;
- (void)rotateRight;
- (void)handleTurn;


@end
