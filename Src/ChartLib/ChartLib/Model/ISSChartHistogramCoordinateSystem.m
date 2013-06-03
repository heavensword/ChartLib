//
//  ISSChartCoordinateSystem.m
//  ChartLib
//
//  Created by Sword Zhou on 5/30/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"

@implementation ISSChartHistogramCoordinateSystem

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithHistogramCoordinateSystem:(ISSChartHistogramCoordinateSystem*)coordinateSystem
{
    self = [super init];
    if (self) {
        _xAxis = [coordinateSystem.xAxis copy];
        _yAxis = [coordinateSystem.yAxis copy];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramCoordinateSystem *copy = [[ISSChartHistogramCoordinateSystem allocWithZone:zone] initWithHistogramCoordinateSystem:self];
    return copy;
}
@end
