//
//  ISSChartPieDataParser.m
//  ChartLib
//
//  Created by Sword on 13-12-2.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartPieDataParser.h"
#import "ISSChartPieData.h"
#import "ISSChartPieSection.h"
#import "ISSChartPieSectionProperty.h"
#import "ISSChartTitle.h"
#import "UIColor-Expanded.h"
#import "ISSChartColorUtil.h"

@implementation ISSChartPieDataParser

- (void)parseTitle:(NSDictionary *)dataDic pieData:(ISSChartPieData *)pieData
{
	NSDictionary *titleDic = dataDic[@"title"];
	if (titleDic && [[titleDic allKeys] count]) {
		ISSChartTitle *title = [[ISSChartTitle alloc] init];
		title.text = titleDic[@"text"];
		if (![self nullOrEmpetyProperty:titleDic[@"font_size"]]) {
			title.fontSize = [titleDic[@"font_size"] floatValue];
		}
		title.textColor = [self colorWithHexString:titleDic[@"font_color"]];
		pieData.title = title;
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
		pieData.subtitle = subtitle;
		[subtitle release];
	}
}

- (void)parseLegend:(NSDictionary *)dataDic pieData:(ISSChartPieData *)pieData
{
	//parse legend
	NSDictionary *legendDic = dataDic[@"legend"];
	if (legendDic && [legendDic count]) {
		pieData.legendPosition = [self legendPositionWithString:legendDic[@"position"]];
		if (![self nullOrEmpetyProperty:legendDic[@"font_size"]]) {
			pieData.legendFontSize = [legendDic[@"font_size"] floatValue];
		}
	}
}

- (void)parseSections:(NSDictionary *)dataDic pieData:(ISSChartPieData *)pieData
{
	NSString *legendName;
	NSArray *sectionDicArray = dataDic[@"sections"];
	NSMutableArray *sections = [NSMutableArray array];
	NSMutableArray *legendTextArray = [NSMutableArray array];
	NSArray *colors;
	for (NSDictionary *sectionDic in sectionDicArray) {		
        ISSChartPieSection *section = [[ISSChartPieSection alloc] init];
        section.value = [sectionDic[@"value"] floatValue];
		legendName = sectionDic[@"name"];
		if (!legendName) {
			legendName = @"";
		}
		[legendTextArray addObject:legendName];
        ISSChartPieSectionProperty *property = [[ISSChartPieSectionProperty alloc] init];
        section.pieSectionProperty = property;
		colors = [self colorsWithArrayOfHexString:sectionDic[@"fill_colors"]];
		if (colors && [colors count]) {
			property.fillColors = colors;
		}
		else {
			property.fillColors = @[[UIColor randomColor]];
		}
		if (![self nullOrEmpetyProperty:sectionDic[@"font_size"]]) {
			property.textFont = [UIFont systemFontOfSize:[sectionDic[@"font_size"] floatValue]];
		}
        [property release];
		[sections addObject:section];
		[section release];
	}
	pieData.legendTextArray = legendTextArray;
	pieData.sections = sections;
}

- (void)parse:(NSDictionary *)dataDic pieData:(ISSChartPieData *)pieData
{
	NSString *radiusString = dataDic[@"radius"];
	if (radiusString && [radiusString length]) {
		pieData.radius = [radiusString floatValue];
	}
	NSString *innerRadiusString = dataDic[@"inner_radius"];
	if (innerRadiusString && [innerRadiusString length]) {
		pieData.innerRadius = [innerRadiusString floatValue];
	}
	NSString *originXString = dataDic[@"origin_x"];
	NSString *originYString = dataDic[@"origin_y"];
	if (originXString && originYString) {
		pieData.origin = CGPointMake([originXString floatValue], [originYString floatValue]);
	}
}

/*!
 * Parse the json froamt strong to object
 * \params jsonString A json format string
 * \returns An instance of ISSChartPieData is returned
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
		ISSChartPieData *pieData = [[[ISSChartPieData alloc] init] autorelease];
		[self parse:dataDic pieData:pieData];
		[self parseTitle:dataDic pieData:pieData];
		[self parseLegend:dataDic pieData:pieData];
		[self parseSections:dataDic pieData:pieData];
		//test
		pieData.displayFullHintMessage = TRUE;
		return pieData;
	}
	@catch (NSException *exception) {
		ITTDINFO(@"exception %@", exception);
	}
	@finally {
		
	}
}

@end
