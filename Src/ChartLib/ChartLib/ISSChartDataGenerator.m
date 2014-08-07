//
//  ChartDataGenerator.m
//  ChartLib
//
//  Created by Sword Zhou on 6/19/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartDataGenerator.h"
#import "ISSChartPieData.h"
#import "ISSChartLineData.h"
#import "ISSChartHistogramData.h"
#import "ISSChartPieSection.h"
#import "ISSChartPieSectionProperty.h"
#import "ISSChartColorUtil.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartHistogramLineData.h"
#import "UIDevice+ITTAdditions.h"

#import "ISSChartWaterfallData.h"
#import "ISSChartWaterfallSymbolData.h"
#import "ISSChartHistogramOverlapData.h"
#import "ISSChartHistogramOverlapLineData.h"

#import "ISSChartHistogramStackData.H"
#import "ISSChartHistogramStackLineData.h"
#import "ISSChartDashboardData.h"
#import "ISSChartParserDataFactory.h"
#import "UIColor-Expanded.h"
#import "ISSChartParser.h"

@implementation ISSChartDataGenerator

- (ISSChartPieData*)pieData:(NSInteger)count
{
    CGFloat value;
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *legendArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        value = rand()%500;
        if (value < 30) {
            value += 100;
        }
        ISSChartPieSection *section = [[ISSChartPieSection alloc] init];
        section.value = value;
        ISSChartPieSectionProperty *property = [[ISSChartPieSectionProperty alloc] init];
        section.pieSectionProperty = property;
        property.fillColors = @[[UIColor randomColor], [UIColor randomColor]];
        [property release];
        [sections addObject:section];
        [section release];
        [legendArray addObject:[NSString stringWithFormat:@"Name %d", i]];
    }
    ISSChartPieData *pieData = [[ISSChartPieData alloc] init];
    pieData.radius = 170;
    pieData.innerRadius = 130;
    pieData.legendTextArray = legendArray;
    pieData.sections = sections;
	pieData.origin = CGPointMake(512, 300);
	pieData.displayFullHintMessage = TRUE;
    pieData.legendPosition = ISSChartLegendPositionTop;
    if (pieData.legendPosition == ISSChartLegendPositionRight) {
        pieData.coordinateSystem.rightMargin = 300;
    }
    else if (pieData.legendPosition == ISSChartLegendPositionLeft) {
        pieData.coordinateSystem.leftMargin = 200;
    }
    else if (pieData.legendPosition == ISSChartLegendPositionBottom) {
        pieData.coordinateSystem.bottomMargin = 200;
    }
	else {
        pieData.coordinateSystem.topMargin = 150;
	}
    return [pieData autorelease];
}

- (ISSChartPieData*)pieData
{
    return [self pieData:2];
}

- (ISSChartHistogramData*)histogramDataFromParser
{
	static BOOL histogramFlag = TRUE;
	NSString *path = nil;
	if (histogramFlag) {
		path = [[NSBundle mainBundle] pathForResource:@"histogramdata" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"histogramdata2" ofType:@"txt"];
	}
	histogramFlag = !histogramFlag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeHistogram];
	ISSChartHistogramData *histogramData = [parser chartDataWithJson:jsonString];
	return histogramData;
}

- (ISSChartHistogramData*)histogramData
{
    static NSInteger flag = 0;
    NSInteger segment = 6;
    NSString *value;
    ISSChartHistogramData *histogram = [[ISSChartHistogramData alloc] init];
//    histogram.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingDotted;
    histogram.coordinateSystem.xAxis.unit = @"时间";
    histogram.coordinateSystem.yAxis.unit = @"百万";
	histogram.legendPosition = ISSChartLegendPositionTop;
//    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500), @(600)];
//    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500", @"600"];
    NSInteger count = 50;
    NSMutableArray *xNames = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        if (i && 0 == i % segment) {
            [xNames addObject:[NSString stringWithFormat:@"%d月", i/segment]];
        }
        else {
            [xNames addObject:@""];
        }
    }
