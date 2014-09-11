//
//  AppleWatchLayout.m
//  AppleWatchLayout
//
//  Created by Almer Lucke on 9/10/14.
//  Copyright (c) 2014 Aliens Are Among Us. All rights reserved.
//


#import "AppleWatchLayout.h"

/*
 elements are layed out on a 5 x 6 grid, when a grid is full the next grid is to the right in rows of 3, then we go down
 
 */


@interface AppleWatchLayout ()
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic) BOOL needChangeCache;
@end


@implementation AppleWatchLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _needChangeCache = YES;
        _numberOfColumnsPerRow = 12;
        _numberOfVisibleColumns = 4;
    }
    
    return self;
}

- (CGSize)cellSize
{
    CGFloat cellWidth = self.collectionView.bounds.size.width / self.numberOfVisibleColumns;
    
    return CGSizeMake(cellWidth, cellWidth);
}

- (NSInteger)numberOfRows
{
    return ceil([self.collectionView numberOfItemsInSection:0] / self.numberOfColumnsPerRow);
}

- (void)setNumberOfColumnsPerRow:(NSInteger)numberOfColumnsPerRow
{
    _numberOfColumnsPerRow = numberOfColumnsPerRow;
    
    self.needChangeCache = YES;
}

- (void)setNumberOfVisibleColumns:(CGFloat)numberOfVisibleColumns
{
    _numberOfVisibleColumns = numberOfVisibleColumns;
    
    self.needChangeCache = YES;
}

- (CGRect)gridRectForIndex:(NSInteger)index
{
    CGSize cellSize = [self cellSize];
    NSInteger gridRowIndex = index / self.numberOfColumnsPerRow;
    NSInteger gridColumnIndex = index - (gridRowIndex * self.numberOfColumnsPerRow);
    NSInteger cellXOffset = (gridRowIndex % 2) * cellSize.width * 0.5 + self.collectionView.bounds.size.width * 0.5 - cellSize.width * 0.5;
    NSInteger cellYOffset = self.collectionView.bounds.size.height * 0.5 - cellSize.height * 0.5;
    
    return CGRectMake(gridColumnIndex * cellSize.width + cellXOffset,
                      gridRowIndex * cellSize.height + cellYOffset,
                      cellSize.width,
                      cellSize.height);
}

- (CGSize)collectionViewContentSize
{
    CGSize cellSize = [self cellSize];
    NSInteger numberOfRows = [self numberOfRows];
    CGFloat width = 0;
    CGFloat height = 0;
    
    width = self.numberOfColumnsPerRow * cellSize.width + self.collectionView.bounds.size.width - cellSize.width * 0.5;
    height = numberOfRows * cellSize.height + self.collectionView.bounds.size.height;
    
    return CGSizeMake(width, height);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.needChangeCache) {
        self.needChangeCache = NO;
        
        NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:[self.collectionView numberOfItemsInSection:0]];
        
        for (NSInteger index = 0; index < [self.collectionView numberOfItemsInSection:0]; index++) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            [allAttributes addObject:attributes];
        }
        
        self.attributes = allAttributes;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleElements = [NSMutableArray array];
    
//    CGSize cellSize = [self cellSize];
//    CGFloat halfBoundsWidth = self.collectionView.bounds.size.width * 0.5;
    CGFloat sizeScaleNormalize = self.collectionView.bounds.size.width / 1.5;
    
    for (UICollectionViewLayoutAttributes *attributes in self.attributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [visibleElements addObject:attributes];
            
            CGPoint boundsMid = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMidY(self.collectionView.bounds));
            CGPoint visMid = CGPointMake(CGRectGetMidX(attributes.frame), CGRectGetMidY(attributes.frame));
            CGFloat distX = visMid.x - boundsMid.x;
            CGFloat distY = visMid.y - boundsMid.y;
            CGFloat dist = sqrt(distX * distX + distY * distY);
            CGFloat sizeScale = dist / sizeScaleNormalize;
            
//            CGFloat curve = 0;
//            CGFloat sign = (distY >= 0)? -1 : 1;
            
            if (sizeScale > 1) sizeScale = 1;
            sizeScale = 1 - sizeScale;
            
            CGAffineTransform transform = CGAffineTransformMakeScale(sizeScale, sizeScale);
            
            attributes.transform = transform;
        }
    }
    
//    NSInteger startIndex = [self indexForPoint:rect.origin];
//    NSInteger endIndex = [self indexForPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
//    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:endIndex - startIndex];
//    
//    NSLog(@"startIndex = %ld, endIndex = %ld", startIndex, endIndex);
//    
//    for (NSInteger index = startIndex; index < endIndex; index++) {
//        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//        
//        [allAttributes addObject:attributes];
//    }
    
    /*
    @property (nonatomic) CGRect frame;
    @property (nonatomic) CGPoint center;
    @property (nonatomic) CGSize size;
    @property (nonatomic) CATransform3D transform3D;
    @property (nonatomic) CGRect bounds NS_AVAILABLE_IOS(7_0);
    @property (nonatomic) CGAffineTransform transform NS_AVAILABLE_IOS(7_0);
    @property (nonatomic) CGFloat alpha;
    @property (nonatomic) NSInteger zIndex; // default is 0
    @property (nonatomic, getter=isHidden) BOOL hidden; // As an optimization, UICollectionView might not create a view for items whose hidden attribute is YES
    @property (nonatomic, retain) NSIndexPath *indexPath;
     */
    
    return visibleElements;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger index = indexPath.item;
    
    attributes.frame = [self gridRectForIndex:index];
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
