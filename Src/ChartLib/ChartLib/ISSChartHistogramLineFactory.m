//
//  ISSChartHistogramLineDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLineFactory.h"
#import "ISSChartHistogramLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHistogramLineDataParser.h"

@implementation ISSChartHistogramLineFactory

//- (id)thumbnailChartData
//{
//    static BOOL changed = FALSE;
//    ISSChartHistogramLineData *histogramLineData = [[ISSChartHistogramLineData alloc] init];
//    //    histogram.histogramStyle = ISSChartFillGradient;
//    histogramLineData.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
//    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
//    //    NSArray *yNames = @[@"100", @"100", @"200", @"300", @"400", @"500"];
//    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11), @(12)];
//    NSArray *xNames = @[@"", @"2月", @"", @"4月", @"", @"6月", @"", @"8月", @"", @"10月", @"", @"12月"];
//    [histogramLineData setXAxisItemsWithNames:xNames values:xValues];
//    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
//    histogramLineData.legendTextArray = @[@"流量统计", @"光大银行", @"光大银行"];
//    histogramLineData.legendPosition = ISSChartLegendPositionBottom;
//    if (ISSChartLegendPositionRight == histogramLineData.legendPosition) {
//        histogramLineData.coordinateSystem.rightMargin = 140;
//    }
//    else if(ISSChartLegendPositionLeft  == histogramLineData.legendPosition) {
//        histogramLineData.coordinateSystem.leftMargin = 120;
//    }
//    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
//    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
//    if (changed) {
//        NSArray *lineValues = @[@[@(180), @(200), @(200), @(190), @(160), @(150), @(175), @(180), @(190), @(185), @(200), @(400)]
//                                ];
//        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
//        NSArray *barDatas = @[
//                              @[@"120", @"333", @"30", @"70", @"23", @"90", @"120", @"378", @"80", @"90", @"120", @"378"],
//                              @[@"90", @"330", @"310", @"70", @"80", @"340", @"120", @"378", @"430", @"90", @"120", @"378"]
//                              //         @[@"90", @"190", @"310", @"70", @"210", @"90", @"120", @"400", @"80", @"490", @"120", @"378"],
//                              ];
//        [histogramLineData setBarAndLineValues:barDatas lineValues:lineValues];
//    }
//    else {
//        NSArray *lineValues = @[@[@(100), @(120), @(333), @(234), @(240), @(370), @(450), @(120), @(80), @(140), @(90), @(120)]
//                                ];
//        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
//        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
//        NSArray *barDatas = @[
//                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
//                              @[@"90", @"330", @"310", @"70", @"80", @"340", @"120", @"378", @"430", @"90", @"120", @"378"],
//                              @[@"120", @"333", @"30", @"70", @"23", @"90", @"120", @"378", @"80", @"90", @"120", @"378"]
//                              ];
//        [histogramLineData setBarAndLineValues:barDatas lineValues:lineValues];
//    }
//
//    changed = !changed;
//	
//	[histogramLineData readyData];
//	ISSChartCoordinateSystem *coordinateSystem = histogramLineData.coordinateSystem;
//	coordinateSystem.leftMargin = 40;
//	coordinateSystem.topMargin = 29;
//	coordinateSystem.bottomMargin = 50;
//	coordinateSystem.rightMargin = 40;
//
//	for (ISSChartLine *line in histogramLineData.lines) {
//		ISSChartLineProperty *lineProperty = line.lineProperty;
//		lineProperty.radius = 3;
//		lineProperty.lineWidth = 1.0;
//		lineProperty.joinLineWidth = 2;
//	}
//	coordinateSystem.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//	coordinateSystem.viceYAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//	coordinateSystem.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
//	coordinateSystem.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
//	coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
//	coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
//	
//	coordinateSystem.yAxis.axisProperty.strokeWidth = 1.0;
//	coordinateSystem.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
//	[histogramLineData ajustLengendSize:CGSizeMake(15, 15)];
//
//    return [histogramLineData autorelease];
//}

- (id)thumbnailChartData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"histogramline2" ofType:@"txt"];
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [[ISSChartHistogramLineDataParser alloc] init];
	ISSChartHistogramLineData *histogramLineData = [parser chartDataWithJson:jsonString];
	[parser release];
	
	ISSChartCoordinateSystem *coordinateSystem = histogramLineData.coordinateSystem;
	coordinateSystem.leftMargin = 40;
	coordinateSystem.topMargin = 29;
	coordinateSystem.bottomMargin = 50;
	coordinateSystem.rightMargin = 40;
	
	for (ISSChartLine *line in histogramLineData.lines) {
		ISSChartLineProperty *lineProperty = line.lineProperty;
		lineProperty.radius = 3;
		lineProperty.lineWidth = 1.0;
		lineProperty.joinLineWidth = 2;
	}
	coordinateSystem.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystem.viceYAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystem.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystem.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
	coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
	coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
	
	coordinateSystem.yAxis.axisProperty.strokeWidth = 1.0;
	coordinateSystem.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
	[histogramLineData readyData];
	[histogramLineData ajustLengendSize:CGSizeMake(15, 15)];
	
	return histogramLineData;
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartHistogramLineView *histogramLineView = [[ISSChartHistogramLineView alloc] initWithFrame:frame histogramLineData:chartData];
	return [histogramLineView autorelease];
}

@end
