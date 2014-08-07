//
//  ISSChartWaterfallData.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallData.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisItem.h"
#import "ISSChartWaterfallSymbolData.h"
#import "ISSChartLegend.h"
#import "ISSChartColorUtil.h"

@interface ISSChartWaterfallData()

@property (nonatomic, retain) NSArray *strokeColors;
@property (nonatomic, retain) NSArray *fillColors;
@property (nonatomic, retain) NSArray *originValues;    //原始数据

@end

@implementation ISSChartWaterfallData

- (void)dealloc
{
    [_strokeColors release];
    [_fillColors release];
    [_originValues release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
    }
    return self;
}

- (id)initWithWaterfallData:(ISSChartWaterfallData*)waterfallData
{
    self = [super init];
    if (self) {
		_legendFontSize = waterfallData.legendFontSize;
        _coordinateSystem = [waterfallData.coordinateSystem copy];
        _legendTextArray = [waterfallData.legendTextArray retain];
        _legends = [waterfallData.legends retain];
        _legendPosition = waterfallData.legendPosition;
        _originValues = [[NSArray alloc] initWithArray:waterfallData.originValues copyItems:TRUE];
        _strokeColors = [waterfallData.strokeColors retain];
        _fillColors = [waterfallData.fillColors retain];
        _symbols = [[NSArray alloc] initWithArray:waterfallData.symbols copyItems:TRUE];
        _barWidth = waterfallData.barWidth;
        _spacing = waterfallData.spacing;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartWaterfallData *copy = [[ISSChartWaterfallData allocWithZone:zone] initWithWaterfallData:self];
    return copy;
}

#pragma mark - public methods
- (CGFloat)getMaxYValue
{
    CGFloat maxValue = 0;
    for (ISSChartWaterfallSymbolData *symbolData in _symbols) {
        if (symbolData.endValue > maxValue) {
            maxValue = symbolData.endValue;
        }
    }
    return maxValue;
}

- (CGFloat)getMinYValue
{
    CGFloat minValue = CGFLOAT_MAX;
    for (ISSChartWaterfallSymbolData *symbolData in _symbols) {
        if (symbolData.startValue < minValue) {
            minValue = symbolData.startValue;
        }
    }
    return minValue;
}

- (void)setValues:(NSArray *)values;
{
    self.originValues = values;
}

- (void)readyData
{
    [self generateSymbols];
	[self generateSymbolsProperty];
	[self tryToGenerateYAxis];
}

- (void)generateSymbols
{
    NSMutableArray *symbos = [[NSMutableArray alloc] init];
    NSInteger count = [self.originValues count];
    CGFloat sum = 0.0;
    for (NSInteger i = 0; i < count; i++) {
        ISSChartWaterfallSymbolData *symbolData = [[ISSChartWaterfallSymbolData alloc] init];
        symbolData.strokeColor = [UIColor clearColor];
        symbolData.fillColors = @[[ISSChartColorUtil colorWithType:(i) % 15], [ISSChartColorUtil colorWithType:(i + 2) % 15]];
        symbolData.value = [_originValues[i] floatValue];
        symbolData.index = i;
        if (0 == i || i == count - 1) {
            symbolData.startValue = 0;
            symbolData.endValue = symbolData.value;
            symbolData.symbolType = ISSChartSymbolRectangle;
        }
        else {
            symbolData.startValue = sum;
            symbolData.endValue = sum + symbolData.value;
            if (symbolData.endValue > symbolData.startValue) {
                symbolData.symbolType = ISSChartSymbolArrowUp;
            }
            else {
                symbolData.symbolType = ISSChartSymbolArrowDown;
            }
        }
        sum += symbolData.value;
        [symbos addObject:symbolData];
        [symbolData release];
    }
    self.symbols = symbos;
    [symbos release];
}

- (void)generateSymbolsProperty
{
	//set stroke color
    if (_strokeColors && [_strokeColors count] &&
        _symbols && [_symbols count]) {
        NSAssert([_strokeColors count] == [_symbols count], @"the number of stroke colors not equal to number of datas");
        NSInteger index = 0;
        for (ISSChartWaterfallSymbolData *symbolData in _symbols) {
            symbolData.strokeColor = _strokeColors[index];
            index++;
        }
    }
    //set fill color
    if (_fillColors && [_fillColors count] &&
        _symbols && [_symbols count]) {
        NSAssert([_fillColors count] == [_symbols count], @"the number of fill colors not equal to number of datas");
        NSInteger index = 0;
        for (ISSChartWaterfallSymbolData *symbolData in _symbols) {
            symbolData.fillColors = _fillColors[index];
            index++;
        }
    }
}

- (void)adjustDataToZeroState
{
    for (ISSChartWaterfallSymbolData *symbol in _symbols) {
        symbol.endValue = symbol.startValue;
    }
}
@end
