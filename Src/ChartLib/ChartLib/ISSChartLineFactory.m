//
//  ISSChartLineDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartLineFactory.h"
#import "ISSChartLineDataParser.h"
#import "ISSChartLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartLineView.h"

@implementation ISSChartLineFactory

- (id)thumbnailChartData
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
	ISSChartParser *parser = [[ISSChartLineDataParser alloc] init];
	ISSChartLineData *lineData = [parser chartDataWithJson:jsonString];
	[parser release];
	
	ISSChartCoordinateSystem *coordinateSystem = lineData.coordinateSystem;
	coordinateSystem.leftMargin = 40;
	coordinateSystem.topMargin = 29;
	coordinateSystem.bottomMargin = 50;
	coordinateSystem.rightMargin = 33;
	for (ISSChartLine *line in lineData.lines) {
		ISSChartLineProperty *lineProperty = line.lineProperty;
		lineProperty.radius = 6;
		lineProperty.lineWidth = 1.0;
		lineProperty.joinLineWidth = 2;
	}
	coordinateSystem.yAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystem.xAxis.axisProperty.labelFont = [UIFont systemFontOfSize:10];
	coordinateSystem.yAxis.axisProperty.gridColor = RGBCOLOR(214, 214, 214);
	coordinateSystem.yAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
	coordinateSystem.yAxis.axisProperty.strokeWidth = 1.0;
	coordinateSystem.xAxis.axisProperty.strokeColor = RGBCOLOR(139, 139, 139);
	[lineData ajustLengendSize:CGSizeMake(15, 15)];	
	return lineData;
	
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartLineView *lineView = [[ISSChartLineView alloc] initWithFrame:frame lineData:chartData];
	return [lineView autorelease];
}

@end
