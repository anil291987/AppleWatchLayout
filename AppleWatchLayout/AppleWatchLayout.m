//
//  AppleWatchLayout.m
//  AppleWatchLayout
//
//  Created by Almer Lucke on 9/10/14.
//  Copyright (c) 2014 Aliens Are Among Us. All rights reserved.
//


#import "AppleWatchLayout.h"



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
        _sizeDropOffSpeed = 1.0;
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return [self targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:CGPointZero];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
    CGFloat contentOffsetX = proposedContentOffset.x;
    CGFloat contentOffsetY = proposedContentOffset.y;
    CGSize cellSize = [self cellSize];

    CGFloat rawRowIndex = contentOffsetY / cellSize.height;
    NSInteger rowIndex = 0;
    
    if (velocity.y > 0) {
        rowIndex = ceil(rawRowIndex);
    } else if (velocity.y < 0) {
        rowIndex = floor(rawRowIndex);
    } else {
        rowIndex = round(rawRowIndex);
    }
    
    NSInteger shiftedColumn = rowIndex % 2;
    CGFloat rawColumIndex = (contentOffsetX - shiftedColumn * cellSize.width * 0.5) / cellSize.width;
    NSInteger columnIndex = 0;
    
    if (velocity.x > 0) {
        columnIndex = ceil(rawColumIndex);
    } else if (velocity.x < 0) {
        columnIndex = floor(rawColumIndex);
    } else {
        columnIndex = round(rawColumIndex);
    }
    
    contentOffsetX = columnIndex * cellSize.width + shiftedColumn * cellSize.width * 0.5;
    contentOffsetY = rowIndex * cellSize.height;
    
    return CGPointMake(contentOffsetX, contentOffsetY);
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
            
            if (sizeScale > 1) sizeScale = 1;
            sizeScale = 1 - sizeScale;
            
            sizeScale = pow(sizeScale, self.sizeDropOffSpeed);
            
            CGAffineTransform transform = CGAffineTransformMakeScale(sizeScale, sizeScale);
            
            attributes.transform = transform;
        }
    }
    
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
