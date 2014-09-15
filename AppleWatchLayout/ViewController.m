//
//  ViewController.m
//  AppleWatchLayout
//
//  Created by Almer Lucke on 9/10/14.
//  Copyright (c) 2014 Aliens Are Among Us. All rights reserved.
//

#import "ViewController.h"
#import "AppleWatchLayout.h"
#import "TestCell.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppleWatchLayout *layout = [[AppleWatchLayout alloc] init];
    
    layout.numberOfVisibleColumns = 4;
    layout.numberOfColumnsPerRow = 12;
    layout.dropOffSpeed = 0.6;
    
    [self.collectionView registerClass:[TestCell class] forCellWithReuseIdentifier:@"TestCell"];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 400;
}

- (CGFloat)displacementForFrame:(CGRect)frame
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select");
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TestCell" forIndexPath:indexPath];
    
    return cell;
}

@end
