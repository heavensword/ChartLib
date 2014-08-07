//
//  ISSChartPieDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartPieFactory.h"
#import "ISSChartPieData.h"
#import "ISSChartPieDataParser.h"
#import "ISSChartPieView.h"

@implementation ISSChartPieFactory

- (id)thumbnailChartData
{
	static BOOL pieFlag = TRUE;
	NSString *path = nil;
	if (pieFlag) {
		path = [[NSBundle mainBundle] pathForResource:@"piedata2" ofType:@"txt"];
	}
	else {
		path = [[NSBundle mainBundle] pathForResource:@"piedata" ofType:@"txt"];		
	}
	pieFlag = !pieFlag;
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [[ISSChartPieDataParser alloc] init];
	ISSChartPieData *pieData = [parser chartDataWithJson:jsonString];
	[parser release];
	pieData.displayFullHintMessage = FALSE;
	pieData.coordinateSystem.bottomMargin = 50;
	pieData.origin =  CGPointMake(160.0f, 140.0f);
	[pieData adjustRadius:72 innerRadius:54];
	[pieData ajustLengendSize:CGSizeMake(15, 15)];
	return pieData;
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartPieView *pieView = [[ISSChartPieView alloc] initWithFrame:frame pieData:chartData];
	return [pieView autorelease];
}

@end
