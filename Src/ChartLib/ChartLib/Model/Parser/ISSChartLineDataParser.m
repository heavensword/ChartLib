//
//  ISSChartLineParser.m
//  ChartLib
//
//  Created by Sword on 13-12-2.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartLineDataParser.h"
#import "ISSChartLineData.h"
#import "ISSChartTitle.h"
#import "UIColor-Expanded.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"

@implementation ISSChartLineDataParser

- (void)parseLine:(NSDictionary *)dataDic lineData:(ISSChartLineData *)lineData
{
	//parse lines data
	NSString *propertyString;
	NSString *legendName;
	NSArray *dataOfLine;
	NSArray *linesDataDicArray = dataDic[@"lines"];
	if (linesDataDicArray && [linesDataDicArray isKindOfClass:[NSArray class]] && [linesDataDicArray count]) {
		NSMutableArray *legendTextArray = [NSMutableArray array];
		NSMutableArray *lineValues = [NSMutableArray array];
		NSMutableArray *lines = [NSMutableArray array];
		for (NSDictionary *lineDic in linesDataDicArray) {
			legendName = lineDic[@"name"];
			if (!legendName) {
				legendName = @"";
			}
			[legendTextArray addObject:legendName];
			dataOfLine = lineDic[@"data"];
			if (dataOfLine) {
				[lineValues addObject:dataOfLine];
			}
			ISSChartLineProperty *lineProperty = [[ISSChartLineProperty alloc] init];
			
			propertyString = lineDic[@"join_type"];
			if (![self nullOrEmpetyProperty:propertyString]) {
				lineProperty.pointStyle = [propertyString integerValue];
			}
			
			propertyString = lineDic[@"line_width"];
			if (![self nullOrEmpetyProperty:propertyString]) {
				lineProperty.lineWidth = [propertyString floatValue];
			}
			
			propertyString = lineDic[@"stroke_color"];
			if (propertyString && [propertyString length]) {
				lineProperty.strokeColor = [self colorWithHexString:propertyString];
			}
			
			ISSChartLine *line = [[ISSChartLine alloc] init];
			line.lineProperty = lineProperty;
			line.name = legendName;
			[lineProperty release];
			line.values = lineDic[@"data"];
			
			[lines addObject:line];
			[line release];
		}
		lineData.legendTextArray = legendTextArray;
		lineData.lineDataArrays = lineValues;
		lineData.lines = lines;
	}
}

- (void)parseXAxis:(NSDictionary *)dataDic lineData:(ISSChartLineData *)lineData
{
	//parse x axis
	NSDictionary *xaxisDic = dataDic[@"xaxis"];
	if (xaxisDic && [[xaxisDic allKeys] count]) {
		ISSChartAxis *xAxis = lineData.coordinateSystem.xAxis;
		ISSChartAxisProperty *xAxisProperty = xAxis.axisProperty;
		xAxis.unit = xaxisDic[@"unit"];
		NSArray *labels = xaxisDic[@"labels"];
		if (labels && [labels count]) {
			[xAxis setAxisItemsWithNames:labels];
		}
		xAxisProperty.strokeColor = [self colorWithHexString:xaxisDic[@"stroke_color"]];
		xAxisProperty.gridColor = [self colorWithHexString:xaxisDic[@"grid_color"]];
		if (![self nullOrEmpetyProperty:xaxisDic[@"line_width"]]) {
			xAxisProperty.strokeWidth = [xaxisDic[@"line_width"] floatValue];			
		}
		if (![self nullOrEmpetyProperty:xaxisDic[@"font_size"]]) {
			xAxisProperty.labelFont = [UIFont systemFontOfSize:[xaxisDic[@"font_size"] floatValue]];
		}
		xAxisProperty.textColor = [self colorWithHexString:xaxisDic[@"font_color"]];
	}
}

- (void)parseYAxis:(NSDictionary *)dataDic lineData:(ISSChartLineData *)lineData
{
	//parse y axis
	NSDictionary *yaxisDic = dataDic[@"yaxis"];
	if (yaxisDic && [[yaxisDic allKeys] count]) {
		ISSChartAxis *yAxis = lineData.coordinateSystem.yAxis;
		ISSChartAxisProperty *yAxisProperty = yAxis.axisProperty;
		yAxis.unit = yaxisDic[@"unit"];
		yAxis.axisType = [yaxisDic[@"type"] integerValue];
		
		yAxisProperty.strokeColor = [self colorWithHexString:yaxisDic[@"stroke_color"]];
		yAxisProperty.gridColor = [self colorWithHexString:yaxisDic[@"grid_color"]];
		if (![self nullOrEmpetyProperty:yaxisDic[@"line_width"]]) {
			yAxisProperty.strokeWidth = [yaxisDic[@"line_width"] floatValue];
		}
		if (![self nullOrEmpetyProperty:yaxisDic[@"font_size"]]) {
			yAxisProperty.labelFont = [UIFont systemFontOfSize:[yaxisDic[@"font_size"] floatValue]];
		}
		yAxisProperty.textColor = [self colorWithHexString:yaxisDic[@"font_color"]];
	}
}

- (void)parseLegend:(NSDictionary *)dataDic lineData:(ISSChartLineData *)lineData
{
	//parse legend
	NSDictionary *legendDic = dataDic[@"legend"];
	if (legendDic && [legendDic count]) {
		lineData.legendPosition = [self legendPositionWithString:legendDic[@"position"]];
		if (![self nullOrEmpetyProperty:legendDic[@"font_size"]]) {
			lineData.legendFontSize = [legendDic[@"font_size"] floatValue];
		}
	}
}

- (void)parseTitle:(NSDictionary *)dataDic lineData:(ISSChartLineData *)lineData
{
	NSDictionary *titleDic = dataDic[@"title"];
	if (titleDic && [[titleDic allKeys] count]) {
		ISSChartTitle *title = [[ISSChartTitle alloc] init];
		title.text = titleDic[@"text"];
		if (![self nullOrEmpetyProperty:titleDic[@"font_size"]]) {
			title.fontSize = [titleDic[@"font_size"] floatValue];
		}
		title.textColor = [self colorWithHexString:titleDic[@"font_color"]];
		lineData.title = title;
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
		lineData.subtitle = subtitle;
		[subtitle release];
	}
}

/*!
 * Parse the json froamt strong to object
 * \params jsonString A json format string
 * \returns An instance of ISSChartLineData is returned
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
		ISSChartLineData *lineData = [[[ISSChartLineData alloc] init] autorelease];
		[self parseTitle:dataDic lineData:lineData];
		[self parseXAxis:dataDic lineData:lineData];
		[self parseYAxis:dataDic lineData:lineData];
		[self parseLegend:dataDic lineData:lineData];
		[self parseLine:dataDic lineData:lineData];
		return lineData;
	}
	@catch (NSException *exception) {
		ITTDINFO(@"exception %@", exception);		
	}
	@finally {
	}
}

@end
