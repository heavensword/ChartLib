//
//  ISSChartHistogramOverlapData.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartColorUtil.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartAxis.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartColorUtil.h"
#import "ISSChartHistogramOverlapLineLegend.h"
#import "ISSChartCoordinateSystem.h"


@interface ISSChartHistogramOverlapLineData()

@property (nonatomic, retain) NSArray *barGroupDatas;
@property (nonatomic, retain) NSArray *barGroups;
@property (nonatomic, retain) NSArray *barFillColors;
@property (nonatomic, retain) NSArray *barStrokColors;

@end

@implementation ISSChartHistogramOverlapLineData

- (void)dealloc
{
	[_barGroupDatas release];
	[_barStrokColors release];
	[_barFillColors release];
    [_barColors release];
    [_barGroups release];
    [_lineDataArrays release];
    [_lines release];
    [_lineColors release];    
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

- (id)initWithHistogramOverlapData:(ISSChartHistogramOverlapLineData*)histogramOverlapData
{
    self = [super init];
    if (self) {
		_barGroupDatas = [histogramOverlapData.barGroupDatas retain];
		_barFillColors = [histogramOverlapData.barFillColors retain];
		_barStrokColors = [histogramOverlapData.barStrokColors retain];
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
        
        _lineColors = [histogramOverlapData.lineColors retain];
        _lines = [[NSArray alloc] initWithArray:histogramOverlapData.lines copyItems:TRUE];
        _lineDataArrays = [[NSArray alloc] initWithArray:histogramOverlapData.lineDataArrays copyItems:TRUE];
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramOverlapLineData *copy = [[ISSChartHistogramOverlapLineData allocWithZone:zone] initWithHistogramOverlapData:self];
    return copy;
}

#pragma mark - super methods
- (void)setup
{
    _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
}

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
            property.fillColors = @[[ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB], [ISSChartColorUtil colorWithType:(index + 1) % NUMBER_OF_COLOR_IN_CHARTLIB]];
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
    [self tryToGenerateYAxis];
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

- (void)setBarColors:(NSArray*)barColors
{
    RELEASE_SAFELY(_barColors);
    _barColors = [barColors retain];
    [self generateBarColorsProperty];
}

- (NSArray*)getBarColors
{
    if (!_barColors||![_barColors count]) {
        NSMutableArray *barColors = [[NSMutableArray alloc] init];
        ISSChartHistogramBarGroup *firstGroup = _barGroups[0];
        for (ISSChartHistogramBar *bar in firstGroup.bars) {
            [barColors addObject:bar.barProperty.fillColor];
        }
        _barColors = [barColors retain];
        [barColors release];
    }
    return _barColors;
}

- (NSArray*)barGroups
{
    return _barGroups;
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
            NSArray *barColors = [self getBarColors];
            NSInteger barCount = [barColors count];
//            NSInteger actuallyLegendCount = barCount + [_lines count];
//            NSAssert(actuallyLegendCount == legendCount, @"invalid legend size");
            NSInteger index = 0;
            for (NSInteger i = 0; i < barCount && index < legendCount; i++) {
                ISSChartHistogramOverlapLineLegend *legend = [[ISSChartHistogramOverlapLineLegend alloc] init];
                legend.name = self.legendTextArray[index];
                legend.fillColor = barColors[i];
                legend.type = ISSChartLegendHistogram;
                [_legends addObject:legend];
                [legend release];
                index++;
            }
            NSInteger lineCount = [_lines count];
            for (NSInteger i = 0; i < lineCount && index < legendCount; i++) {
                ISSChartLine *line = _lines[i];
                ISSChartHistogramOverlapLineLegend *legend = [[ISSChartHistogramOverlapLineLegend alloc] init];
                legend.name = self.legendTextArray[index];
                legend.fillColor = line.lineProperty.strokeColor;
                legend.type = ISSChartLegendLine;
                legend.parent = line.lineProperty;
                legend.size = [self getLegendJoinSize:legend index:i];
                [_legends addObject:legend];
                [legend release];
                index++;
            }
        }
    }
    return _legends;
}