//    NSArray *xNames = @[@"", @"1月", @"", @"2月", @"", @"3月",@"",  @"4月", @"", @"5月", @"", @"6月", @"", @"7月", @"", @"8月", @"", @"9月", @"", @"10月", @"", @"11月", @"", @"12月"];//, @"", @"2月", @"", @"4月", @"", @"6月", @"", @"8月", @"", @"10月", @"", @"12"];
    static NSInteger firstHistogramValues[] = {-300, 120, 290, 300, 510, 400, 420, 392, 190, 90, 450, 195};
    static NSInteger secondHistogramValues[] = {-120, 20, 90, 100, 210, 300, 400, 192, 100, 10, 450, 195};
    static NSInteger thirdHistogramValues[] = {-220, 80, 90, 100, 210, 300, 230, 292, 300, 200, 150, 225};

    [histogram setXAxisItemsWithNames:xNames values:nil];
//    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogram.legendTextArray = @[@"流量统计"];//, @"光大银行"];
    if (ISSChartLegendPositionRight == histogram.legendPosition) {
        histogram.coordinateSystem.rightMargin = 100;
    }
    else if(ISSChartLegendPositionLeft  == histogram.legendPosition) {
        histogram.coordinateSystem.leftMargin = 120;
    }
    else if(ISSChartLegendPositionTop  == histogram.legendPosition) {
        histogram.coordinateSystem.topMargin = 150;
    }
//	histogram.coordinateSystem.yAxis.baseValue = 100;
//    histogram.coordinateSystem.xAxis.rotateAngle = -45;
    histogram.coordinateSystem.yAxis.baseValue = 0;
    NSInteger histogramCount = 1;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
	flag = 4;
    if (0 == flag) {
        for (NSInteger i = 0; i < histogramCount; i++) {
            NSMutableArray *histogramArray = [NSMutableArray array];
            for (NSInteger j = 0; j < count; j++) {
                [histogramArray addObject:@"0"];
            }
            [values addObject:histogramArray];
        }
    }
    else if(1 == flag){
        for (NSInteger i = 0; i < histogramCount; i++) {
            NSMutableArray *histogramArray = [NSMutableArray array];
            for (NSInteger j = 0; j < count; j++) {
                value = [NSString stringWithFormat:@"%d", rand()%500 + 1];
                [histogramArray addObject:value];
            }
            [values addObject:histogramArray];
        }
    }
    else if(2 == flag) {
        histogramCount = 3;
        count = 12;
        segment = 3;
        xNames = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i++) {
            if (0 == i % segment) {
                [xNames addObject:[NSString stringWithFormat:@"%d月", i/segment]];
            }
            else {
                [xNames addObject:@""];
            }
        }
        [histogram setXAxisItemsWithNames:xNames values:nil];
        
        histogram.legendTextArray = @[@"总行营业部", @"上海分行", @"天津分行"];
        for (NSInteger i = 0; i < histogramCount; i++) {
            NSMutableArray *histogramArray = [NSMutableArray array];
            for (NSInteger j = 0; j < count; j++) {
                if (0 == i) {
                    value = [NSString stringWithFormat:@"%d", firstHistogramValues[j]];
                }
                else {
                    value = @"0";
                }
                [histogramArray addObject:value];
            }
            [values addObject:histogramArray];
        }        
    }
    else if(3 == flag) {
        histogramCount = 3;
        count = 12;
        segment = 3;
        xNames = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i++) {
            if (0 == i % segment) {
                [xNames addObject:[NSString stringWithFormat:@"%d月", i/segment]];
            }
            else {
                [xNames addObject:@""];
            }
        }
        [histogram setXAxisItemsWithNames:xNames values:nil];
        
        histogram.legendTextArray = @[@"总行营业部", @"上海分行", @"天津分行"];
        for (NSInteger i = 0; i < histogramCount; i++) {
            NSMutableArray *histogramArray = [NSMutableArray array];
            for (NSInteger j = 0; j < count; j++) {
                if (0 == i) {
                    value = [NSString stringWithFormat:@"%d", firstHistogramValues[j]];
                }
                else if (1 == i) {
                    value = [NSString stringWithFormat:@"%d", secondHistogramValues[j]];
                }
                else {
                    value = @"";
                }
                [histogramArray addObject:value];
            }
            [values addObject:histogramArray];
        }
    }
    else if(4 == flag) {
        histogramCount = 2;
        count = 12;
        segment = 3;
        xNames = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i++) {
			[xNames addObject:[NSString stringWithFormat:@"%d月月月月月", i + 1]];
        }
        [histogram setXAxisItemsWithNames:xNames values:nil];
        
        histogram.legendTextArray = @[@"总行营业部", @"上海分行"];//, @"天津分行"];
        for (NSInteger i = 0; i < histogramCount; i++) {
            NSMutableArray *histogramArray = [NSMutableArray array];
            for (NSInteger j = 0; j < count; j++) {
                if (0 == i) {
                    value = [NSString stringWithFormat:@"%d", firstHistogramValues[j]];
                }
                else if (1 == i) {
                    value = [NSString stringWithFormat:@"%d", secondHistogramValues[j]];
                }
                else {
                    value = [NSString stringWithFormat:@"%d", thirdHistogramValues[j]];
                }
                value = [NSString stringWithFormat:@"%d", rand()%500 + 1];
                [histogramArray addObject:value];
            }
            [values addObject:histogramArray];
        }
    }
    [histogram setBarDataValues:values];
    flag = (flag + 1)%5;
    return [histogram autorelease];
}

