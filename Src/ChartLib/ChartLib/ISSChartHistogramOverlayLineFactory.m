//
//  ISSChartHistogramOverlayLineDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlayLineFactory.h"
#import "ISSChartHistogramOverlapLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartHistogramOverlapLineView.h"
#import "ISSChartHistogramOverlapLineDataParser.h"

@implementation ISSChartHistogramOverlayLineFactory

- (id)thumbnailChartData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"histogramoverlapline" ofType:@"txt"];
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [[ISSChartHistogramOverlapLineDataParser alloc] init];
	ISSChartHistogramOverlapLineData *histogramOverlapLineData = [parser chartDataWithJson:jsonString];
	[parser release];
	
	ISSChartCoordinateSystem *coordinateSystem = histogramOverlapLineData.coordinateSystem;
	coordinateSystem.leftMargin = 40;
	coordinateSystem.topMargin = 29;
	coordinateSystem.bottomMargin = 50;
	coordinateSystem.rightMargin = 40;
	
	for (ISSChartLine *line in histogramOverlapLineData.lines) {
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
	[histogramOverlapLineData readyData];
	[histogramOverlapLineData ajustLengendSize:CGSizeMake(15, 15)];
	
	return histogramOverlapLineData;
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartHistogramOverlapLineView *histogramOverlapLineView = [[ISSChartHistogramOverlapLineView alloc] initWithFrame:frame histogramOverlapLineData:chartData];
	return [histogramOverlapLineView autorelease];
}

@end
