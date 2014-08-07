//
//  ISSChartHistogramOverlapData.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartColorUtil.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartAxis.h"
#import "ISSChartColorUtil.h"
#import "ISSChartLegend.h"
#import "ISSChartCoordinateSystem.h"

@interface ISSChartHistogramOverlapData()

@property (nonatomic, retain) NSArray *barGroupDatas;
@property (nonatomic, retain) NSArray *barGroups;
@property (nonatomic, retain) NSArray *barFillColors;
@property (nonatomic, retain) NSArray *barStrokColors;

@end

@implementation ISSChartHistogramOverlapData

- (void)dealloc
{
	[_barGroupDatas release];
	[_barFillColors release];
	[_barStrokColors release];
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

- (id)initWithHistogramOverlapData:(ISSChartHistogramOverlapData*)histogramOverlapData
{
    self = [super init];
    if (self) {
		_barGroupDatas = [histogramOverlapData.barGroupDatas retain];
		_barStrokColors = [histogramOverlapData.barStrokColors retain];
		_barFillColors = [histogramOverlapData.barFillColors retain];
		_legendFontSize = histogramOverlapData.legendFontSize;
        _coordinateSystem = [histogramOverlapData
                             .coordinateSystem copy];
        _barGroups = [[NSArray alloc] initWithArray:histogramOverlapData
                      .barGroups copyItems:TRUE];
        
        _legendTextArray = [histogramOverlapData.legendTextArray retain];
        _legends = [histogramOverlapData.legends retain];
        _legendPosition = histogramOverlapData.legendPosition;
        
        _graduationSpacing = histogramOverlapData.graduationSpacing;
        _graduationWidth = histogramOverlapData.graduationWidth;
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramOverlapData *copy = [[ISSChartHistogramOverlapData allocWithZone:zone] initWithHistogramOverlapData:self];
    return copy;
}

#pragma mark - super methods
- (void)setup
{
    _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
}

#pragma mark - private methods
- (void)generateBars
{
    NSMutableArray *barGroups = [[NSMutableArray alloc] init];
    NSInteger groupCount = [self.barGroupDatas count];
    NSInteger barCount = [self.barGroupDatas[0] count];
    for (NSInteger groupIndex = 0; groupIndex < groupCount; groupIndex++) {
        NSMutableArray *bars = [[NSMutableArray alloc] init];
        NSArray *groupData = self.barGroupDatas[groupIndex];
        for (NSInteger index = 0; index < barCount; index++) {
            ISSChartHistogramBar *bar = [[ISSChartHistogramBar alloc] init];
            ISSChartHistogramBarProperty *property = [[ISSChartHistogramBarProperty alloc] init];
            bar.index = index;
			bar.groupIndex = groupIndex;
//            property.fillColors = @[[ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB], [ISSChartColorUtil colorWithType:(index + 1) % NUMBER_OF_COLOR_IN_CHARTLIB]];
			property.fillColors = @[[ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB]];
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
//    NSInteger barCount = [values1 count];
//	ITTDINFO(@"barCount %d", barCount);
    NSMutableArray *valuesArrays = [NSMutableArray array];
    id values;
    va_list argumentList;
    if (values1) {                               // The first argument isn't part of the varargs list,
        [valuesArrays addObject:values1];       // so we'll handle it separately.
        va_start(argumentList, values1);        // Start scanning for arguments after firstObject.
        while ((values = va_arg(argumentList, id))) { // As many times as we can get an argument of type "id"
            [valuesArrays addObject:values];        // that isn't nil, add it to array.
//            NSAssert([values count] == barCount, @"all values must have the same size!");
        }
        va_end(argumentList);
    }
    [self setBarDataValues:valuesArrays];
}

- (NSArray*)legendColors
{
	NSMutableArray *legendColors = [NSMutableArray array];
	ISSChartHistogramBarGroup *firstGroup = _barGroups[0];
	for (ISSChartHistogramBar *bar in firstGroup.bars) {
		[legendColors addObject:bar.barProperty.fillColor];
	}
    return legendColors;
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
        NSInteger legendCount = [self.legendTextArray count];
        if (legendCount) {
            _legends = [[NSMutableArray alloc] initWithCapacity:legendCount];
            NSArray *legendColors = [self legendColors];
            NSInteger barCount = [legendColors count];
//            NSInteger actuallyLegendCount = barCount + [_lines count];
//            NSAssert(actuallyLegendCount == legendCount, @"invalid legend size");
            NSInteger index = 0;
            for (NSInteger i = 0; i < barCount && index < legendCount; i++) {
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
                legend.name = self.legendTextArray[index];
                legend.fillColor = legendColors[i];
                legend.type = ISSChartLegendHistogram;
                [_legends addObject:legend];
                [legend release];
                index++;
            }
        }
    }
    return _legends;
}

#pragma mark - super methods
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

#pragma mark - private methods

@end