#pragma mark - super methods


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
    UIColor *color;
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    
    for (NSArray *lineData in _lineDataArrays) {
        ISSChartLine *line = [[ISSChartLine alloc] init];
        line.lineIndex = index;
        line.values = lineData;
        ISSChartLineProperty *lineProperty = [[ISSChartLineProperty alloc] init];
        lineProperty.pointStyle = ISSChartLinePointJoinCircle;
		lineProperty.radius = 10.0;
        color = [ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB];
        lineProperty.strokeColor = color;
        line.lineProperty = lineProperty;
        [lineProperty release];
        [lines addObject:line];
        [line release];
        index++;
    }
    RELEASE_SAFELY(_lines);
    self.lines = lines;
    [lines release];
}

#pragma mark - override parent method
- (void)tryToGenerateYAxis
{
    if (!_coordinateSystem.yAxis.axisItems||
        ![_coordinateSystem.yAxis.axisItems count]) {
        [self generateYAxis];
        [self generateViceYAxis];
    }
}

- (void)generateViceYAxis
{
    CGFloat graduation;
    CGFloat value = 0;
    CGFloat maxValue = [self getMaxViceYValue];
    ITTDINFO(@"getMaxViceYValue:%f",maxValue);
    NSInteger gridCount = [_coordinateSystem.yAxis.axisItems count]-1;
    
    NSString *name;
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    graduation = maxValue/gridCount;
    NSInteger bitCount = [self getBitCountBase2:graduation];
    CGFloat graduationUnit = pow(2, bitCount);
    
    ITTDINFO(@"gridCount:%d graduationUnit:%f graduation:%f",gridCount,graduationUnit,graduation);
    
    if (fabs(graduationUnit/2 - graduation) < fabs(graduationUnit - graduation)) {
        
        graduation = graduationUnit/2;
        if (graduation * gridCount <= maxValue) {
            graduation = graduationUnit;
        }
    }
    else {
       graduation = graduationUnit;

    }
    
    if (graduation*gridCount < 100) {
        graduation = 100.0/gridCount;
    }
    
    NSInteger count = 0;
    ITTDINFO(@"graduation:%f",graduation);
    while (count <= gridCount) {

        [values addObject:@(value)];

        name = [self getAxisGraduationName:value percentage:value axisType:_coordinateSystem.viceYAxis.axisType];
        [names addObject:name];

        value += graduation;

//        name = [self getAxisGraduationName:value percentage:(count*1.0)/gridCount axisType:_coordinateSystem.viceYAxis.axisType];
        
//        value = (count*1.0)/gridCount;

        count++;
    }
    [self setViceYAxisItemsWithNames:names values:values];
    ITTDINFO(@"ViceYAxist Items:name:%@,values:%@",names,values);
    RELEASE_SAFELY(names);
    RELEASE_SAFELY(values);
}

- (NSString*)getAxisGraduationName:(CGFloat)value percentage:(CGFloat)percentage axisType:(ISSChartAxisType)axisType
{

    NSString *name = @"";
    switch (axisType) {
        case ISSChartAxisTypeValue:
            name = [NSString stringWithFormat:@"%.0f", value];
            break;
        case ISSChartAxisTypePercentage:
            name = [NSString stringWithFormat:@"%.0f%%", percentage];
            break;
        default:
            break;
    }
    return name;
}

- (NSInteger)getBitCount:(CGFloat)value
{
    NSInteger bitCount = 1;
    NSInteger integerValue = value;
    while (integerValue/10) {
        integerValue = integerValue/10;
        bitCount++;
    }
    return bitCount;
}

- (NSInteger)getBitCountBase2:(CGFloat)value
{
    NSInteger bitCount = 1;
    NSInteger integerValue = value;
    while (integerValue/2) {
        integerValue = integerValue/2;
        bitCount++;
    }
    return bitCount;
}
@end