- (ISSChartHistogramLineData*)histogramLineData
{
    static BOOL changed = FALSE;
    ISSChartHistogramLineData *histogramLineData = [[ISSChartHistogramLineData alloc] init];
    //    histogram.histogramStyle = ISSChartFillGradient;
    histogramLineData.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
	histogramLineData.coordinateSystem.yAxis.unit = @"万元";
	histogramLineData.coordinateSystem.viceYAxis.unit = @"万元";
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"100", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11), @(12)];
    NSArray *xNames = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    [histogramLineData setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramLineData.legendTextArray = @[@"流量统计", @"招商银行", @"光大银行"];
    histogramLineData.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramLineData.legendPosition) {
        histogramLineData.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramLineData.legendPosition) {
        histogramLineData.coordinateSystem.leftMargin = 120;
    }
    if (changed) {
        NSArray *lineValues = @[@[@(-180), @(200), @(-200), @(190), @(160), @(150), @(175), @(180), @(190), @(185), @(200), @(400)]
                                ];
        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        NSArray *barDatas = @[
                              @[@"120", @"-333", @"30", @"70", @"23", @"90", @"120", @"378", @"80", @"90", @"120", @"378"],
                              @[@"90", @"330", @"310", @"70", @"80", @"340", @"120", @"378", @"430", @"90", @"120", @"378"]
                              //         @[@"90", @"190", @"310", @"70", @"210", @"90", @"120", @"400", @"80", @"490", @"120", @"378"],
                              ];
        [histogramLineData setBarAndLineValues:barDatas lineValues:lineValues];
    }
    else {
        NSArray *lineValues = @[@[@(100), @(-120), @(333), @(234), @(240), @(370), @(450), @(120), @(80), @(140), @(90), @(120)]
                                ];
        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
        NSArray *barDatas = @[
                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
                              @[@"90", @"330", @"310", @"70", @"80", @"340", @"120", @"378", @"430", @"90", @"120", @"378"],
                              @[@"120", @"333", @"30", @"70", @"23", @"90", @"120", @"378", @"80", @"90", @"120", @"378"]                              
                              ];
        [histogramLineData setBarAndLineValues:barDatas lineValues:lineValues];
    }
    changed = !changed;
    return [histogramLineData autorelease];
}

- (ISSChartHistogramLineData*)histogramLineDataFromParser
{
	static BOOL histogralLineFlag = TRUE;
	NSString *path = nil;
	if (histogralLineFlag) {
		path = [[NSBundle mainBundle] pathForResource:@"histogramline" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"histogramline2" ofType:@"txt"];
	}
	histogralLineFlag = !histogralLineFlag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeHistogramLine];
	ISSChartHistogramLineData *histogramLineData = [parser chartDataWithJson:jsonString];
	return histogramLineData;
}

