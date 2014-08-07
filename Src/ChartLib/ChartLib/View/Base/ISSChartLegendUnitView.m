//
//  ISSChartLegendUnitView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLegendUnitView.h"
#import "ISSChartLegend.h"


#import "ISSChartLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartUtil.h"

@implementation ISSChartLegendUnitView

- (void)dealloc
{
    [_legend release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = FALSE;
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

#pragma mark - private methods

@end
