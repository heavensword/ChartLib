//
//  ISSChartAxisProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxisProperty.h"

@implementation ISSChartAxisProperty

- (void)dealloc
{
    [_textColor release];
    [_gridColor release];
    [_labelFont release];
    [_strokeColor release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
		_needDisplayUnit = TRUE;
		_gridWith = 1.0;
        _strokeWidth = DEFAULT_AXIS_LINE_WIDTH;
        _axisStyle = kDashingNone;
        _textColor  = [[UIColor grayColor] retain];
        _gridColor = [[UIColor grayColor] retain];
        _strokeColor = [[UIColor darkGrayColor] retain];
        _labelFont = [[UIFont systemFontOfSize:16] retain];
    }
    return self;
}

- (id)initWithAxisProperty:(ISSChartAxisProperty*)axisProperty
{
    self = [super init];
    if (self) {
		_needDisplayUnit = axisProperty.needDisplayUnit;
		_gridWith = axisProperty.gridWith;
        _strokeWidth = axisProperty.strokeWidth;
        _axisStyle = axisProperty.axisStyle;
        _axisType = axisProperty.axisType;
        _textColor = [axisProperty.textColor retain];
        _gridColor = [axisProperty.gridColor retain];
        _strokeColor = [axisProperty.strokeColor retain];
        _labelFont = [axisProperty.labelFont retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartAxisProperty *copy = [[ISSChartAxisProperty allocWithZone:zone] initWithAxisProperty:self];
    return copy;
}
@end
