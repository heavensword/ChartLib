//
//  ISSChartBarHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHintView.h"

@implementation ISSChartHintView

- (void)dealloc
{
    [_reuseIdentifier release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private methods
- (void)setup
{
    self.reuseIdentifier = NSStringFromClass([self class]);    
}

- (CATransform3D)layerTransformForScale:(CGFloat)scale targetFrame:(CGRect)targetFrame
{
    //	CGFloat horizontalDelta = targetFrame.size.width/2;
	CGFloat hotizontalScaleTransform = 1.0;//(horizontalDelta * scale) - horizontalDelta;
	
	CGFloat verticalDelta = roundf(targetFrame.size.height/2);
	CGFloat verticalScaleTransform = verticalDelta - (verticalDelta * scale);
	
	CGAffineTransform affineTransform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, hotizontalScaleTransform, verticalScaleTransform);
	return CATransform3DMakeAffineTransform(affineTransform);
}

#pragma mark - public methods
- (void)show
{
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.duration = 0.35;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSNumber numberWithFloat:1.2]];
    [values addObject:[NSNumber numberWithFloat:0.9]];
    [values addObject:[NSNumber numberWithFloat:1.1]];
    [values addObject:[NSNumber numberWithFloat:1]];
    [scaleAnimation setValues:values];
	[self.layer addAnimation:scaleAnimation forKey:@"scaleanimatino"];
}

- (void)adjust
{
}

+ (id)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
}
@end
