//
//  Instruction.h
//  Darwins World
//
//  Created by Connor Lirot on 11/10/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species;

@interface Instruction : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * param;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) Species *species;

@end
