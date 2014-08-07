//
//  ISSChartLineHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallHintView.h"

@interface ISSChartWaterfallHintView()

@property (retain, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation ISSChartWaterfallHintView

- (void)dealloc
{
    [_hint release];
    [_hintLabel release];
    [_imageView release];
    [super dealloc];
}
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
    self.hintLabel.text = self.hint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
