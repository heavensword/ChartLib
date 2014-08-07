//
//  ISSLegend.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineLegendView.h"

@interface ISSChartLineLegendView()
{
}
@end

@implementation ISSChartLineLegendView

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_chartType = ISSChartTypeLine;
    }
    return self;
}

#pragma mark - private methods

@end
