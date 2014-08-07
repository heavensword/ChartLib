//
//  ISSChartHistogramLineData.m
//  ChartLib
//
//  Created by Sword Zhou on 6/29/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartColorUtil.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartAxis.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartColorUtil.h"
#import "ISSChartLegend.h"
#import "ISSChartCoordinateSystem.h"

@interface ISSChartHistogramLineData()

@property (nonatomic, retain) NSArray *barGroups;
@property (nonatomic, retain) NSArray *barGroupDatas;
@property (nonatomic, retain) NSArray *barFillColors;
@property (nonatomic, retain) NSArray *barStrokColors;

@end

@implementation ISSChartHistogramLineData

- (void)dealloc
{
	[_barFillColors release];
	[_barStrokColors release];
	[_barGroupDatas release];
	[_lineDataArrays release];
	[_lines release];
	[_lineColors release];
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

- (id)initWithHistogramLineData:(ISSChartHistogramLineData*)histogramLineData
{
    self = [super init];
    if (self) {
		_legendFontSize = histogramLineData.legendFontSize;
        _coordinateSystem = [histogramLineData.coordinateSystem copy];
        _barGroups = [[NSArray alloc] initWithArray:histogramLineData.barGroups copyItems:TRUE];
        _barGroupDatas = [histogramLineData.barGroupDatas retain];
		_barStrokColors = [histogramLineData.barStrokColors retain];
		_barFillColors = [histogramLineData.barFillColors retain];
		
        _histogramStyle = histogramLineData.histogramStyle;
        _legendTextArray = [histogramLineData.legendTextArray retain];
        _legends = [histogramLineData.legends retain];
        _legendPosition = histogramLineData.legendPosition;
        
        _graduationSpacing = histogramLineData.graduationSpacing;
        _graduationWidth = histogramLineData.graduationWidth;

        _lineColors = [histogramLineData.lineColors retain];        
        _lines = [[NSArray alloc] initWithArray:histogramLineData.lines copyItems:TRUE];
        _lineDataArrays = [[NSArray alloc] initWithArray:histogramLineData.lineDataArrays copyItems:TRUE];
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramLineData *copy = [[ISSChartHistogramLineData allocWithZone:zone] initWithHistogramLineData:self];
    return copy;
}

#pragma mark - super methods
- (void)setup
{
    _histogramStyle = ISSChartFillPlain;
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
			bar.name = _legendTextArray[index];
            property.fillColors = @[[ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB], [ISSChartColorUtil colorWithType:(index + 1) % NUMBER_OF_COLOR_IN_CHARTLIB]];
            bar.valueY = [groupData[index] floatValue];
            bar.barProperty = property;
			bar.groupIndex = groupIndex;
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

#pragma mark - super methods
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

- (CGFloat)getMaxViceYValue
{
    CGFloat maxValue = 0;
    for (NSArray *lineDataArray in _lineDataArrays) {
        for (NSNumber *value in lineDataArray) {
            if ([value floatValue] > maxValue) {
                maxValue = [value floatValue];
            }
        }
    }
    return maxValue;
}

- (CGFloat)getMinViceYValue
{
    CGFloat minValue = CGFLOAT_MAX;
    for (NSArray *lineDataArray in _lineDataArrays) {
        for (NSNumber *value in lineDataArray) {
            if ([value floatValue] < minValue) {
                minValue = [value floatValue];
            }
        }
    }
    return minValue;
}

#pragma mark - public methods
- (void)setLineValues:(NSArray*)lineValues
{
    self.lineDataArrays = lineValues;
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

- (void)setBarAndLineValues:(NSArray*)barDataArrays lineValues:(NSArray*)lineDataArrays
{
    [self setBarDataValues:barDataArrays];
    [self setLineValues:lineDataArrays];
}

- (void)readyData
{
	[self generateBars];
	[self generateBarColorsProperty];
    [self generateLines];
    [self assignLineColors];
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
    [self setBarAndLineValues:valuesArrays lineValues:nil];
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

- (NSArray*)barGroups
{
    return _barGroups;
}

- (ISSChartAxisItem*)getXAxisItemWithBar:(ISSChartHistogramBar*)bar
{
    return [self xAxisItemAtIndex:bar.groupIndex];
}

- (ISSChartLine*)findSelectedLineWithLocation:(CGPoint)location
{
    ISSChartLine *foundLine = nil;
    NSArray *lines = _lines;
    for (ISSChartLine *line in lines) {
        if ([line isPointOnLine:location]) {
            foundLine = line;
            break;
        }
    }
    return foundLine;
}

- (ISSChartLine*)findSelectedLineWithBar:(ISSChartHistogramBar*)bar
{
	NSInteger groupIndex = bar.groupIndex;
	ISSChartHistogramBarGroup *barGroup = self.barGroups[groupIndex];
	ISSChartHistogramBar *firstBar = [barGroup.bars firstObject];
	ISSChartHistogramBar *lastBar = [barGroup.bars lastObject];
	CGRect firstBarRect = firstBar.barProperty.frame;
	CGRect lastBarRect = lastBar.barProperty.frame;
	CGPoint location = CGPointMake((CGRectGetMinX(firstBarRect) + CGRectGetMaxX(lastBarRect))/2, CGRectGetMidY(firstBarRect));
	return [self findSelectedLineWithLocation:location];
}

- (NSInteger)barCountOfPerGroup
{
    ISSChartHistogramBarGroup *group = _barGroups[0];
    return [group.bars count];
}

- (CGSize)getLegendJoinSize:(ISSChartLegend*)legend index:(NSInteger)index
{
    ISSChartLine *line =  _lines[index];
    ISSChartLineProperty *lineProperty = line.lineProperty;
    CGSize newSize = legend.size;
    newSize.width = lineProperty.radius * 4;
    return newSize;
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
//            NSAssert(actuallyLegendCount == legendCount, @"invalid legend count!");			
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
            NSInteger lineCount = [_lines count];
            for (NSInteger i = 0; i < lineCount && index < legendCount; i++) {
                ISSChartLine *line = _lines[i];
				line.name = self.legendTextArray[index];
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
                legend.fillColor = line.lineProperty.strokeColor;
                legend.type = ISSChartLegendLine;
                legend.parent = line.lineProperty;
                legend.size = [self getLegendJoinSize:legend index:i];
				legend.name = self.legendTextArray[index];
                [_legends addObject:legend];
                [legend release];
                index++;
            }
        }
    }
    return _legends;
}

#pragma mark - private methods
- (void)assignLineColors
{
    if (_lineColors && [_lineColors count] &&
        _lines && [_lines count]) {
        NSInteger index = 0;
        for (ISSChartLine *line in _lines) {
            line.lineProperty.strokeColor = _lineColors[index];
            index++;
        }
    }
}

- (void)generateLines
{
	if (!_lines) {
		UIColor *color;
		NSMutableArray *lines = [[NSMutableArray alloc] init];
		NSInteger index = 0;
		NSInteger legendIndex = [_legendTextArray count] - [_lineDataArrays count];
		for (NSArray *lineData in _lineDataArrays) {
			ISSChartLine *line = [[ISSChartLine alloc] init];
			line.lineIndex = index;
			line.values = lineData;
			ISSChartLineProperty *lineProperty = [[ISSChartLineProperty alloc] init];
			color = [ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB];
			lineProperty.strokeColor = color;
			line.lineProperty = lineProperty;
			line.name = _legendTextArray[legendIndex];
			[lineProperty release];
			[lines addObject:line];
			[line release];
			index++;
			legendIndex++;
		}
		RELEASE_SAFELY(_lines);
		self.lines = lines;
		[lines release];
	}
}

@end
