//
//  Darwin.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "Darwin.h"

@interface Darwin ()

@property (readwrite, nonatomic) NSUInteger numberOfRows;
@property (readwrite, nonatomic) NSUInteger numberOfColumns;
@property (nonatomic) NSMutableArray *board;
@property (nonatomic) NSUInteger indexOfActiveCreature;

@end

@implementation Darwin

- (id) init {
    [[[NSException alloc] initWithName:@"Illegal method" reason:@"Cannot initialize Darwin without specifying number of rows and columns" userInfo:nil] raise];
    return nil;
}

- (id) initWithRows:(NSUInteger)rows columns:(NSUInteger)columns {
    self = [super init];
    if (self) {
        [self setNumberOfRows:rows];
        [self setNumberOfColumns:columns];
        [self initializeBoard];
    }
    return self;
}

- (void) initializeBoard {
    NSMutableArray *board = [NSMutableArray new];
    for (int i = 0; i < [self numberOfRows]*[self numberOfColumns]; ++i) {
        [board addObject:[NSNull null]];
    }
    self.board = board;
}

- (void)enumerateCreaturesOnBoardUsingBlock:(void (^)(Creature *creature, CGPoint point, BOOL *stop))block {
    [self.board enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Creature *creature = obj == [NSNull null] ? obj : NULL;
        block (creature, [self indexToPoint:idx], stop);
    }];
}

-(void)addCreature:(Creature *)creature index:(NSUInteger)index {
    assert (index < [self.board count]);
    assert ([self.board objectAtIndex:index] == [NSNull null]);
    
    self.board[index] = creature;
}

-(void)addCreature:(Creature *)creature point:(CGPoint)point {
    return [self addCreature:creature index:[self pointToIndex:point]];
}

-(void)run:(NSUInteger)numberOfTurns {
    NSUInteger turnNum = 0;
    
    [self.delegate darwinDidFinishTurn:turnNum++];
    
    while (numberOfTurns--) {
        
        /* store creatures with their locations
         so we can quickly find them on the board later */
        NSMutableArray *queue = [NSMutableArray new];
        for (int i = 0; i < [self.board count]; ++i) {
            id creature = self.board[i];
            if (creature != [NSNull null]) {
                [queue addObject:@[creature,@(i)]];
            }
        }
        
        while ([queue count]) {
            NSArray *values = queue[0];
            [queue removeObjectAtIndex:0];
            
            assert ([values count] == 2);
            Creature *creature = values[0];
            self.indexOfActiveCreature = [values[1] unsignedIntegerValue];
            [creature handleTurn];
            [self.delegate darwinDidFinishMove];
        }
        [self.delegate darwinDidFinishTurn:turnNum++];
    }
}

-(BOOL)creatureIsFacingEmpty:(Creature *)creature {
    NSUInteger adjacentSpace = [self indexOfAdjacentSpace:creature];
    return adjacentSpace != -1 && self.board[adjacentSpace] == [NSNull null];
}

-(BOOL)creatureIsFacingWall:(Creature *)creature {
    NSUInteger adjacentSpace = [self indexOfAdjacentSpace:creature];
    return adjacentSpace == -1;
}

-(Creature *)enemyInFrontOfCreature:(Creature *)creature {
    NSUInteger adjacentSpace = [self indexOfAdjacentSpace:creature];
    Creature *result = NULL;
    if (adjacentSpace != -1 && (result = _board[adjacentSpace]))
        if ([[result species] isEqual:[creature species]])
            result = NULL;
    return result;
}

-(void)creatureHop:(Creature *)creature {
    assert ([self creatureIsFacingEmpty:creature]);
    NSUInteger occupiedSpace = [self indexOfCreature:creature];
    NSUInteger adjacentSpace = [self indexOfAdjacentSpace:creature];
    self.board[adjacentSpace] = self.board[occupiedSpace];
    self.board[occupiedSpace] = NULL;
}

- (NSUInteger) indexOfCreature:(Creature *)creature {
    /* we have cached the location of the creature whose turn it currently is,
     but we can also look up other creatures in linear time if necessary */
    if ([creature isEqual:self.board[self.indexOfActiveCreature]]) {
        return self.indexOfActiveCreature;
    }
    
    return [self.board indexOfObject:creature];
}


- (NSUInteger) indexOfAdjacentSpace:(Creature *)creature {
    NSUInteger creatureIndex = [self indexOfCreature:creature];
    assert (creatureIndex != NSNotFound);
    
    CGPoint creaturePoint = [self indexToPoint:creatureIndex];
    
    switch ([creature direction]) {
        case CreatureDirectionNorth : {
            if (creaturePoint.x == 0)
                return -1;
            --creaturePoint.x;
            break;
        }
        case CreatureDirectionEast : {
            if (creaturePoint.y == self.numberOfColumns - 1)
                return -1;
            ++creaturePoint.y;
            break;
        }
        case CreatureDirectionSouth : {
            if (creaturePoint.x == self.numberOfRows - 1)
                return -1;
            ++creaturePoint.x;
            break;
        }
        case CreatureDirectionWest : {
            if (creaturePoint.y == 0)
                return -1;
            --creaturePoint.y;
            break;
        }
        default: assert(false);
    }
    return [self pointToIndex:creaturePoint];
}

- (CGPoint) indexToPoint:(NSUInteger)index {
    assert (self.numberOfRows);
    assert (self.numberOfColumns);
    int row = index / self.numberOfColumns;
    int col = index % self.numberOfRows;
    return CGPointMake(row, col);
}

- (NSUInteger) pointToIndex:(CGPoint)point {
    return (point.x * self.numberOfColumns) + point.y;
}

@end
