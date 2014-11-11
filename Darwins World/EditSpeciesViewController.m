//
//  EditSpeciesViewController.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "EditSpeciesViewController.h"
#import "EditSpeciesViewController+Protected.h"
#import "NSManagedObjectContext+DarwinsWorld.h"
#import "Species.h"
#import "Instruction.h"

@interface EditSpeciesViewController ()

@end


@implementation EditSpeciesViewController {
    UITextField *_nameTextField;
    UILabel *_nameLabel;
    UITextView *_programTextView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    [self.navigationItem setRightBarButtonItem:item];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInterface];
}

- (void) updateInterface {
    [self.nameTextField setText:[self.species name]];
    [self.programTextView setText:[self programStringForInstructions:[self.species sortedInstructions]]];
}

- (void)save {
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    
    if (![self species]) {
        [self setSpecies:[NSEntityDescription insertNewObjectForEntityForName:@"Species" inManagedObjectContext:context]];
    }
    
    [self.species setName:[self.nameTextField text]];
    NSString *program = [self.programTextView text];
    NSArray *instructions = [self instructionsForProgram:program];
    [self.species setInstructions:[NSSet setWithArray:instructions]];
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)programStringForInstructions:(NSArray *)instructions {
    NSMutableString *result = [NSMutableString new];
    for (Instruction *instruction in instructions) {
        [result appendString:[instruction description]];
        [result appendString:@"\n"];
    }
    return result;
}

- (NSArray *)instructionsForProgram:(NSString *)program {
    NSMutableArray *result = [NSMutableArray new];
    
    NSArray *tokens = [program componentsSeparatedByString:@"\n"];
    
    [tokens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *token = obj;
        NSArray *values = [token componentsSeparatedByString:@" "];
        assert([values count] >= 1);
        
        Instruction *instruction = [NSEntityDescription insertNewObjectForEntityForName:@"Instruction" inManagedObjectContext:[NSManagedObjectContext defaultManagedObjectContext]];
        
        NSString *instructionName = values[0];
        InstructionType type = [Instruction typeForString:instructionName];
        NSString *paramString = @"";
        
        if (type == InstructionTypeHop) {
            type = InstructionTypeHop;
        } else if (type == InstructionTypeLeft) {
            type = InstructionTypeLeft;
        } else if (type == InstructionTypeRight) {
            type = InstructionTypeRight;
        } else if (type == InstructionTypeInfect) {
            type = InstructionTypeInfect;
        } else {
            if (type == InstructionTypeIfEmpty) {
                type = InstructionTypeIfEmpty;
            } else if (type == InstructionTypeIfWall) {
                type = InstructionTypeIfWall;
            } else if (type == InstructionTypeIfEnemy) {
                type = InstructionTypeIfEnemy;
            } else if (type == InstructionTypeIfRandom) {
                type = InstructionTypeIfRandom;
            } else if (type == InstructionTypeGo) {
                type = InstructionTypeGo;
            } else assert(false);
            assert([values count] == 2);
            paramString = values[1];
        }
        [instruction setIndex:@(idx)];
        [instruction setParam:@([paramString integerValue])];
        [instruction setType:@(type)];
        [result addObject:instruction];
    }];
    
    return result;
}

-(UITextView *)programTextView {return _programTextView;}
-(void)setProgramTextView:(UITextView *)programTextView {_programTextView = programTextView;}
-(UITextField *)nameTextField {return _nameTextField;}
-(void)setNameTextField:(UITextField *)nameTextField {_nameTextField = nameTextField;}
-(UILabel *)nameLabel {return _nameLabel;}
-(void)setNameLabel:(UILabel *)nameLabel {_nameLabel = nameLabel;}

@end
