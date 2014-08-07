//
//  ISSChartHistogramStackLineDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackLineFactory.h"
#import "ISSChartHistogramStackLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartHistogramStackLineView.h"

@implementation ISSChartHistogramStackLineFactory

- (id)thumbnailChartData
{
    static BOOL changed = FALSE;
    ISSChartHistogramStackLineData *histogramStackLineData = [[ISSChartHistogramStackLineData alloc] init];
    //    histogram.histogramStyle = ISSHistogramGradient;
    histogramStackLineData.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    histogramStackLineData.coordinateSystem.bottomMargin = 150;
    
    histogramStackLineData.coordinateSystem.xAxis.rotateAngle = 270;
    histogramStackLineData.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
    [histogramStackLineData setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramStackLineData.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
    histogramStackLineData.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramStackLineData.legendPosition) {
        histogramStackLineData.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramStackLineData.legendPosition) {
        histogramStackLineData.coordinateSystem.leftMargin = 120;
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
        [histogramStackLineData setBarAndLineValues:barDatas lineValues:lineValues];
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
        [histogramStackLineData setBarAndLineValues:barDatas lineValues:lineValues];
    }
    changed = !changed;
	
	//adjust for thumbnail chart view
	ISSChartCoordinateSystem *coordinateSystem = histogramStackLineData.coordinateSystem;
	if (coordinateSystem.xAxis.rotateAngle == 270) {
		coordinateSystem.bottomMargin = 60;
	}else{
		coordinateSystem.bottomMargin = 36;
	}
	coordinateSystem.leftMargin = 40;
	coordinateSystem.topMargin = 29;
	coordinateSystem.rightMargin = 40;
	coordinateSystem.bottomMargin = 50;
	for (ISSChartLine *line in histogramStackLineData.lines) {
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
	[histogramStackLineData ajustLengendSize:CGSizeMake(15, 15)];
	
    return [histogramStackLineData autorelease];
	
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartHistogramStackLineView *histogramStackLineView = [[ISSChartHistogramStackLineView alloc] initWithFrame:frame histogramStackLineData:chartData];
	return [histogramStackLineView autorelease];
}

@end
