//
//  Darwin.h
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Creature.h"

@protocol DarwinDelegate <NSObject>

- (void) darwinDidFinishMove;
- (void) darwinDidFinishTurn:(NSUInteger)turnNum;

@end

@interface Darwin : NSObject <CreatureDelegate>

@property (weak, nonatomic) id<DarwinDelegate> delegate;
@property (readonly, nonatomic) NSUInteger numberOfRows;
@property (readonly, nonatomic) NSUInteger numberOfColumns;

- (id) initWithRows:(NSUInteger)rows columns:(NSUInteger)columns;

- (void) addCreature:(Creature *)creature point:(CGPoint)point;
- (void) addCreature:(Creature *)creature index:(NSUInteger)index;
- (void) run:(NSUInteger)numberOfTurns;

- (Creature *) creatureAtPoint:(CGPoint)point;

/* enumerates entire board int left->right top->down fashion. creature is NULL if the board is empty for the given point */
- (void)enumerateCreaturesOnBoardUsingBlock:(void (^)(Creature *creature, CGPoint point, BOOL *stop))block;

@end
