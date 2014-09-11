//
//  TestCell.m
//  AppleWatchLayout
//
//  Created by Almer Lucke on 9/11/14.
//  Copyright (c) 2014 Aliens Are Among Us. All rights reserved.
//

#import "TestCell.h"
#import <QuartzCore/QuartzCore.h>


@interface TestCell ()
@end

@implementation TestCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(128) + 128) / 255.0
                                                           green:(arc4random_uniform(128) + 128) / 255.0
                                                            blue:(arc4random_uniform(128) + 128) / 255.0 alpha:1];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 1);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 3;
        self.layer.allowsEdgeAntialiasing = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
