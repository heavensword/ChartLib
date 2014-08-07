//
//  ISSChartParser.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartParser.h"
#import "UIColor-Expanded.h"
#import "ISSChartColorUtil.h"

@implementation ISSChartParser

- (id)chartDataWithJson:(NSString*)jsonString
{
	return nil;
}

- (ISSChartLegendPosition)legendPositionWithString:(NSString*)positionString
{
	ISSChartLegendPosition position = ISSChartLegendPositionBottom;
	if (positionString && [positionString length]) {
		positionString = [positionString lowercaseString];
		if ([@"bottom" isEqualToString:positionString]) {
			position = ISSChartLegendPositionBottom;
		}
		else if ([@"top" isEqualToString:positionString]) {
			position = ISSChartLegendPositionTop;
		}
		else if ([@"left" isEqualToString:positionString]) {
			position = ISSChartLegendPositionLeft;
		}
		else if ([@"right" isEqualToString:positionString]) {
			position = ISSChartLegendPositionRight;
		}
		else {
			position = ISSChartLegendPositionBottom;
		}
	}
	return position;
}

- (NSArray*)colorsWithArrayOfHexString:(NSArray*)hexStringArray
{
	NSArray *_colors = nil;
	if (hexStringArray && [hexStringArray count]) {
		NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[hexStringArray count]];
		for (NSString *hexColorString in hexStringArray) {
			UIColor *color = [UIColor colorWithHexString:hexColorString];
			if (color) {
				[colors addObject:color];
			}
		}
		_colors = colors;
	}
	else {
		_colors = @[[ISSChartColorUtil colorWithType:0]];
	}
	return _colors;
}

- (UIColor*)colorWithHexString:(NSString*)hexString
{
	UIColor *color = [UIColor colorWithHexString:hexString];
	if (!color) {
		color = [UIColor lightGrayColor];
	}
	return color;
}

- (BOOL)nullOrEmpetyProperty:(NSString*)propertyString
{
	BOOL invalid = TRUE;
	if (propertyString) {
		NSString *checkString;
		if ([propertyString isKindOfClass:[NSNumber class]]) {
			checkString = [((NSNumber*)propertyString) stringValue];
		}
		else if([propertyString isKindOfClass:[NSNull class]]) {
			checkString = nil;
		}
		else {
			checkString = propertyString;
		}
		invalid = !checkString || [checkString length] <= 0;
	}
	return invalid;
}
@end
