//
//  ISSCharBarGroup.m
//  ChartLib
//
//  Created by Sword Zhou on 5/30/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBarGroup.h"

@implementation ISSChartBarGroup

- (id)initWithBarGroup:(ISSChartBarGroup*)barGroup
{
    self = [super init];
    if (self) {
        _index = barGroup.index;
        _bars = [[NSArray alloc] initWithArray:barGroup.bars copyItems:TRUE];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartBarGroup *copy = [[ISSChartBarGroup allocWithZone:zone] initWithBarGroup:self];
    return copy;
}

- (void)dealloc
{
    [_bars release];
    [super dealloc];
}
@end
