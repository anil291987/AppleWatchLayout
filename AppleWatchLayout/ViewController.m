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
    
    layout.numberOfVisibleColumns = 6;
    layout.numberOfColumnsPerRow = 18;
    
    [self.collectionView registerClass:[TestCell class] forCellWithReuseIdentifier:@"TestCell"];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
//    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (object == self.collectionView && [keyPath isEqualToString:@"contentOffset"]) {
//        NSArray *cells = [self.collectionView visibleCells];
//        
//        for (UICollectionViewCell *cell in cells) {
//            CGFloat scale = [self scaleForFrame:cell.frame];
//            cell.transform = CGAffineTransformMakeScale(scale, scale);
//        }
//    }
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 400;
}

- (CGFloat)displacementForFrame:(CGRect)frame
{
    return 0;
}

//- (CGFloat)scaleForFrame:(CGRect)frame
//{
//    CGPoint boundsMid = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMidY(self.collectionView.bounds));
//    CGPoint visMid = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
//    CGFloat distX = boundsMid.x - visMid.x;
//    CGFloat distY = boundsMid.y - visMid.y;
//    CGFloat dist = sqrt(distX * distX + distY * distY);
//    CGFloat sizeScale = dist / (self.collectionView.bounds.size.width / 1.5);
//    
//    if (sizeScale > 1) sizeScale = 1;
//    
//    sizeScale = 1 - sizeScale;
//    
//    return sizeScale;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select");
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TestCell" forIndexPath:indexPath];
//    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
//    CGFloat scale = [self scaleForFrame:attributes.frame];
//    
//    cell.transform = CGAffineTransformMakeScale(scale, scale);
    
    return cell;
}

@end
