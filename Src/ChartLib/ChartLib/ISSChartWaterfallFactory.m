//
//  ISSChartWaterfallFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallFactory.h"
#import "ISSChartWaterfallData.h"
#import "ISSChartWaterfallView.h"

@implementation ISSChartWaterfallFactory

- (id)thumbnailChartData
{
    static BOOL changed = FALSE;
    ISSChartWaterfallData *waterfallData = [[ISSChartWaterfallData alloc] init];
    //    histogram.histogramStyle = ISSHistogramGradient;
    //    waterfallData.coordinateSystem.xAxis.axisProperty.strokeColor = [UIColor cyanColor];
    //    waterfallData.coordinateSystem.yAxis.axisProperty.strokeColor = [UIColor cyanColor];
	ISSChartCoordinateSystem *coordinateSystem = waterfallData.coordinateSystem;
//    coordinateSystem.xAxis.axisProperty.axisStyle = kDashingSolid;
	coordinateSystem.bottomMargin = 50;
	coordinateSystem.topMargin = 40;
	coordinateSystem.leftMargin = 40;
	coordinateSystem.rightMargin = 33;
	coordinateSystem.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystem.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:12];
	coordinateSystem.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
	coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
	coordinateSystem.yAxis.axisProperty.strokeWidth = 1.0;
	coordinateSystem.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);

	
    //    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    //    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    //    NSArray *xValues = @[@(00),@(300),@(-200),@(0)];
    NSArray *xNames = @[@"利息收入",@"系统往来净收入",@"利息支出",@"净利息收入", @"最后一项"];
    NSArray *xValues = @[@(1),@(2),@(3),@(4), @(5)];
    
    [waterfallData setXAxisItemsWithNames:xNames values:xValues];
    
    //example 1
    [waterfallData setValues:@[@(500), @(300), @(-200), @(600), @(1200)]];
    
    //example 2
    /*
     NSMutableArray *symbolDatas = [[NSMutableArray alloc] init];
     
     ISSChartWaterfallSymbolData *data1 = [[ISSChartWaterfallSymbolData alloc] init];
     data1.beginValue = 0;
     data1.endValue = 700;
     data1.symbolType = ISSChartSymbolRectangle;
     
     ISSChartWaterfallSymbolData *data2 = [[ISSChartWaterfallSymbolData alloc] init];
     data2.beginValue = 700;
     data2.endValue = 800;
     data2.symbolType = ISSChartSymbolArrow;
     data2.direction = ISSChartArrowDirectionUp;
     
     ISSChartWaterfallSymbolData *data3 = [[ISSChartWaterfallSymbolData alloc] init];
     data3.beginValue = 800;
     data3.endValue = 400;
     data3.symbolType = ISSChartSymbolArrow;
     data3.direction = ISSChartArrowDirectionDown;
     
     ISSChartWaterfallSymbolData *data4 = [[ISSChartWaterfallSymbolData alloc] init];
     data4.beginValue = 0;
     data4.endValue = 400;
     data4.symbolType = ISSChartSymbolRectangle;
     
     [symbolDatas addObject:data1];
     [symbolDatas addObject:data2];
     [symbolDatas addObject:data3];
     [symbolDatas addObject:data4];
     
     RELEASE_SAFELY(data1);
     RELEASE_SAFELY(data2);
     RELEASE_SAFELY(data3);
     RELEASE_SAFELY(data4);
     
     [waterfallData setValues:symbolDatas];
     [symbolDatas release];
     */
    
//    waterfallData.upArrowFillColor = RGBCOLOR(100, 0, 100);
//    waterfallData.downArrowFillColor = RGBCOLOR(100, 100, 100);

//    [waterfallData setValues:@[@(500),@(300),@(-200),@(0)]];
//    [waterfallData setNames:@[@"利息收入",@"系统往来净收入",@"利息支出",@"净利息收入"]];

//    [waterfallData setValues:@[@(500),@(300),@(-200)] andName:@[@"利息收入",@"系统往来净收入",@"利息支出",@"净利息收入"]];

//    NSArray *yValues = @[@(100), @(200), @(300), @(400), @(500), @(600), @(700)];
//    NSArray *yNames = @[@"100", @"200", @"300", @"400", @"500", @"600", @"700"];
//    [waterfallData setYAxisItemsWithNames:yNames values:yValues];

//    waterfallData.coordinateSystem.xAxis.rotateAngle = 310;
//    histogram.coordinateSystem.yAxis.baseValue = 200;
    
    changed = !changed;
    return [waterfallData autorelease];
	
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartWaterfallView *waterfallView = [[ISSChartWaterfallView alloc] initWithFrame:frame waterfallData:chartData];
	return [waterfallView autorelease];
}

@end
