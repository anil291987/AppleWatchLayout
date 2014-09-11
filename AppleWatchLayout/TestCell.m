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
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation TestCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(128) + 128) / 255.0
                                                           green:(arc4random_uniform(128) + 128) / 255.0
                                                            blue:(arc4random_uniform(128) + 128) / 255.0 alpha:1];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        self.shapeLayer = shapeLayer;
        self.contentView.layer.mask = self.shapeLayer;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
}

@end
