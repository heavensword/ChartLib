//
//  ISSChartWaterfallSymbolData.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-10.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallSymbolData.h"

@implementation ISSChartWaterfallSymbolData

- (void)dealloc
{
    [_strokeColor release];
    [_fillColors  release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _fillType = ISSChartVerticalFillGradient;
        _strokeWidth = DEFAULT_LINE_WIDTH;
    }
    return self;
}


- (id)initWithWaterSymbolData:(ISSChartWaterfallSymbolData*)waterfallSymbolData
{
    self = [super init];
    if (self) {
        _fillType = waterfallSymbolData.fillType;
        _symbolType = waterfallSymbolData.symbolType;
        _startValue = waterfallSymbolData.startValue;
        _endValue = waterfallSymbolData.endValue;
        _value = waterfallSymbolData.value;
        _frame = waterfallSymbolData.frame;
        _index = waterfallSymbolData.index;        
        _strokeColor = [waterfallSymbolData.strokeColor retain];
        _fillColors = [waterfallSymbolData.fillColors retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartWaterfallSymbolData *copy = [[ISSChartWaterfallSymbolData allocWithZone:zone] initWithWaterSymbolData:self];
    return copy;
}

- (UIColor*)fillColor
{
	return _fillColors[0];
}

- (NSArray*)gradientColors
{
	NSMutableArray *gradientColors = [NSMutableArray array];
	for (UIColor *color in _fillColors) {
		[gradientColors addObject:(id)color.CGColor];
	}
	return gradientColors;
}

@end
