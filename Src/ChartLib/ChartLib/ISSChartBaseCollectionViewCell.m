//
//  ISSChartBaseCollectionViewCell.m
//  ChartLib
//
//  Created by Sword on 13-12-6.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseCollectionViewCell.h"

@implementation ISSChartBaseCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

+ (id)cellFromNib
{
	return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
@end