- (ISSChartLineData*)lineData
{
    static BOOL changed = FALSE;
    ISSChartLineData *lineData = [[ISSChartLineData alloc] init];
    lineData.coordinateSystem.xAxis.unit = @"时间";
    lineData.coordinateSystem.yAxis.unit = @"万元";
//    lineData.coordinateSystem.yAxis.axisProperty.axisStyle = kDashingDotted;
//    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
//    NSArray *yNames = @[@"100", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11), @(12)];
    //    NSArray *xNames = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    NSArray *xNames = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    [lineData setXAxisItemsWithNames:xNames values:xValues];
//    [lineData setYAxisItemsWithNames:yNames values:yValues];
    lineData.legendTextArray = @[@"XX银行", @"农业银行", @"建设银行", @"交通银行", @"农业银行"];
//    lineData.legendPosition = ISSChartLegendPositionRight;
    if (ISSChartLegendPositionRight == lineData.legendPosition) {
        lineData.coordinateSystem.rightMargin = 110;
    }
    else if (ISSChartLegendPositionLeft == lineData.legendPosition) {
        lineData.coordinateSystem.leftMargin = 140;
    }
    lineData.coordinateSystem.xAxis.rotateAngle = 30;
    lineData.coordinateSystem.yAxis.baseValue = 100;
    if (changed) {
        [lineData setValuesWithValues:
			@[@(100), @(120), @(333), @(234), @(240), @(370), @(450), @(120), @(80), @(140), @(90), @(120)],
			@[@(500), @(490), @(470), @(460), @(490), @(510), @(512), @(520), @(530), @(525), @(520), @(500)],
			@[@(300), @(490), @(400), @(300), @(290), @(500), @(510), @(490), @(500), @(490), @(430), @(495)],
			@[@(600), @(620), @(600), @(500), @(578), @(540), @(530), @(540), @(599), @(590), @(589), @(600)],
			@[@(400), @(430), @(400), @(500), @(350), @(450), @(300), @(500), @(600), @(400), @(190), @(375)],
         nil];
//        [lineData setValuesWithValues:
//			@[@(100), @(120), @(333)],
//			@[@(200), @(20), @(400)],
//         nil];
    }
    else {
        [lineData setValuesWithValues:
			@[@(100), @(120), @(333), @(234), @(240), @(370), @(450), @(120), @(80), @(13), @(90), @(120)],
			@[@(180), @(200), @(200), @(190), @(160), @(150), @(175), @(180), @(190), @(185), @(200), @(400)],
			@[@(-100), @(-220), @(400), @(300), @(290), @(500), @(510), @(490), @(500), @(490), @(430), @(495)],
			@[@(500), @(490), @(470), @(460), @(490), @(510), @(512), @(520), @(530), @(525), @(520), @(500)],
			@[@(280), @(300), @(300), @(290), @(260), @(150), @(275), @(280), @(300), @(287), @(398), @(309)],
         nil];
//        [lineData setValuesWithValues:
//		 @[@(200), @(220), @(100)],
//		 @[@(300), @(120), @(200)],
//         nil];
    }
    changed = !changed;
    return [lineData autorelease];
}

- (ISSChartWaterfallData *)waterfallData
{
    static BOOL waterfallChanged = FALSE;
    ISSChartWaterfallData *waterfallData = [[ISSChartWaterfallData alloc] init];
    
    //example 1
    if (waterfallChanged) {
        NSArray *xNames = @[@"利息收入",@"系统往来净收入",@"利息支出",@"净利息收入"];
        [waterfallData setXAxisItemsWithNames:xNames];
        [waterfallData setValues:@[@(500),@(300),@(-200),@(600)]];
    }
    else {
        NSArray *xNames = @[@"利息收入",@"系统往来净收入",@"利息支出",@"净利息收入"];
        [waterfallData setXAxisItemsWithNames:xNames];
        [waterfallData setValues:@[@(100),@(300),@(-50),@(350)]];
    }
    waterfallChanged = !waterfallChanged;
    return [waterfallData autorelease];
}

