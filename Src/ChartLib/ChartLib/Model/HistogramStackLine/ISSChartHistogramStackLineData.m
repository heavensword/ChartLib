//
//  ISSChartHistogramStackData.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackLineData.h"
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


@interface ISSChartHistogramStackLineData()

@property (nonatomic, retain) NSArray *barGroups;

@end

@implementation ISSChartHistogramStackLineData

- (void)dealloc
{
    [_barColors release];
    [_barGroups release];
    [_viceYAxis release];
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

- (id)initWithHistogramStackData:(ISSChartHistogramStackLineData*)histogramStackData
{
    self = [super init];
    if (self) {
		_legendFontSize = histogramStackData.legendFontSize;
        _coordinateSystem = [histogramStackData
                             .coordinateSystem copy];
        _barGroups = [[NSArray alloc] initWithArray:histogramStackData
                      .barGroups copyItems:TRUE];
        
        _legendTextArray = [histogramStackData.legendTextArray retain];
        _legends = [histogramStackData.legends retain];
        _legendPosition = histogramStackData.legendPosition;
        
        _graduationSpacing = histogramStackData.graduationSpacing;
        _graduationWidth = histogramStackData.graduationWidth;
        
        _lineColors = [histogramStackData.lineColors retain];
        _lines = [[NSArray alloc] initWithArray:histogramStackData.lines copyItems:TRUE];
        _lineDataArrays = [[NSArray alloc] initWithArray:histogramStackData.lineDataArrays copyItems:TRUE];
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartHistogramStackLineData *copy = [[ISSChartHistogramStackLineData allocWithZone:zone] initWithHistogramStackData:self];
    return copy;
}

#pragma mark - super methods
- (void)setup
{
    _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
}

#pragma mark - private methods
- (void)generateBarsWithGroupData:(NSArray*)barDataArrays
{
    NSMutableArray *barGroups = [[NSMutableArray alloc] init];
    NSInteger groupCount = [barDataArrays count];
    NSInteger barCount = [barDataArrays[0] count];
    for (NSInteger groupIndex = 0; groupIndex < groupCount; groupIndex++) {
        NSMutableArray *bars = [[NSMutableArray alloc] init];
        NSArray *groupData = barDataArrays[groupIndex];
        float stackValue =0;
        for (NSInteger index = 0; index < barCount; index++) {
            stackValue += [groupData[index] floatValue];
            ISSChartHistogramBar *bar = [[ISSChartHistogramBar alloc] init];
            ISSChartHistogramBarProperty *property = [[ISSChartHistogramBarProperty alloc] init];
            bar.index = index;
            property.fillColors = @[[ISSChartColorUtil colorWithType:index % NUMBER_OF_COLOR_IN_CHARTLIB] , [ISSChartColorUtil colorWithType:(index + 1) % NUMBER_OF_COLOR_IN_CHARTLIB]];
            bar.valueY = stackValue;
            bar.originValueY = [groupData[index] floatValue];
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
    ITTDINFO(@"_barColors:%@",_barColors);
    if (_barColors && [_barColors count] &&
        _barGroups && [_barGroups count]) {
        NSInteger index;
        for (ISSChartHistogramBarGroup *group in _barGroups) {
            index = 0;
            NSArray *bars = group.bars;
            NSAssert([_barColors count] == [bars count], @"the count of bar colos and count of bar in group must have the same size!");
            for (ISSChartHistogramBar *bar in bars) {
                index++;
            }
        }
    }
}

#pragma mark - public methods
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




- (void)setLineValues:(NSArray*)lineValues
{
    self.lineDataArrays = lineValues;
    [self generateLines];
    [self assignLineColors];
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
        [self generateBarsWithGroupData:groupDataArray];
        ITTDINFO(@"groupDataArray:%@",groupDataArray);
        [self generateBarColorsProperty];
    }
}

- (void)setBarAndLineValues:(NSArray*)barDataArrays lineValues:(NSArray*)lineDataArrays
{
    [self setBarDataValues:barDataArrays];
    [self setLineValues:lineDataArrays];
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

- (NSArray*)getBarGroupArray
{
    return self.barGroups;
}

- (NSInteger)getBarCountPerGroup
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
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
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
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
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
- (CGFloat)getMaxViceYValue
{
    CGFloat maxValue = 0;
    ITTDINFO(@"_lineDataArrays,%@,",_lineDataArrays);
    for (NSArray *lineDataArray in _lineDataArrays) {
        for (NSNumber *value in lineDataArray) {
            if ([value floatValue] > maxValue) {
                maxValue = [value floatValue];
            }
        }
    }
    return maxValue;
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
    UIColor *color;
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    
    for (NSArray *lineData in _lineDataArrays) {
        ISSChartLine *line = [[ISSChartLine alloc] init];
        line.lineIndex = index;
        line.values = lineData;
        ISSChartLineProperty *lineProperty = [[ISSChartLineProperty alloc] init];
        lineProperty.pointStyle = ISSChartLinePointJoinTriangle;
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
