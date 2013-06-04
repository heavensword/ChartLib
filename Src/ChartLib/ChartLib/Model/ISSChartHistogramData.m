//
//  ISSHistogram.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramData.h"
#import "ISSChartBar.h"
#import "ISSChartBarProperty.h"
#import "ISSChartAxis.h"
#import "ISSChartHistogramCoordinateSystem.h"
#import "ISSChartBarGroup.h"
#import "ISSChartColorUtil.h"

@interface ISSChartHistogramData()
{
}
@end

@implementation ISSChartHistogramData

@synthesize barColors = _barColors;

- (NSDictionary*)attributeMapDictionary
{
    return @{@"bars":@"bars", @"properties":@"properties", @"higtogramStyle":@"higtogramStyle"};
}

- (void)dealloc
{
    [_barColors release];
    [_legendArray release];
    [_bars release];    
    [_barGroups release];
    [_barDataArrays release];
    [_coordinateSystem release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _histogramStyle = ISSHistogramPlain;
        _coordinateSystem = [[ISSChartHistogramCoordinateSystem alloc] init];
    }
    return self;
}

- (id)initWithHistogram:(ISSChartHistogramData*)histogram
{
    self = [super init];
    if (self) {
        _coordinateSystem = [histogram.coordinateSystem copy];
        _barDataArrays = [histogram.barDataArrays copy];
        _barGroups = [[NSArray alloc] initWithArray:histogram.barGroups copyItems:TRUE];
        _histogramStyle = histogram.histogramStyle;
        _legendArray = [[NSArray alloc] initWithArray:histogram.legendArray copyItems:TRUE];
        _legendPosition = histogram.legendPosition;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramData *copy = [[ISSChartHistogramData allocWithZone:zone] initWithHistogram:self];
    return copy;
}

#pragma mark - private methods
- (void)generateBarsWithGroupData
{
    NSMutableArray *barGroups = [[NSMutableArray alloc] init];
    NSInteger groupCount = [_barDataArrays count];
    NSInteger barCount = [_barDataArrays[0] count];
    for (NSInteger groupIndex = 0; groupIndex < groupCount; groupIndex++) {
        NSMutableArray *bars = [[NSMutableArray alloc] init];
        NSArray *groupData = _barDataArrays[groupIndex];
        for (NSInteger index = 0; index < barCount; index++) {
            ISSChartBar *bar = [[ISSChartBar alloc] init];
            ISSChartBarProperty *property = [[ISSChartBarProperty alloc] init];
            property.index = index;
            property.fillColor = [ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB];
            bar.valueY = [groupData[index] floatValue];
            bar.barProperty = property;
            [property release];
            [bars addObject:bar];
            [bar release];
        }
        ISSChartBarGroup *group = [[ISSChartBarGroup alloc] init];
        group.bars = bars;
        group.index = groupIndex;
        [bars release];
        [barGroups addObject:group];
        [group release];
    }
    self.barGroups = barGroups;
    [barGroups release];
}

- (void)generateBarColorsProperty
{
    if (_barColors && [_barColors count] &&
        _barGroups && [_barGroups count]) {        
        NSInteger index;
        for (ISSChartBarGroup *group in _barGroups) {
            index = 0;
            NSArray *bars = group.bars;
            NSAssert([_barColors count] == [bars count], @"the count of bar colos and count of bar in group must have the same size!");            
            for (ISSChartBar *bar in bars) {
                bar.barProperty.fillColor = _barColors[index];
                index++;                
            }
        }
    }
}

#pragma mark - public methods
- (ISSChartLegendDirection)getLegendDirection
{
    ISSChartLegendDirection direction = ISSChartLegendDirectionNone;
    switch (_legendPosition) {
        case ISSChartLegendPositionRight:
        case ISSChartLegendPositionLeft:
            direction = ISSChartLegendDirectionVertical;
            break;
        case ISSChartLegendPositionBottom:
        case ISSChartLegendPositionTop:
            direction = ISSChartLegendDirectionHorizontal;
            break;
        default:
            break;
    }
    return direction;
}

- (void)setXAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    [_coordinateSystem.xAxis setAxisItemsWithNames:names values:values];
}

- (void)setYAxisItemsWithNames:(NSArray*)names values:(NSArray*)values
{
    [_coordinateSystem.yAxis setAxisItemsWithNames:names values:values];
}

- (void)setBarDataArraysWithValues:(NSArray*)values1, ...NS_REQUIRES_NIL_TERMINATION
{
    NSInteger count = [values1 count];
    NSMutableArray *valuesArrays = [NSMutableArray array];
    id values;
    va_list argumentList;
    if (values1)                                // The first argument isn't part of the varargs list,
    {
        [valuesArrays addObject:values1];       // so we'll handle it separately.
        va_start(argumentList, values1);        // Start scanning for arguments after firstObject.
        while ((values = va_arg(argumentList, id))) { // As many times as we can get an argument of type "id"
            [valuesArrays addObject:values];        // that isn't nil, add it to array.
            NSAssert([values count] == count, @"all values must have the same size!");
        }
        va_end(argumentList);
    }
    NSInteger groupCount = count;
    NSInteger rawGroupCount = [valuesArrays count];
    NSMutableArray *groupDataArray = [NSMutableArray arrayWithCapacity:groupCount];    
    for(NSInteger group = 0; group < groupCount; group++) {
        [groupDataArray addObject:[NSMutableArray array]];
    }
    NSInteger group = 0;
    NSInteger index = 0;
    while(group < groupCount) {
        NSMutableArray *groupData = groupDataArray[group];
        for(NSInteger j = 0; j < rawGroupCount; j++) {
            [groupData addObject:valuesArrays[j][index]];
        }
        index++;
        group++;
    }
    [_barDataArrays release];
    _barDataArrays = nil;
    _barDataArrays = [groupDataArray retain];    
    [self generateBarsWithGroupData];
    [self generateBarColorsProperty];
}

- (void)setBarColors:(NSArray*)barColors
{
    RELEASE_SAFELY(_barColors);
    _barColors = [barColors retain];
    [self generateBarColorsProperty];
}

- (NSArray*)barColors
{
    if (!_barColors||![_barColors count]) {
        NSMutableArray *barColors = [[NSMutableArray alloc] init];
        ISSChartBarGroup *firstGroup = _barGroups[0];
        for (ISSChartBar *bar in firstGroup.bars) {
            [barColors addObject:bar.barProperty.fillColor];
        }
        _barColors = [barColors retain];
        [barColors release];
    }
    return _barColors;
}

- (NSArray*)bars
{
    NSMutableArray *bars = [NSMutableArray array];
    for (ISSChartBarGroup *group in _barGroups) {
        [bars addObjectsFromArray:group.bars];
    }
    return bars;
}

@end
