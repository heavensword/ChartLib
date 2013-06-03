//
//  ISSBar.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBar.h"

@implementation ISSChartBar

@synthesize name = _name;
@synthesize valueX = _valueX;
@synthesize valueY = _valueY;

- (NSDictionary*)attributeMapDictionary
{
    return @{@"name":@"name", @"valueX":@"valueX", @"valueY":@"valueY"};
}

- (id)initWithBar:(ISSChartBar*)bar
{
    self = [super init];
    if (self) {
        _name = [bar.name retain];
        _valueX = bar.valueX;
        _valueY = bar.valueY;
        _barProperty = [bar.barProperty copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartBar *copy = [[ISSChartBar allocWithZone:zone] initWithBar:self];
    return copy;
}

- (void)dealloc
{
    [_barProperty release];
    [_name release];
    [super dealloc];
}
@end
