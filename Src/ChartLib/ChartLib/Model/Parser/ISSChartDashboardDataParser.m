//
//  ISSChartDashboardParser.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardDataParser.h"
#import "ISSChartDashboardData.h"
#import "ISSChartGraduation.h"
#import "ISSChartGraduationInterval.h"
#import "UIColor-Expanded.h"
#import "ISSChartPointer.h"

@implementation ISSChartDashboardDataParser

- (void)parseGrdauationIntervals:(NSDictionary *)dataDic dashboardData:(ISSChartDashboardData *)dashboardData
{
	NSArray *labelIntervalDicsArray = dataDic[@"graduation_intervals"];
	if (labelIntervalDicsArray && [labelIntervalDicsArray count]) {
		NSInteger intervalCount = [labelIntervalDicsArray count];
		NSMutableArray *intervals = [NSMutableArray arrayWithCapacity:intervalCount];
		NSMutableArray *legendTextArray = [NSMutableArray array];
		for (NSDictionary *intervalDic in labelIntervalDicsArray) {
			ISSChartGraduationInterval *graduationInterval = [[ISSChartGraduationInterval alloc] init];
			graduationInterval.colors = [self colorsWithArrayOfHexString:intervalDic[@"colors"]];
			
			ISSChartGraduation *startGraduation = [[ISSChartGraduation alloc] init];
			startGraduation.value = [intervalDic[@"start_value"] floatValue];
			graduationInterval.startGraduation = startGraduation;
			[startGraduation release];
			
			ISSChartGraduation *endGraduation = [[ISSChartGraduation alloc] init];
			endGraduation.value = [intervalDic[@"end_value"] floatValue];
			graduationInterval.endGraduation = endGraduation;
			[endGraduation release];
			
			[intervals addObject:graduationInterval];
			[graduationInterval release];
			[legendTextArray addObject:intervalDic[@"name"]];
		}
//		dashboardData.legendTextArray = legendTextArray;
		dashboardData.graduationIntervals = intervals;
	}
}

- (void)parseLabels:(NSDictionary *)dataDic dashboardData:(ISSChartDashboardData *)dashboardData
{
	NSArray *labelDicsArray = dataDic[@"labels"];
	if (labelDicsArray && [labelDicsArray count]) {
		NSInteger labelCount = [labelDicsArray count];
		NSMutableArray *labels = [NSMutableArray arrayWithCapacity:labelCount];
		for (NSDictionary *labelDic in labelDicsArray) {
			ISSChartGraduation *graduation = [[ISSChartGraduation alloc] init];
			graduation.name = labelDic[@"label"];
			graduation.value = [labelDic[@"value"] floatValue];
			if (![self nullOrEmpetyProperty:labelDic[@"text_size"]]) {
				graduation.textSize = [labelDic[@"text_size"] floatValue];
			}
			graduation.textColor = [self colorWithHexString:labelDic[@"text_color"]];
			[labels addObject:graduation];
			[graduation release];
		}
		dashboardData.labels = labels;
	}
}

- (void)parse:(NSDictionary *)dataDic dashboardData:(ISSChartDashboardData *)dashboardData
{
	dashboardData.startAngle = degreesToRadian([dataDic[@"start_angle"] floatValue]);
	dashboardData.endAngle = degreesToRadian([dataDic[@"end_angle"] floatValue]);
	dashboardData.radius = [dataDic[@"radius"] floatValue];
	dashboardData.innerRadius = [dataDic[@"inner_radius"] floatValue];
	dashboardData.origin = CGPointMake([dataDic[@"origin_x"] floatValue], [dataDic[@"origin_y"] floatValue]);
	dashboardData.step = [dataDic[@"graduation_count"] integerValue];
	dashboardData.minimumValue = [dataDic[@"minimum_value"] floatValue];
	dashboardData.maximumValue = [dataDic[@"maximum_value"] floatValue];
	if (![self nullOrEmpetyProperty:dataDic[@"graduation_line_length"]]) {
		dashboardData.graduationLineLength = [dataDic[@"graduation_line_length"] floatValue];
	}
	if (![self nullOrEmpetyProperty:dataDic[@"graduation_line_width"]]) {
		dashboardData.graduationLineWidth = [dataDic[@"graduation_line_width"] floatValue];
	}
	dashboardData.graduationLineColor = [self colorWithHexString:dataDic[@"graduation_line_color"]];
	dashboardData.arcLineColor = [self colorWithHexString:dataDic[@"arc_line_color"]];
	if (![self nullOrEmpetyProperty:dataDic[@"arc_line_width"]]) {
		dashboardData.arcLineWidth = [dataDic[@"arc_line_width"] floatValue];
	}
    NSArray *valueDics = dataDic[@"values"];
    if (valueDics && [valueDics isKindOfClass:[NSArray class]] &&[valueDics count]) {
        NSMutableArray *legendTextArray = [NSMutableArray arrayWithCapacity:[valueDics count]];
        NSMutableArray *pointers = [NSMutableArray arrayWithCapacity:[valueDics count]];
        for (NSDictionary *valudDic in valueDics) {
            ISSChartPointer *pointer = [[ISSChartPointer alloc] init];
            pointer.value = [valudDic[@"value"] floatValue];
            pointer.image = [UIImage imageNamed:@"pointer"];
            pointer.colors = [self colorsWithArrayOfHexString:valudDic[@"colors"]];
            [pointers addObject:pointer];
            [pointer release];
            if (![self nullOrEmpetyProperty:valudDic[@"name"]]) {
                [legendTextArray addObject:valudDic[@"name"]];
            }
            else {
                [legendTextArray addObject:@""];
            };
        }
        dashboardData.pointers = pointers;
        dashboardData.legendTextArray = legendTextArray;
    }
	dashboardData.valueLabel = dataDic[@"value_label"];
}

/*!
 * Parse the json froamt strong to object
 * \params jsonString A json format string
 * \returns An instance of ISSChartDashboardParser is returned
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
		ISSChartDashboardData *dashboardData = [[[ISSChartDashboardData alloc] init] autorelease];
		[self parse:dataDic dashboardData:dashboardData];
		[self parseLabels:dataDic dashboardData:dashboardData];
		[self parseGrdauationIntervals:dataDic dashboardData:dashboardData];
		return dashboardData;
	}
	@catch (NSException *exception) {
		ITTDINFO(@"exception %@", exception);
	}
	@finally {		
	}
}
@end
