//
//  ISSAxis.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartAxisItem.h"

@implementation ISSChartAxis

@synthesize valueRange = _valueRange;

- (id)init
{
    self = [super init];
    if (self) {
        _baseValue = 0;
        _axisProperty = [[ISSChartAxisProperty alloc] init];
    }
    return self;
}

- (id)initWithAxis:(ISSChartAxis*)axis
{
    self = [super init];
    if (self) {
        _axisItems = [axis.axisItems copy];
        _baseValue = axis.baseValue;
        _minValue = axis.minValue;
        _maxValue = axis.maxValue;
        _valueRange = axis.valueRange;
        _axisProperty = [axis.axisProperty copy];
    }
    return self;
}

- (void)dealloc
{
    [_axisProperty release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartAxis *copy = [[ISSChartAxis allocWithZone:zone] initWithAxis:self];
    return copy;
}

#pragma mark - public methods
- (CGFloat)valueRange
{    
    return fabsf(_maxValue - _minValue);
}

- (void)setAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    self.axisItems = [ISSChartAxisItem axisItemsWithNames:names values:values];    
    _minValue = CGFLOAT_MAX;
    _maxValue = CGFLOAT_MIN;
    for (ISSChartAxisItem *axisItem in _axisItems) {
        if (axisItem.value > _maxValue) {
            _maxValue = axisItem.value;
        }
        if (axisItem.value < _minValue) {
            _minValue = axisItem.value;
        }
    }
    _baseValue = _minValue;
}

- (NSArray*)values
{
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[_axisItems count]];
    for (ISSChartAxisItem *axisItem in _axisItems) {
        [values addObject:@(axisItem.value)];
    }
    return values;
}

- (NSArray*)names
{
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:[_axisItems count]];
    for (ISSChartAxisItem *axisItem in _axisItems) {
        [names addObject:axisItem.name];
    }
    return names;
}
@end