- (ISSChartHistogramOverlapData *)histogramOverlapData
{
    static BOOL changed = FALSE;
    ISSChartHistogramOverlapData *histogramOverlap = [[ISSChartHistogramOverlapData alloc] init];
    histogramOverlap.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    histogramOverlap.coordinateSystem.bottomMargin = 150;    
    histogramOverlap.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
    [histogramOverlap setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramOverlap.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
    histogramOverlap.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramOverlap.legendPosition) {
        histogramOverlap.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramOverlap.legendPosition) {
        histogramOverlap.coordinateSystem.leftMargin = 120;
    }
    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
    if (changed) {
//		[histogramOverlap setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        NSArray *barDatas = @[
                              @[@"1200", @"333", @"3000", @"7000", @"2300"],
                              @[@"90", @"3309", @"310", @"70", @"80"]
                              ];
        [histogramOverlap setBarDataValues:barDatas];
        
    }
    else {
//		[histogramOverlap setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
        NSArray *barDatas = @[
                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
                              @[@"5000", @"800", @"2000", @"4000", @"1300"],
                              @[@"190", @"2309", @"510", @"100", @"180"]
                              ];
        [histogramOverlap setBarDataValues:barDatas];
    }
    changed = !changed;
    return [histogramOverlap autorelease];
}

- (ISSChartHistogramOverlapData *)histogramOverlapDataFromParser
{
	static BOOL histogramOverlapFlag = TRUE;
	NSString *path = nil;
	if (histogramOverlapFlag) {
		path = [[NSBundle mainBundle] pathForResource:@"histogramoverlap" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"histogramoverlap2" ofType:@"txt"];
	}
	histogramOverlapFlag = !histogramOverlapFlag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeHistogramOverlap];
	ISSChartHistogramOverlapData *histogramOverlapData = [parser chartDataWithJson:jsonString];
	return histogramOverlapData;
}

- (ISSChartHistogramOverlapLineData *)histogramOverlapLineData
{
    static BOOL changed = FALSE;
    ISSChartHistogramOverlapLineData *histogramOverlap = [[ISSChartHistogramOverlapLineData alloc] init];
    //    histogram.histogramStyle = ISSHistogramGradient;
    histogramOverlap.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    histogramOverlap.coordinateSystem.bottomMargin = 150;
    
//    histogramOverlap.coordinateSystem.xAxis.rotateAngle = 270;
    histogramOverlap.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
    [histogramOverlap setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramOverlap.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
    histogramOverlap.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramOverlap.legendPosition) {
        histogramOverlap.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramOverlap.legendPosition) {
        histogramOverlap.coordinateSystem.leftMargin = 120;
    }
    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
    if (changed) {
        NSArray *lineValues = @[@[@(50), @(140), @(33), @(24), @(24)] ];
        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        NSArray *barDatas = @[
                              @[@"1200", @"333", @"3000", @"7500", @"2300"],
                              @[@"90", @"3309", @"310", @"70", @"80"]
                              ];
        [histogramOverlap setBarAndLineValues:barDatas lineValues:lineValues];
    }
    else {
        NSArray *lineValues = @[@[@(10), @(110), @(50), @(19), @(16)]];
        
        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
        NSArray *barDatas = @[
                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
                              @[@"90", @"3300", @"310", @"70", @"80"],
                              @[@"1200", @"333", @"3000", @"7500", @"2300"]
                              ];
        [histogramOverlap setBarAndLineValues:barDatas lineValues:lineValues];
    }
    changed = !changed;
    return [histogramOverlap autorelease];
}

- (ISSChartHistogramOverlapLineData *)histogramOverlapLineDataFromParser
{
	static BOOL histogramOverlapFlag = TRUE;
	NSString *path = nil;
	if (histogramOverlapFlag) {
		path = [[NSBundle mainBundle] pathForResource:@"histogramoverlapline" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"histogramoverlapline2" ofType:@"txt"];
	}
	histogramOverlapFlag = !histogramOverlapFlag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeHistogramOverlapLine];
	ISSChartHistogramOverlapLineData *histogramOverlapLineData = [parser chartDataWithJson:jsonString];
	return histogramOverlapLineData;
}

- (ISSChartHistogramStackData *)histogramStackData
{
    static BOOL changed = FALSE;
    ISSChartHistogramStackData *histogramStack = [[ISSChartHistogramStackData alloc] init];
    //    histogram.histogramStyle = ISSHistogramGradient;
    histogramStack.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    histogramStack.coordinateSystem.bottomMargin = 150;
    
    histogramStack.coordinateSystem.xAxis.rotateAngle = 270;
    histogramStack.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
    [histogramStack setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramStack.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
    histogramStack.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramStack.legendPosition) {
        histogramStack.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramStack.legendPosition) {
        histogramStack.coordinateSystem.leftMargin = 120;
    }
    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
    if (changed) {
        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        NSArray *barDatas = @[
                              @[@"1200", @"333", @"3000", @"7000", @"2300"],
                              @[@"90", @"3309", @"310", @"70", @"80"]
                              ];
        [histogramStack setBarValues:barDatas];
        
    }
    else {
        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
        NSArray *barDatas = @[
                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
                              @[@"90", @"3300", @"310", @"70", @"80"],
                              @[@"1200", @"333", @"3000", @"7000", @"2300"]
                              ];
        [histogramStack setBarValues:barDatas];
    }
    changed = !changed;
    return [histogramStack autorelease];
}

