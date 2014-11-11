//
//  PlayViewController.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "PlayViewController.h"
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+DarwinsWorld.h"
#import "Species.h"
#import "Creature.h"
#import "Darwin.h"

@interface PlayViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,DarwinDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *speciesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *darwinCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic) Darwin *darwin;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) UIView *tempSpeciesView;
@property (nonatomic) NSIndexPath *tempSpeciesIndexPath;
@property (nonatomic) NSIndexPath *tempDestinationIndexPath;

@end

static const NSInteger tempSpeciesViewNameTag = 1;

@implementation PlayViewController {
    UIView *_tempSpeciesView;
    NSFetchedResultsController *_fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    [self.speciesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.darwinCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panner setDelegate:self];
    [self.speciesCollectionView addGestureRecognizer:panner];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (IBAction)handleButtonTouchUpInside:(id)sender {
    [self.darwin run:1];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.speciesCollectionView)
    {
        UICollectionViewCell *cell = [self.speciesCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        Species *species = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        static const NSInteger nameLabelTag = 1;
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameLabelTag];
        if (!nameLabel) {
            nameLabel = [[UILabel alloc] initWithFrame:[cell.contentView bounds]];
            [nameLabel setTag:nameLabelTag];
            [nameLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:nameLabel];
            [cell.contentView setBackgroundColor:[UIColor darkGrayColor]];
        }
        [nameLabel setText:[species name]];
        
        return cell;
    }
    
    else if (collectionView == self.darwinCollectionView)
    {
        UICollectionViewCell *cell = [self.darwinCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        Creature *creature = [self.darwin creatureAtPoint:CGPointMake(indexPath.section, indexPath.item)];
        
        if (creature)
            assert ([creature isKindOfClass:[Creature class]]);
        
        static const NSInteger nameLabelTag = 1;
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameLabelTag];
        if (!nameLabel) {
            nameLabel = [[UILabel alloc] initWithFrame:[cell.contentView bounds]];
            [nameLabel setTextAlignment:NSTextAlignmentCenter];
            [nameLabel setTag:nameLabelTag];
            [cell.contentView addSubview:nameLabel];
            [cell.contentView setBackgroundColor:[UIColor grayColor]];
        }
        if (creature) {
            [nameLabel setText:[creature.species name]];
            [cell.contentView setTransform:[PlayViewController directionToTransform:[creature direction]]];
        } else {
            [nameLabel setText:@"-"];
            [cell.contentView setTransform:CGAffineTransformIdentity];
        }
        
        return cell;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.speciesCollectionView) {
        return [[[[self fetchedResultsController] sections] firstObject] numberOfObjects];
    } else {
        return [self.darwin numberOfColumns]*[self.darwin numberOfRows];
    }
}

- (void) handlePan:(UIPanGestureRecognizer *)panner {
    
    switch ([panner state]) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.speciesCollectionView indexPathForItemAtPoint:[panner locationInView:self.speciesCollectionView]];
            if (indexPath) {
                Species *species = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                self.tempSpeciesIndexPath = indexPath;
                [(UILabel *)[self.tempSpeciesView viewWithTag:tempSpeciesViewNameTag] setText:[species name]];
                [self.tempSpeciesView setCenter:[panner locationInView:[self view]]];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            if (self.tempSpeciesIndexPath) {
                [self.tempSpeciesView setCenter:[panner locationInView:[self view]]];
                
                NSIndexPath *indexPath = [self.darwinCollectionView indexPathForItemAtPoint:[panner locationInView:self.darwinCollectionView]];
                if (indexPath != self.tempDestinationIndexPath) {
                    if (self.tempDestinationIndexPath) {
                        UICollectionViewCell *oldCell = [self.darwinCollectionView cellForItemAtIndexPath:self.tempDestinationIndexPath];
                        [oldCell.contentView setBackgroundColor:[UIColor grayColor]];
                    }
                    if (![self.darwin creatureAtPoint:CGPointMake(indexPath.section, indexPath.item)]) {
                        self.tempDestinationIndexPath = indexPath;
                        UICollectionViewCell *newCell = [self.darwinCollectionView cellForItemAtIndexPath:indexPath];
                        [newCell.contentView setBackgroundColor:[UIColor lightGrayColor]];
                    }
                }
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (self.tempSpeciesIndexPath) {
                if (self.tempDestinationIndexPath) {
                    UICollectionViewCell *cell = [self.darwinCollectionView cellForItemAtIndexPath:self.tempDestinationIndexPath];
                    [cell.contentView setBackgroundColor:[UIColor grayColor]];
                    CGPoint point = CGPointMake(self.tempDestinationIndexPath.section, self.tempDestinationIndexPath.item);
                    Species *species = [[self fetchedResultsController] objectAtIndexPath:self.tempSpeciesIndexPath];
                    Creature *creature = [[Creature alloc] initWithSpecies:species];
                    [creature setDelegate:self.darwin];
                    [[self darwin] addCreature:creature point:point];
                    [self.darwinCollectionView reloadData];
                }
            }
            self.tempSpeciesView = nil;
        }
        default: break;
    }
}

- (UIView *)tempSpeciesView {
    if (_tempSpeciesView) {
        return _tempSpeciesView;
    }
    
    _tempSpeciesView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:[_tempSpeciesView bounds]];
    [label setTag:tempSpeciesViewNameTag];
    [label setTextAlignment:NSTextAlignmentCenter];
    [_tempSpeciesView addSubview:label];
    
    [[self view] addSubview:_tempSpeciesView];
    [_tempSpeciesView setBackgroundColor:[UIColor grayColor]];
    return _tempSpeciesView;
}

- (void) setTempSpeciesView:(UIView *)tempSpeciesView {
    [_tempSpeciesView removeFromSuperview];
    _tempSpeciesView = tempSpeciesView;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext defaultManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Species" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}
- (Darwin *)darwin {
    if (_darwin) {
        return _darwin;
    }
    
    _darwin = [[Darwin alloc] initWithRows:5 columns:5];
    [_darwin setDelegate:self];
    return _darwin;
}

+ (CGAffineTransform) directionToTransform:(CreatureDirection) direction {
    switch (direction) {
        case CreatureDirectionNorth: return CGAffineTransformMakeRotation(M_PI);
        case CreatureDirectionEast: return CGAffineTransformMakeRotation(M_PI_2);
        case CreatureDirectionWest: return CGAffineTransformMakeRotation(3 * M_PI_2);
        case CreatureDirectionSouth: return CGAffineTransformIdentity;
        default: assert (false);
    }
    return CGAffineTransformIdentity;
}

-(void)darwinDidFinishMove {
    [self.darwinCollectionView reloadData];
}
-(void)darwinDidFinishTurn:(NSUInteger)turnNum {
    [self.darwinCollectionView reloadData];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
