//
//  AppleWatchLayout.h
//  AppleWatchLayout
//
//  Created by Almer Lucke on 9/10/14.
//  Copyright (c) 2014 Aliens Are Among Us. All rights reserved.
//


#import <UIKit/UIKit.h>





@interface AppleWatchLayout : UICollectionViewLayout
@property (nonatomic) CGSize viewPortSize;
@property (nonatomic) NSInteger numberOfElements;
@property (nonatomic) NSInteger numberOfGridsPerRow;
@property (nonatomic) NSInteger numberOfGridsPerColumn;
@property (nonatomic) NSInteger numberOfColumnsPerGrid;
@property (nonatomic) NSInteger numberOfRowsPerGrid;
@end