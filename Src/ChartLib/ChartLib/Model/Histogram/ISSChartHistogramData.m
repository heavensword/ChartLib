//
//  ISSHistogram.m
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramData.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartAxis.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartColorUtil.h"
#import "ISSChartLegend.h"
#import "ISSChartCoordinateSystem.h"
#import "UIColor-Expanded.h"

@interface ISSChartHistogramData()
{
}

@property (nonatomic, retain) NSArray *barGroupDatas;
@property (nonatomic, retain) NSArray *barGroups;
@property (nonatomic, retain) NSArray *barFillColors;
@property (nonatomic, retain) NSArray *barStrokColors;

@end

@implementation ISSChartHistogramData

- (NSDictionary*)attributeMapDictionary
{
    return @{@"bars":@"bars", @"properties":@"properties", @"higtogramStyle":@"higtogramStyle"};
}

- (void)dealloc
{
	[_barGroupDatas release];
	[_barStrokColors release];
    [_barFillColors release];
    [_barGroups release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithHistogram:(ISSChartHistogramData*)histogram
{
    self = [super init];
    if (self) {
		_legendFontSize = histogram.legendFontSize;
        _needDrawSelectedForehead = histogram.needDrawSelectedForehead;
        _coordinateSystem = [histogram.coordinateSystem copy];
        _barGroups = [[NSArray alloc] initWithArray:histogram.barGroups copyItems:TRUE];
        _legendTextArray = [histogram.legendTextArray retain];
        _legends = [histogram.legends retain];
        _legendPosition = histogram.legendPosition;
		_barStrokColors = [histogram.barStrokColors retain];
		_barFillColors = [histogram.barFillColors retain];
		_barGroupDatas = [histogram.barGroupDatas retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramData *copy = [[ISSChartHistogramData allocWithZone:zone] initWithHistogram:self];
    return copy;
}

#pragma mark - super methods
- (void)setup
{
    _needDrawSelectedForehead = FALSE;
    _histogramStyle = ISSChartFillPlain;
    _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
}

#pragma mark - private methods
- (void)generateBars
{
    NSMutableArray *barGroups = [[NSMutableArray alloc] init];
    NSInteger groupCount = [self.barGroupDatas count];
    NSInteger barCount = [self.self.barGroupDatas[0] count];
    for (NSInteger groupIndex = 0; groupIndex < groupCount; groupIndex++) {
        NSMutableArray *bars = [[NSMutableArray alloc] init];
        NSArray *groupData = self.barGroupDatas[groupIndex];
        for (NSInteger index = 0; index < barCount; index++) {
            ISSChartHistogramBar *bar = [[ISSChartHistogramBar alloc] init];
            ISSChartHistogramBarProperty *property = [[ISSChartHistogramBarProperty alloc] init];
            bar.index = index;
            bar.groupIndex = groupIndex;
            property.needDrawSelectedForehead = _needDrawSelectedForehead;                        
            bar.valueY = [groupData[index] floatValue];
            bar.barProperty = property;
            [property release];
            [bars addObject:bar];
            [bar release];
        }
        ISSChartHistogramBarGroup *group = [[ISSChartHistogramBarGroup alloc] init];
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
	//set bar fill color
    if (_barFillColors && [_barFillColors count] &&
        _barGroups && [_barGroups count]) {        
        NSInteger index;
        for (ISSChartHistogramBarGroup *group in _barGroups) {
            index = 0;
            NSArray *bars = group.bars;
            NSAssert([_barFillColors count] == [bars count], @"the count of bar colos and count of bar in group must have the same size!");
            for (ISSChartHistogramBar *bar in bars) {
				bar.barProperty.fillColors = _barFillColors[index];
                index++;                
            }
        }
    }
	//set stroke color
    if (_barStrokColors && [_barStrokColors count] &&
        _barGroups && [_barGroups count]) {
        NSInteger index;
        for (ISSChartHistogramBarGroup *group in _barGroups) {
            index = 0;
            NSArray *bars = group.bars;
            NSAssert([_barFillColors count] == [bars count], @"the count of bar colos and count of bar in group must have the same size!");
            for (ISSChartHistogramBar *bar in bars) {
				bar.barProperty.strokeColor = _barStrokColors[index];
                index++;
            }
        }
    }
}

#pragma mark - public methods
- (CGFloat)getMinYValue
{
    CGFloat minValue = CGFLOAT_MAX;
    for (ISSChartHistogramBarGroup *group in _barGroups) {
        for (ISSChartHistogramBar *bar in group.bars) {
            if (bar.valueY < minValue) {
                minValue = bar.valueY;
            }
        }
    }
    return minValue;
}

- (CGFloat)getMaxYValue
{
    CGFloat maxValue = 0;
    for (ISSChartHistogramBarGroup *group in _barGroups) {
        for (ISSChartHistogramBar *bar in group.bars) {
            if (bar.valueY > maxValue) {
                maxValue = bar.valueY;
            }
        }
    }
    return maxValue;
}

- (void)setBarDataValues:(NSArray*)valuesArray
{
    if (valuesArray && [valuesArray count]) {
        NSInteger count = [valuesArray[0] count];
        NSInteger groupCount = count;
        NSInteger rawGroupCount = [valuesArray count];
        NSMutableArray *groupDataArray = [NSMutableArray arrayWithCapacity:groupCount];
        for(NSInteger group = 0; group < groupCount; group++) {
            [groupDataArray addObject:[NSMutableArray array]];
        }
        NSInteger group = 0;
        NSInteger index = 0;
        while(group < groupCount) {
            NSMutableArray *groupData = groupDataArray[group];
            for(NSInteger j = 0; j < rawGroupCount; j++) {
                [groupData addObject:valuesArray[j][index]];
            }
            index++;
            group++;
        }
		self.barGroupDatas = groupDataArray;
    }
}

- (void)readyData
{
	[self generateBars];
	[self generateBarColorsProperty];
	[self tryToGenerateYAxis];
}

- (void)setBarDataArraysWithValues:(NSArray*)values1, ...NS_REQUIRES_NIL_TERMINATION
{
//    NSInteger count = [values1 count];
    NSMutableArray *valuesArrays = [NSMutableArray array];
    id values;
    va_list argumentList;
    if (values1) {                               // The first argument isn't part of the varargs list,    
        [valuesArrays addObject:values1];       // so we'll handle it separately.
        va_start(argumentList, values1);        // Start scanning for arguments after firstObject.
        while ((values = va_arg(argumentList, id))) { // As many times as we can get an argument of type "id"
            [valuesArrays addObject:values];        // that isn't nil, add it to array.
//            NSAssert([values count] == count, @"all values must have the same size!");
        }
        va_end(argumentList);
    }
    [self setBarDataValues:valuesArrays];
}

- (NSArray*)legendColors
{
	NSMutableArray *legendColors = [NSMutableArray array];
	ISSChartHistogramBarGroup *firstGroup = _barGroups[0];
//	NSAssert(([firstGroup.bars count] == [_legendTextArray count]), @"the count of bar in group must equal to the count of legend!");
	for (ISSChartHistogramBar *bar in firstGroup.bars) {
		[legendColors addObject:bar.barProperty.fillColor];
	}
    return legendColors;
}

- (ISSChartAxisItem*)getXAxisItemWithBar:(ISSChartHistogramBar*)bar
{
    return [self xAxisItemAtIndex:bar.groupIndex];
}

- (NSArray*)barGroups
{
    return _barGroups;
}

- (NSInteger)barCountOfPerGroup
{
    ISSChartHistogramBarGroup *group = _barGroups[0];
    return [group.bars count];
}

- (NSMutableArray*)legends
{
    if (!_legends) {
        NSInteger count = [self.legendTextArray count];
        if (count) {
            _legends = [[NSMutableArray alloc] initWithCapacity:count];
            NSArray *legendColors = [self legendColors];
            for (NSInteger i = 0; i < count; i++) {
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
                legend.name = self.legendTextArray[i];
                legend.fillColor = legendColors[i];
                legend.type = ISSChartLegendHistogram;
                [_legends addObject:legend];
                [legend release];
            }            
        }
    }
    return _legends;
}

- (void)adjustDataToZeroState
{
    NSInteger groupCount = [[self barGroups] count];
    for (NSInteger group = 0; group < groupCount; group++) {
        ISSChartHistogramBarGroup *barGroup = [self barGroups][group];
        for (ISSChartHistogramBar *bar in barGroup.bars) {
			bar.valueY = self.coordinateSystem.yAxis.baseValue;
		}
	}
}
@end
