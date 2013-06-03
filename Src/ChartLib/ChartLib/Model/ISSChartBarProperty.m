//
//  ISSBarProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBarProperty.h"

@implementation ISSChartBarProperty

@synthesize strokeColor = _strokeColor;
@synthesize fillColor = _fillColor;
@synthesize gradientEndColor = _gradientEndColor;
@synthesize gradientStartColor = _gradientStartColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize frame = _frame;

- (NSDictionary*)attributeMapDictionary
{
    return @{@"strokeColor":@"strokeColor", @"fillColor":@"fillColor", @"gradientStartColor":@"gradientStartColor", @"gradientEndColor":@"gradientEndColor", @"strokeWidth":@"strokeWidth", @"frame":@"frame"};
}

- (id)initWithProperty:(ISSChartBarProperty*)property
{
    self = [super init];
    if (self) {
        _strokeColor = [property.strokeColor copy];
        _fillColor = [property.fillColor copy];
        _gradientEndColor = [property.gradientEndColor copy];
        _gradientStartColor = [property.gradientStartColor copy];
        _strokeWidth = property.strokeWidth;
        _frame = property.frame;
        _index = property.index;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartBarProperty *copy = [[ISSChartBarProperty allocWithZone:zone] initWithProperty:self];
    return copy;
}

- (id)init
{
    self = [super init];
    if (self) {
        _strokeColor = [UIColor clearColor];
        _fillColor = [RANDOMCOLOR() retain];
        _gradientStartColor = [RANDOMCOLOR() retain];
        _gradientEndColor = [RANDOMCOLOR() retain];
        _strokeWidth = DEFAULT_STROKE_WIDTH_BAR;
    }
    return self;
}

- (void)dealloc
{
    [_gradientStartColor release];
    _gradientStartColor = nil;
    [_gradientEndColor release];
    _gradientEndColor = nil;
    [_strokeColor release];
    _strokeColor = nil;
    [_fillColor release];
    _fillColor = nil;
    [super dealloc];
}
@end
