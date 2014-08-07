//
//  ISSChartHistogramParser.m
//  ChartLib
//
//  Created by Sword on 13-12-2.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapDataParser.h"
#import "ISSChartHistogramOverlapData.h"
#import "ISSChartTitle.h"
#import "UIColor-Expanded.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"

@implementation ISSChartHistogramOverlapDataParser

- (void)parseBars:(NSDictionary *)dataDic histogramOverlapData:(ISSChartHistogramOverlapData *)histogramOverlapData
{
	//parse lines data
	NSString *colorHexString;
	NSString *legendName;
	NSArray *barColors;
	NSArray *dataOfHistograms;
	UIColor *strokeColor;
	NSArray *barsDataDicArray = dataDic[@"bars"];
	if (barsDataDicArray && [barsDataDicArray isKindOfClass:[NSArray class]] && [barsDataDicArray count]) {
		NSMutableArray *legendTextArray = [NSMutableArray array];
		NSMutableArray *histogramValues = [NSMutableArray array];
		NSMutableArray *strokeColors = [NSMutableArray array];
		NSMutableArray *fillColors = [NSMutableArray array];
		for (NSDictionary *histogramDic in barsDataDicArray) {
			legendName = histogramDic[@"name"];
			if (!legendName) {
				legendName = @"";
			}
			[legendTextArray addObject:legendName];
			dataOfHistograms = histogramDic[@"data"];
			if (dataOfHistograms) {
				[histogramValues addObject:dataOfHistograms];
			}
			colorHexString = histogramDic[@"stroke_color"];
			strokeColor = [self colorWithHexString:colorHexString];
			if (!strokeColor) {
				strokeColor = [UIColor randomColor];
			}
			[strokeColors addObject:strokeColor];
			
			barColors = [self colorsWithArrayOfHexString:histogramDic[@"fill_colors"]];
			if (barColors) {
				[fillColors addObject:barColors];
			}
			//add a random color
			else {
				[fillColors addObject:@[[UIColor randomColor]]];
			}
		}
		[histogramOverlapData setBarStrokColors:strokeColors];
		[histogramOverlapData setBarFillColors:fillColors];
		histogramOverlapData.legendTextArray = legendTextArray;
		[histogramOverlapData setBarDataValues:histogramValues];
	}
}

- (void)parseXAxis:(NSDictionary *)dataDic histogramOverlapData:(ISSChartHistogramOverlapData *)histogramData
{
	//parse x axis
	NSDictionary *xaxisDic = dataDic[@"xaxis"];
	if (xaxisDic && [[xaxisDic allKeys] count]) {
		ISSChartAxis *xAxis = histogramData.coordinateSystem.xAxis;
		ISSChartAxisProperty *xAxisProperty = xAxis.axisProperty;
		xAxis.unit = xaxisDic[@"unit"];
		NSArray *labels = xaxisDic[@"labels"];
		if (labels && [labels count]) {
			[xAxis setAxisItemsWithNames:labels];
		}
		xAxisProperty.strokeColor = [self colorWithHexString:xaxisDic[@"stroke_color"]];
		xAxisProperty.gridColor =  [self colorWithHexString:xaxisDic[@"grid_color"]];
		if (![self nullOrEmpetyProperty:xaxisDic[@"line_width"]]) {
			xAxisProperty.strokeWidth = [xaxisDic[@"line_width"] floatValue];
		}
		if (![self nullOrEmpetyProperty:xaxisDic[@"font_size"]]) {
			xAxisProperty.labelFont = [UIFont systemFontOfSize:[xaxisDic[@"font_size"] floatValue]];
		}
		xAxisProperty.textColor = [self colorWithHexString:xaxisDic[@"font_color"]];
	}
}

