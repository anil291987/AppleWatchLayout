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
    }
    
    return self;
}

- (NSInteger)numberOfElementsPerGrid
{
    return self.numberOfRowsPerGrid * self.numberOfColumnsPerGrid;
}

- (NSInteger)numberOfGrids
{
    NSInteger numberOfElementsPerGrid = [self numberOfElementsPerGrid];
    
    return ceil(self.numberOfElements / numberOfElementsPerGrid);
}

- (NSInteger)numberOfGridRows
{
    NSInteger numberOfGrids = [self numberOfGrids];
    
    return ceil(numberOfGrids / self.numberOfGridsPerRow);
}

- (CGFloat)gridWidth
{
    return self.viewPortSize.width / self.numberOfGridsPerRow;
}

- (CGFloat)gridCellWidth
{
    return self.viewPortSize.width / (self.numberOfGridsPerRow * self.numberOfColumnsPerGrid);
}

- (CGFloat)gridHeight
{
    return self.viewPortSize.height / self.numberOfGridsPerColumn;
}

- (CGFloat)gridCellHeight
{
    return self.viewPortSize.height / (self.numberOfGridsPerColumn * self.numberOfRowsPerGrid);
}

- (void)setViewPortSize:(CGSize)viewPortSize
{
    _viewPortSize = viewPortSize;
    
    self.needChangeCache = YES;
}

- (void)setNumberOfColumnsPerGrid:(NSInteger)numberOfColumnsPerGrid
{
    _numberOfColumnsPerGrid = numberOfColumnsPerGrid;
    
    self.needChangeCache = YES;
}

- (void)setNumberOfRowsPerGrid:(NSInteger)numberOfRowsPerGrid
{
    _numberOfRowsPerGrid = numberOfRowsPerGrid;
    
    self.needChangeCache = YES;
}

- (void)setNumberOfGridsPerColumn:(NSInteger)numberOfGridsPerColumn
{
    _numberOfGridsPerColumn = numberOfGridsPerColumn;
    
    self.needChangeCache = YES;
}

- (void)setNumberOfGridsPerRow:(NSInteger)numberOfGridsPerRow
{
    _numberOfGridsPerRow = numberOfGridsPerRow;
    
    self.needChangeCache = YES;
}

- (CGRect)gridRectForIndex:(NSInteger)index
{
    NSInteger numberOfElementsPerGrid = [self numberOfElementsPerGrid];
    NSInteger gridIndex = index / numberOfElementsPerGrid;
    NSInteger gridRowIndex = gridIndex / self.numberOfGridsPerRow;
    NSInteger gridColumnIndex = gridIndex - (gridRowIndex * self.numberOfGridsPerRow);
    NSInteger gridCellIndex = index - (gridIndex * numberOfElementsPerGrid);
    NSInteger gridCellRowIndex = gridCellIndex / self.numberOfColumnsPerGrid;
    NSInteger gridCellColumnIndex = gridCellIndex - (gridCellRowIndex * self.numberOfColumnsPerGrid);
    NSInteger cellXOffset = (gridCellRowIndex % 2) * [self gridCellWidth] * 0.5 + self.viewPortSize.width * 0.5 - [self gridCellWidth] * 0.5;
    NSInteger cellYOffset = self.viewPortSize.height * 0.5 - [self gridCellHeight] * 0.5;
    
    return CGRectMake(gridColumnIndex * [self gridWidth] + gridCellColumnIndex * [self gridCellWidth] + cellXOffset,
                      gridRowIndex * [self gridHeight] + gridCellRowIndex * [self gridCellHeight] + cellYOffset,
                      [self gridCellWidth],
                      [self gridCellHeight]);
}

- (CGSize)collectionViewContentSize
{
    NSInteger numberOfGridRows = [self numberOfGridRows];
    CGFloat width = 0;
    CGFloat height = 0;
    
    width = self.viewPortSize.width * 2;
    height = numberOfGridRows * [self gridHeight] + self.viewPortSize.height;
    
    return CGSizeMake(width, height);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.needChangeCache) {
        self.needChangeCache = NO;
        
        NSLog(@"prepare %d", [self.collectionView numberOfItemsInSection:0]);
        
        NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:[self.collectionView numberOfItemsInSection:0]];
        
        for (NSInteger index = 0; index < [self.collectionView numberOfItemsInSection:0]; index++) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            [allAttributes addObject:attributes];
        }
        
        self.attributes = allAttributes;
    }
}

- (NSInteger)indexForPoint:(CGPoint)point
{
    NSInteger cellColumnIndex = point.x / [self gridCellWidth];
    NSInteger cellRowIndex = point.y / [self gridCellHeight];
    NSInteger gridColumn = cellColumnIndex / self.numberOfColumnsPerGrid;
    NSInteger gridRow = cellRowIndex / self.numberOfRowsPerGrid;
    NSInteger gridCellColumn = cellColumnIndex - (gridColumn * self.numberOfColumnsPerGrid);
    NSInteger gridCellRow = cellRowIndex - (gridRow * self.numberOfRowsPerGrid);
    NSInteger index = gridRow * [self numberOfElementsPerGrid] * self.numberOfGridsPerRow + gridColumn * [self numberOfElementsPerGrid] + gridCellRow * self.numberOfColumnsPerGrid + gridCellColumn;
    
    return index;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleElements = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in self.attributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [visibleElements addObject:attributes];
            
            CGPoint boundsMid = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMidY(self.collectionView.bounds));
            CGPoint visMid = CGPointMake(CGRectGetMidX(attributes.frame), CGRectGetMidY(attributes.frame));
            CGFloat distX = boundsMid.x - visMid.x;
            CGFloat distY = boundsMid.y - visMid.y;
            CGFloat dist = sqrt(distX * distX + distY * distY);
            CGFloat sizeScale = dist / (self.collectionView.bounds.size.width / 1.5);
            
            if (sizeScale > 1) sizeScale = 1;
            
            sizeScale = 1 - sizeScale;
            
            
            
            attributes.transform = CGAffineTransformMakeScale(sizeScale, sizeScale);
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
