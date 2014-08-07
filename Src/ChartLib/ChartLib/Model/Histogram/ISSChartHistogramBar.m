//
//  ISSBar.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramBar.h"

@implementation ISSChartHistogramBar

- (NSDictionary*)attributeMapDictionary
{
    return @{@"name":@"name", @"valueX":@"valueX", @"valueY":@"valueY",@"valueYOriginValue":@"valueYOriginValue"};
}

- (id)initWithBar:(ISSChartHistogramBar*)bar
{
    self = [super init];
    if (self) {
		_name = [bar.name copy];
        _barProperty = [bar.barProperty copy];
        _valueY = bar.valueY;
        _originValueY = bar.originValueY;
        _index = bar.index;
        _groupIndex = bar.groupIndex;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramBar *copy = [[ISSChartHistogramBar allocWithZone:zone] initWithBar:self];
    return copy;
}

- (void)dealloc
{
	[_name release];
    [_barProperty release];
    [super dealloc];
}

#pragma mark - public methods

@end
