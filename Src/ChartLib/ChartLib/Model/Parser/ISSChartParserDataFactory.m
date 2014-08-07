//
//  ISSChartParserFactory.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartParserDataFactory.h"
#import "ISSChartDashboardDataParser.h"
#import "ISSChartLineDataParser.h"
#import "ISSChartPieDataParser.h"
#import "ISSChartHistogramDataParser.h"
#import "ISSChartHistogramLineDataParser.h"
#import "ISSChartHistogramOverlapDataParser.h"
#import "ISSChartHistogramOverlapLineDataParser.h"

@implementation ISSChartParserDataFactory

+ (ISSChartParser*)parserWithType:(ISSChartType)chartType
{
	ISSChartParser *parser = nil;
	switch (chartType) {
		case ISSChartTypeDashboard:
			parser = [[[ISSChartDashboardDataParser alloc] init] autorelease];
			break;
		case ISSChartTypeLine:
			parser = [[[ISSChartLineDataParser alloc] init] autorelease];
			break;
		case ISSChartTypePie:
			parser = [[[ISSChartPieDataParser alloc] init] autorelease];
			break;
		case ISSChartTypeHistogram:
			parser = [[[ISSChartHistogramDataParser alloc] init] autorelease];
			break;
		case ISSChartTypeHistogramLine:
			parser = [[[ISSChartHistogramLineDataParser alloc] init] autorelease];
			break;
        case ISSChartTypeHistogramOverlap:
            parser = [[[ISSChartHistogramOverlapDataParser alloc] init] autorelease];
            break;
        case ISSChartTypeHistogramOverlapLine:
            parser = [[[ISSChartHistogramOverlapLineDataParser alloc] init] autorelease];
            break;
		default:
			break;
	}
	return parser;
}
@end
