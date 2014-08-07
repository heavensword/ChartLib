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
	[_viceYAxis release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _xAxis = [[ISSChartAxis alloc] init];
        _xAxis.axisProperty.axisStyle = kDashingNone;
        _yAxis = [[ISSChartAxis alloc] init];
        _yAxis.axisProperty.axisStyle = kDashingSolid;
        _viceYAxis = [[ISSChartAxis alloc] init];
        _viceYAxis.axisType = ISSChartAxisTypeValue;
        _viceYAxis.axisProperty.axisStyle = kDashingNone;
        
        _leftMargin = DEFAULT_PADDING_AXIS_X;
        _rightMargin = DEFAULT_PADDING_AXIS_X;
        _topMargin = DEFAULT_PADDING_AXIS_Y;
        _bottomMargin = DEFAULT_PADDING_AXIS_Y;
    }
    return self;
}

- (id)initWithCoordinateSystem:(ISSChartCoordinateSystem*)coordinateSystem
{
    self = [super init];
    if (self) {
        _leftMargin = coordinateSystem.leftMargin;
        _topMargin = coordinateSystem.topMargin;
        _rightMargin = coordinateSystem.rightMargin;
        _bottomMargin = coordinateSystem.bottomMargin;
        _xAxis = [coordinateSystem.xAxis copy];
        _yAxis = [coordinateSystem.yAxis copy];
        _viceYAxis = [coordinateSystem.viceYAxis copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartCoordinateSystem *copy = [[ISSChartCoordinateSystem allocWithZone:zone] initWithCoordinateSystem:self];
    return copy;
}
@end
