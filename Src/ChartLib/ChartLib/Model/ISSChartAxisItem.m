//
//  ISSChartAxisItem.m
//  ChartLib
//
//  Created by Sword Zhou on 5/30/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxisItem.h"

@implementation ISSChartAxisItem

- (id)initWithChartAxisItem:(ISSChartAxisItem*)axisItem
{
    self = [super init];
    if (self) {
        _name = [axisItem.name copy];
        _value = axisItem.value;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartAxisItem *copy = [[ISSChartAxisItem allocWithZone:zone] initWithChartAxisItem:self];
    return copy;
}

+ (ISSChartAxisItem*)axisItemWithName:(NSString*)name value:(NSNumber*)value
{
    ISSChartAxisItem *axisItem = [[ISSChartAxisItem alloc] init];
    axisItem.name = name;
    axisItem.value = [value floatValue];
    return [axisItem autorelease];
}

+ (NSArray*)axisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    NSAssert((names && [names count] > 0), @"names can not be empty");
    NSAssert((values && [values count] > 0), @"values can not be empty");
    NSAssert(([names count] == [values count] ), @"name array and value array should have the same size");
    NSMutableArray *axisItems = [NSMutableArray arrayWithCapacity:[names count]];
    NSInteger count = [names count];
    for (NSInteger i = 0; i < count; i++) {
        ISSChartAxisItem *axisItem = [ISSChartAxisItem axisItemWithName:names[i] value:values[i]];
        [axisItems addObject:axisItem];
    }
    return axisItems;
}

@end