- (void)parseYAxis:(NSDictionary *)dataDic histogramOverlapData:(ISSChartHistogramOverlapData *)histogramData
{
	//parse y axis
	NSDictionary *yaxisDic = dataDic[@"yaxis"];
	if (yaxisDic && [[yaxisDic allKeys] count]) {
		ISSChartAxis *yAxis = histogramData.coordinateSystem.yAxis;
		ISSChartAxisProperty *yAxisProperty = yAxis.axisProperty;
		yAxis.unit = yaxisDic[@"unit"];
		yAxis.axisType = [yaxisDic[@"type"] integerValue];
		yAxisProperty.strokeColor = [self colorWithHexString:yaxisDic[@"stroke_color"]];
		yAxisProperty.gridColor =  [self colorWithHexString:yaxisDic[@"grid_color"]];
		if (![self nullOrEmpetyProperty:yaxisDic[@"line_width"]]) {
			yAxisProperty.strokeWidth = [yaxisDic[@"line_width"] floatValue];
		}
		if (![self nullOrEmpetyProperty:yaxisDic[@"font_size"]]) {
			yAxisProperty.labelFont = [UIFont systemFontOfSize:[yaxisDic[@"font_size"] floatValue]];
		}
		yAxisProperty.textColor = [self colorWithHexString:yaxisDic[@"font_color"]];
	}
}

- (void)parseLegend:(NSDictionary *)dataDic histogramOverlapData:(ISSChartHistogramOverlapData *)histogramOverlapData
{
	//parse legend
	NSDictionary *legendDic = dataDic[@"legend"];
	if (legendDic && [legendDic count]) {
		histogramOverlapData.legendPosition = [self legendPositionWithString:legendDic[@"position"]];
		if (![self nullOrEmpetyProperty:legendDic[@"font_size"]]) {
			histogramOverlapData.legendFontSize = [legendDic[@"font_size"] floatValue];
		}
	}
}

- (void)parseTitle:(NSDictionary *)dataDic histogramOverlapData:(ISSChartHistogramOverlapData *)histogramOverlapData
{
	NSDictionary *titleDic = dataDic[@"title"];
	if (titleDic && [[titleDic allKeys] count]) {
		ISSChartTitle *title = [[ISSChartTitle alloc] init];
		title.text = titleDic[@"text"];
		if (![self nullOrEmpetyProperty:titleDic[@"font_size"]]) {
			title.fontSize = [titleDic[@"font_size"] floatValue];
		}
		title.textColor = [self colorWithHexString:titleDic[@"font_color"]];
		histogramOverlapData.title = title;
		[title release];
	}
	
	NSDictionary *subtitleDic = dataDic[@"subtitle"];
	if (titleDic && [[titleDic allKeys] count]) {
		ISSChartTitle *subtitle = [[ISSChartTitle alloc] init];
		subtitle.text = subtitleDic[@"text"];
		if (![self nullOrEmpetyProperty:subtitleDic[@"font_size"]]) {
			subtitle.fontSize = [subtitleDic[@"font_size"] floatValue];
		}
		subtitle.textColor = [self colorWithHexString:subtitleDic[@"font_color"]];
		histogramOverlapData.subtitle = subtitle;
		[subtitle release];
	}
}

/*!
 * Parse the json froamt strong to object
 * \params jsonString A json format string
 * \returns An instance of ISSChartHistogramOverlapData is returned
 */
- (id)chartDataWithJson:(NSString*)jsonString
{
	@try {
		NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error = nil;
		NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
		if (error) {
			@throw [NSException exceptionWithName:@"Data Format Error" reason:@"json data format error!" userInfo:nil];
		}
		ISSChartHistogramOverlapData *histogramOverlapData = [[[ISSChartHistogramOverlapData alloc] init] autorelease];
		[self parseTitle:dataDic histogramOverlapData:histogramOverlapData];
		[self parseXAxis:dataDic histogramOverlapData:histogramOverlapData];
		[self parseYAxis:dataDic histogramOverlapData:histogramOverlapData];
		[self parseLegend:dataDic histogramOverlapData:histogramOverlapData];
		[self parseBars:dataDic histogramOverlapData:histogramOverlapData];
		return histogramOverlapData;
	}
	@catch (NSException *exception) {
		
	}
	@finally {
		
	}
}

@end
