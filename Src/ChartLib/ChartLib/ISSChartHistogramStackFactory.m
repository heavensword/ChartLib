//
//  ISSChartHistogramStackDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackFactory.h"
#import "ISSChartHistogramStackData.h"
#import "ISSChartHistogramStackView.h"

@implementation ISSChartHistogramStackFactory

- (id)thumbnailChartData
{
    static BOOL changed = FALSE;
    ISSChartHistogramStackData *histogramStackData = [[ISSChartHistogramStackData alloc] init];
    //    histogram.histogramStyle = ISSHistogramGradient;
    histogramStackData.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    histogramStackData.coordinateSystem.bottomMargin = 150;
    
    histogramStackData.coordinateSystem.xAxis.rotateAngle = 270;
    histogramStackData.coordinateSystem.viceYAxis.axisType = ISSChartAxisTypePercentage;
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5)];
    NSArray *xNames = @[@"13/03", @"13/04", @"13/05", @"13/06", @"13/07"];
    [histogramStackData setXAxisItemsWithNames:xNames values:xValues];
    //    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogramStackData.legendTextArray = @[@"贷款外币", @"贷款人民币", @"贷款占比"];
    histogramStackData.legendPosition = ISSChartLegendPositionBottom;
    if (ISSChartLegendPositionRight == histogramStackData.legendPosition) {
        histogramStackData.coordinateSystem.rightMargin = 140;
    }
    else if(ISSChartLegendPositionLeft  == histogramStackData.legendPosition) {
        histogramStackData.coordinateSystem.leftMargin = 120;
    }
    //    histogramLine.coordinateSystem.xAxis.rotateAngle = 310;
    //    histogramLine.coordinateSystem.yAxis.baseValue = 200;
    if (changed) {
        //        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        NSArray *barDatas = @[
                              @[@"1200", @"333", @"3000", @"7000", @"2300"],
                              @[@"90", @"3309", @"310", @"70", @"80"]
                              ];
        [histogramStackData setBarValues:barDatas];
        
    }
    else {
        //        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        //        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
        NSArray *barDatas = @[
                              //             @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],
                              @[@"90", @"3300", @"310", @"70", @"80"],
                              @[@"1200", @"333", @"3000", @"7000", @"2300"]
                              ];
        [histogramStackData setBarValues:barDatas];
    }
    changed = !changed;
	
	//adjust for thumbnail chart view
	histogramStackData.legendPosition = ISSChartLegendPositionBottom;
	ISSChartCoordinateSystem *coordinateSystemm = histogramStackData.coordinateSystem;
	if (coordinateSystemm.xAxis.rotateAngle == 270) {
		coordinateSystemm.bottomMargin = 60;
	}
	else {
		coordinateSystemm.bottomMargin = 36;
	}
	coordinateSystemm.leftMargin = 40;
	coordinateSystemm.topMargin = 29;
	coordinateSystemm.rightMargin = 40;
	coordinateSystemm.bottomMargin = 50;
//	coordinateSystemm.xAxis.rotateAngle = 310;
	coordinateSystemm.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystemm.viceYAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystemm.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystemm.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
	[histogramStackData ajustLengendSize:CGSizeMake(15, 15)];
	
    return [histogramStackData autorelease];
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartHistogramStackView *histogramStackView = [[ISSChartHistogramStackView alloc] initWithFrame:frame histogramStackData:chartData];
	return [histogramStackView autorelease];
}

@end
