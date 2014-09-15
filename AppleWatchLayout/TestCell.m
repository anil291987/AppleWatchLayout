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
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(2, 1);
        self.contentView.layer.shadowOpacity = 0.5;
        self.contentView.layer.shadowRadius = 3;
        self.contentView.layer.allowsEdgeAntialiasing = YES;
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        self.shapeLayer.fillColor = [[self class] randomAppleColor].CGColor;
        
        self.shapeLayer.allowsEdgeAntialiasing = YES;
        [self.contentView.layer addSublayer:self.shapeLayer];
    }
    
    return self;
}

+ (UIColor *)randomAppleColor
{
    static NSArray *appleColors = nil;
    
    if (!appleColors) {
        appleColors = @[[UIColor colorWithRed:166/255.0 green:254/255.0 blue:120/255.0 alpha:1],
                        [UIColor colorWithRed:101/255.0 green:219/255.0 blue:248/255.0 alpha:1],
                        [UIColor colorWithRed:229/255.0 green:107/255.0 blue:90/255.0 alpha:1],
                        [UIColor colorWithRed:234/255.0 green:142/255.0 blue:54/255.0 alpha:1],
                        [UIColor colorWithRed:225/255.0 green:48/255.0 blue:167/255.0 alpha:1],
                        [UIColor colorWithRed:195/255.0 green:253/255.0 blue:93/255.0 alpha:1],
                        [UIColor colorWithRed:205/255.0 green:203/255.0 blue:206/255.0 alpha:1],
                        [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1]];
    }
    
    return appleColors[arc4random_uniform((u_int32_t)[appleColors count])];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    self.shapeLayer.frame = self.bounds;
}

@end
