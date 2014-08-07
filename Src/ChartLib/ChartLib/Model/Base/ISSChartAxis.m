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

- (void)dealloc
{
    [_unit release];
    [_axisItems release];
    [_name release];
    [_axisProperty release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _axisType = ISSChartAxisTypeValue;
        _baseValue = CGFLOAT_MAX;
        _axisProperty = [[ISSChartAxisProperty alloc] init];
    }
    return self;
}

- (id)initWithAxis:(ISSChartAxis*)axis
{
    self = [super init];
    if (self) {
        _rotateAngle = axis.rotateAngle;
        _baseValue = axis.baseValue;
        _minValue = axis.minValue;
        _maxValue = axis.maxValue;
        _valueRange = axis.valueRange;
        _name = [axis.name copy];
        _unit = [axis.unit copy];
        _axisProperty = [axis.axisProperty copy];
        _axisItems = [axis.axisItems copy];        
    }
    return self;
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

- (void)setAxisItemsWithNames:(NSArray*)names
{
    [self setAxisItemsWithNames:names values:nil];
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
	if (CGFLOAT_MAX == _baseValue) {
		_baseValue = _minValue;
		if (_minValue < 0) {
			_baseValue = 0;
		}
	}
}

@end
