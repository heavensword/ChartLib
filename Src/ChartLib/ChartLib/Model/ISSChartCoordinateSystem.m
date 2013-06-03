//
//  ISSChartCoordinateSystem.m
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"

@implementation ISSChartCoordinateSystem

- (void)dealloc
{
    [_xAxis release];
    [_yAxis release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _xAxis = [[ISSChartAxis alloc] init];
        _xAxis.axisProperty.padding = DEFAULT_PADDING_AXIS_X;
        _yAxis = [[ISSChartAxis alloc] init];
        _yAxis.axisProperty.padding = DEFAULT_PADDING_AXIS_Y;
    }
    return self;
}

@end