- (ISSChartHistogramStackLineData *)histogramStackLineData
{
    static BOOL changed = FALSE;
    ISSChartHistogramStackLineData *histogramStack = [[ISSChartHistogramStackLineData alloc] init];
    //    histogram.histogramStyle = ISSHistogramGradient;
    histogramStack.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    histogramStack.coordinateSystem.bottomMargin = 150;
    
    histogramStack.coordinateSystem.xAxis.rotateAngle = 270;
    histogramStack.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
    [histogramStack setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramStack.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
    histogramStack.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramStack.legendPosition) {
        histogramStack.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramStack.legendPosition) {
        histogramStack.coordinateSystem.leftMargin = 120;
    }
    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
    if (changed) {
        NSArray *lineValues = @[@[@(50), @(140), @(33), @(24), @(24)] ];
        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        NSArray *barDatas = @[
                              @[@"1200", @"3303", @"3000", @"7500", @"2300"],
                              @[@"900", @"3309", @"1110", @"7110", @"800"]
                              ];
        [histogramStack setBarAndLineValues:barDatas lineValues:lineValues];
    }
    else {
        NSArray *lineValues = @[@[@(10), @(110), @(50), @(19), @(16)]];
        
        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
        NSArray *barDatas = @[
                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
                              @[@"900", @"300", @"3110", @"70", @"80"],
                              @[@"1200", @"333", @"3000", @"7500", @"2300"]
                              ];
        [histogramStack setBarAndLineValues:barDatas lineValues:lineValues];
    }
    changed = !changed;
    return [histogramStack autorelease];
}

- (ISSChartPieData*)pieDataFromParser
{
	static BOOL pieFlag = TRUE;
	NSString *path = nil;
	if (pieFlag) {
		path = [[NSBundle mainBundle] pathForResource:@"piedata" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"piedata2" ofType:@"txt"];
	}
	pieFlag = !pieFlag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypePie];
	ISSChartPieData *pieData = [parser chartDataWithJson:jsonString];
	return pieData;
	
}

- (ISSChartLineData*)lineDataFromParser
{
	static BOOL flag = TRUE;
	NSString *path = nil;
	if (flag) {
		path = [[NSBundle mainBundle] pathForResource:@"linedata" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"linedata2" ofType:@"txt"];
	}
	flag = !flag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeLine];
	ISSChartLineData *lineData = [parser chartDataWithJson:jsonString];
	return lineData;
}

- (ISSChartDashboardData *)dashboardData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"dashboard" ofType:@"txt"];
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeDashboard];
	ISSChartDashboardData *dashboardData = [parser chartDataWithJson:jsonString];
	return dashboardData;
}

- (ISSChartDashboardData *)dashboardDataFromParser
{
	static BOOL dashboardFlag = TRUE;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"dashboard" ofType:@"txt"];
    if (!dashboardFlag) {
        path = [[NSBundle mainBundle] pathForResource:@"dashboard2" ofType:@"txt"];
    }
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [ISSChartParserDataFactory parserWithType:ISSChartTypeDashboard];
	ISSChartDashboardData *dashboardData = [parser chartDataWithJson:jsonString];
    dashboardFlag = !dashboardFlag;
	return dashboardData;
}

- (id)thumbnailChartDataWithType:(ISSChartType)chartType
{
	ISSChartBaseData *chartData = nil;
	switch (chartType) {
		case ISSChartTypePie:
			break;
		case ISSChartTypeHistogram:
			break;
		case ISSChartTypeLine:
			break;
		case ISSChartTypeHistogramLine:
			break;
		default:
			break;
	}
	return chartData;
}
@end
