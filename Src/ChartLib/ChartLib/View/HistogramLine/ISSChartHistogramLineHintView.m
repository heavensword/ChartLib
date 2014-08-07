//
//  ISSChartLineHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLineHintView.h"

@interface ISSChartHistogramLineHintView()

@property (retain, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation ISSChartHistogramLineHintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
	[_hint release];
    [_hintLabel release];
    [_imageView release];
    [super dealloc];
}

- (void)setHint:(NSString *)hint
{
	RELEASE_SAFELY(_hint);
	_hint = [hint retain];
    self.hintLabel.text = self.hint;	
	[self adjust];
}

- (void)adjust
{
	CGFloat height = [_hint heightWithFont:self.hintLabel.font withLineWidth:CGRectGetWidth(self.hintLabel.frame)] + 20;
	self.height = height;
}

- (void)showInView:(UIView *)superView
{
    [superView addSubview:self];
    [self show];
}

- (void)adjustViewPosition:(CGSize)offset
{
	self.imageView.transform = CGAffineTransformIdentity;
    if (CGRectGetMaxX(self.frame) >= CGRectGetWidth(self.superview.bounds)) {
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, -1, 1);
        self.right = CGRectGetMinX(self.frame) - offset.width;
    }
}
@end
