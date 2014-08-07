//
//  ISSChartPieSection.m
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartPieSection.h"

@implementation ISSChartPieSection

- (void)dealloc
{
    [_pieSectionProperty release];
    [super dealloc];
}

- (id)initWithPieSection:(ISSChartPieSection*)pieSection
{
    self = [super init];
    if (self) {
        _pieSectionProperty = [pieSection.pieSectionProperty copy];
        _value = pieSection.value;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartPieSection *copy = [[ISSChartPieSection allocWithZone:zone] initWithPieSection:self];
    return copy;
}

@end
