//
//  ISSChartDashboardLegend.m
//  ChartLib
//
//  Created by Sword on 13-11-5.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardLegendView.h"

@implementation ISSChartDashboardLegendView

- (void)dealloc
{
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_chartType = ISSChartTypeDashboard;
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

@end
