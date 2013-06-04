//
//  ISSChartAxisProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxisProperty.h"

@implementation ISSChartAxisProperty

@synthesize axisStyle = _axisStyle;
@synthesize padding = _padding;
@synthesize strokeWidth = _strokeWidth;
@synthesize strokeColor = _strokeColor;
@synthesize labelFont = _labelFont;

- (id)init
{
    self = [super init];
    if (self) {
        _strokeWidth = DEFAULT_STROKE_WIDTH_AXIS;
        _padding = DEFAULT_PADDING_AXIS;
        _axisStyle = kDashingSolid;
        _strokeColor = [[UIColor grayColor] retain];        
        _labelFont = [[UIFont systemFontOfSize:16] retain];
    }
    return self;
}

- (id)initWithAxisProperty:(ISSChartAxisProperty*)axisProperty
{
    self = [super init];
    if (self) {
        _strokeColor = [axisProperty.strokeColor retain];
        _labelFont = [axisProperty.labelFont retain];
        _strokeWidth = axisProperty.strokeWidth;
        _axisStyle = axisProperty.axisStyle;
        _padding = axisProperty.padding;

    }
    return self;
}

- (void)dealloc
{
    [_labelFont release];
    _labelFont = nil;
    [_strokeColor release];
    _strokeColor = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartAxisProperty *copy = [[ISSChartAxisProperty allocWithZone:zone] initWithAxisProperty:self];
    return copy;
}
@end
