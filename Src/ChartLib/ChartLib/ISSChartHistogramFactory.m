//
//  ISSChartHistogramDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramFactory.h"
#import "ISSChartHistogramDataParser.h"
#import "ISSChartHistogramData.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramView.h"

@implementation ISSChartHistogramFactory

- (id)thumbnailChartData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"histogramdata" ofType:@"txt"];;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [[ISSChartHistogramDataParser alloc] init];
	ISSChartHistogramData *histogramData = [parser chartDataWithJson:jsonString];
	[parser release];

	//adjust data for thnmbnail chart view
	ISSChartCoordinateSystem *coordinateSystemm = histogramData.coordinateSystem;
	coordinateSystemm.leftMargin = 40;
	coordinateSystemm.topMargin = 24;
	coordinateSystemm.bottomMargin = 50;
	coordinateSystemm.rightMargin = 33;
	coordinateSystemm.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystemm.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	
	[histogramData readyData];
	[histogramData ajustLengendSize:CGSizeMake(15, 15)];
	
	return histogramData;
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartHistogramView *histogramView = [[ISSChartHistogramView alloc] initWithFrame:frame histogram:chartData];
	return [histogramView autorelease];
}

@end
