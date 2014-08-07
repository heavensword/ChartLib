//
//  ISSChartHistogramOverlayDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlayFactory.h"
#import "ISSChartHistogramOverlapData.h"
#import "ISSChartHistogramOverlapView.h"
#import "ISSChartHistogramOverlapDataParser.h"

@implementation ISSChartHistogramOverlayFactory

//- (id)thumbnailChartData
//{
//    static BOOL changed = FALSE;
//    ISSChartHistogramOverlapData *histogramOverlapData = [[ISSChartHistogramOverlapData alloc] init];
//    //    histogram.histogramStyle = ISSHistogramGradient;
//    histogramOverlapData.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
//    histogramOverlapData.coordinateSystem.bottomMargin = 150;
//    
//    histogramOverlapData.coordinateSystem.xAxis.rotateAngle = 270;
//    histogramOverlapData.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
//    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
//    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
//    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
//    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
//    [histogramOverlapData setXAxisItemsWithNames:xNames values:xValues];
//    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
//    histogramOverlapData.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
//    histogramOverlapData.legendPosition = ISSChartLegendPositionBottom;
//    if (ISSChartLegendPositionRight == histogramOverlapData.legendPosition) {
//        histogramOverlapData.coordinateSystem.rightMargin = 140;
//    }
//    else if(ISSChartLegendPositionLeft  == histogramOverlapData.legendPosition) {
//        histogramOverlapData.coordinateSystem.leftMargin = 120;
//    }
//    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
//    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
//    if (changed) {
//        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
//        NSArray *barDatas = @[
//                              @[@"1200", @"333", @"3000", @"7000", @"2300"],
//                              @[@"90", @"3309", @"310", @"70", @"80"]
//                              ];
//        [histogramOverlapData setBarDataValues:barDatas];
//        
//    }
//    else {
//        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
//        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
//        NSArray *barDatas = @[
//                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
//                              @[@"90", @"3300", @"310", @"70", @"80"],
//                              @[@"1200", @"333", @"3000", @"7000", @"2300"]
//                              ];
//        [histogramOverlapData setBarDataValues:barDatas];
//    }
//    changed = !changed;
//	
//	//adjust for thumbnail chart view
//	histogramOverlapData.legendPosition = ISSChartLegendPositionBottom;
//	ISSChartCoordinateSystem *coordinateSystemm = histogramOverlapData.coordinateSystem;
//	if (coordinateSystemm.xAxis.rotateAngle == 270) {
//		coordinateSystemm.bottomMargin = 60;
//	}else{
//		coordinateSystemm.bottomMargin = 36;
//	}
//	coordinateSystemm.leftMargin = 40;
//	coordinateSystemm.topMargin = 29;
//	coordinateSystemm.rightMargin = 40;
//	coordinateSystemm.bottomMargin = 50;
//	//        coordinateSystemm.xAxis.rotateAngle = 310;
//	coordinateSystemm.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//	coordinateSystemm.viceYAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//	coordinateSystemm.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//	coordinateSystemm.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
//	[histogramOverlapData ajustLengendSize:CGSizeMake(15, 15)];
//	
//    return [histogramOverlapData autorelease];
//	
//}

- (id)thumbnailChartData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"histogramoverlap" ofType:@"txt"];;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [[ISSChartHistogramOverlapDataParser alloc] init];
	ISSChartHistogramOverlapData *histogramOverlapData = [parser chartDataWithJson:jsonString];
	[parser release];
	
	//adjust data for thnmbnail chart view
	ISSChartCoordinateSystem *coordinateSystemm = histogramOverlapData.coordinateSystem;
	coordinateSystemm.leftMargin = 40;
	coordinateSystemm.topMargin = 24;
	coordinateSystemm.bottomMargin = 50;
	coordinateSystemm.rightMargin = 33;
	coordinateSystemm.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystemm.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	
	[histogramOverlapData readyData];
	[histogramOverlapData ajustLengendSize:CGSizeMake(15, 15)];
	
	return histogramOverlapData;
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartHistogramOverlapView *histogramOverlapView = [[ISSChartHistogramOverlapView alloc] initWithFrame:frame histogramOverlapData:chartData];
	return [histogramOverlapView autorelease];
}

@end
