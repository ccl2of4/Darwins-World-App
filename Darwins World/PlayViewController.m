//
//  PlayViewController.m
//  Darwins World
//
//  Created by Connor Lirot on 11/11/14.
//  Copyright (c) 2014 Connor Lirot. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *speciesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *darwinCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic) UIView *tempSpeciesView;

@end

@implementation PlayViewController {
    UIView *_tempSpeciesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.speciesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.darwinCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panner setDelegate:self];
    [self.speciesCollectionView addGestureRecognizer:panner];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.speciesCollectionView)
    {
        UICollectionViewCell *cell = [self.speciesCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UIColor *color = [UIColor redColor];
        [cell setBackgroundColor:color];
        return cell;
    }
    
    else if (collectionView == self.darwinCollectionView)
    {
        UICollectionViewCell *cell = [self.darwinCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor grayColor]];
        return cell;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (void) handlePan:(UIPanGestureRecognizer *)panner {
    
    switch ([panner state]) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.speciesCollectionView indexPathForItemAtPoint:[panner locationInView:self.speciesCollectionView]];
            [self.tempSpeciesView setCenter:[panner locationInView:[self view]]];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            [self.tempSpeciesView setCenter:[panner locationInView:[self view]]];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            NSIndexPath *indexPath = [self.darwinCollectionView indexPathForItemAtPoint:[panner locationInView:self.darwinCollectionView]];
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
    [[self view] addSubview:_tempSpeciesView];
    [_tempSpeciesView setBackgroundColor:[UIColor greenColor]];
    return _tempSpeciesView;
}

- (void) setTempSpeciesView:(UIView *)tempSpeciesView {
    [_tempSpeciesView removeFromSuperview];
    _tempSpeciesView = tempSpeciesView;
}

- (IBAction)handleButtonTouchUpInside:(id)sender {
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
