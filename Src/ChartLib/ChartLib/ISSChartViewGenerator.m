//
//  ISSChartViewGenerator.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartViewGenerator.h"
#import "ISSChartPieFactory.h"
#import "ISSChartHistogramFactory.h"
#import "ISSChartLineFactory.h"
#import "ISSChartHistogramFactory.h"
#import "ISSChartHistogramLineFactory.h"
#import "ISSChartDashboardFactory.h"
#import "ISSChartHistogramOverlayFactory.h"
#import "ISSChartHistogramOverlayLineFactory.h"
#import "ISSChartHistogramStackFactory.h"
#import "ISSChartHistogramStackLineFactory.h"
#import "ISSChartBaseData.h"
#import "ISSChartWaterfallFactory.h"

@implementation ISSChartViewGenerator

- (ISSChartType)chartType:(NSString*)chartName
{
	ISSChartType chartType = ISSChartTypeNone;
	if ([@"ISSChartLineView" isEqualToString:chartName]) {
		chartType = ISSChartTypeLine;
	}
	else if ([@"ISSChartHistogramView" isEqualToString:chartName]) {
		chartType = ISSChartTypeHistogram;
	}
	else if ([@"ISSChartHistogramLineView" isEqualToString:chartName]) {
		chartType = ISSChartTypeHistogramLine;
	}
	else if ([@"ISSChartPieView" isEqualToString:chartName]) {
		chartType = ISSChartTypePie;
	}
	else if ([@"ISSChartDashboardView" isEqualToString:chartName]) {
		chartType = ISSChartTypeDashboard;
	}
	else if ([@"ISSChartWaterfallView" isEqualToString:chartName]) {
		chartType = ISSChartTypeWaterfall;
	}
	else if ([@"ISSChartHistogramOverlapView" isEqualToString:chartName]) {
		chartType = ISSChartTypeHistogramOverlap;
	}
	else if ([@"ISSChartHistogramOverlapLineView" isEqualToString:chartName]) {
		chartType = ISSChartTypeHistogramOverlapLine;
	}
	else if ([@"ISSChartHistogramStackLineView" isEqualToString:chartName]) {
		chartType = ISSChartTypeStack;
	}
	else if ([@"ISSChartHistogramStackLineView" isEqualToString:chartName]) {
		chartType = ISSChartTypeStackLine;
	}
	return chartType;
}

- (id)thumbnailChartViewWithChartName:(NSString*)chartName frame:(CGRect)frame
{
	ISSChartFactory *chartFactory = [self chartFactoryWithChartName:chartName];
	ISSChartBaseData *chartData = [chartFactory thumbnailChartData];
	chartData.coordinateSystem.xAxis.axisProperty.needDisplayUnit = FALSE;
	chartData.coordinateSystem.yAxis.axisProperty.needDisplayUnit = FALSE;
	id chartView = [chartFactory thumbnailChartViewWithFrame:frame chartData:chartData];
	return chartView;
}

- (ISSChartFactory *)chartFactoryWithChartName:(NSString *)chartName
{
	ISSChartFactory *chartFactory = nil;
	ISSChartType chartType = [self chartType:chartName];
	switch (chartType) {
		case ISSChartTypePie:
			chartFactory = [[ISSChartPieFactory alloc] init];
			break;
		case ISSChartTypeHistogram:
			chartFactory = [[ISSChartHistogramFactory alloc] init];
			break;
		case ISSChartTypeLine:
			chartFactory = [[ISSChartLineFactory alloc] init];
			break;
		case ISSChartTypeDashboard:
			chartFactory = [[ISSChartDashboardFactory alloc] init];
			break;
		case ISSChartTypeHistogramLine:
			chartFactory = [[ISSChartHistogramLineFactory alloc] init];
			break;
		case ISSChartTypeHistogramOverlap:
			chartFactory = [[ISSChartHistogramOverlayFactory alloc] init];
			break;
		case ISSChartTypeHistogramOverlapLine:
			chartFactory = [[ISSChartHistogramOverlayLineFactory alloc] init];
			break;
		case ISSChartTypeStack:
			chartFactory = [[ISSChartHistogramStackFactory alloc] init];
			break;
		case ISSChartTypeStackLine:
			chartFactory = [[ISSChartHistogramStackLineFactory alloc] init];
			break;
		case ISSChartTypeWaterfall:
			chartFactory = [[ISSChartWaterfallFactory alloc] init];
			break;
		default:
			break;
	}
	return [chartFactory autorelease];
}
@end
