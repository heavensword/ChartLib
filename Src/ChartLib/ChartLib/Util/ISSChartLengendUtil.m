//
//  ISSChartLengendUtil.m
//  ChartLib
//
//  Created by Sword on 13-11-5.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartLengendUtil.h"
#import "ISSChartLegendUnitView.h"
#import "ISSChartDashboardLegendUnitView.h"
#import "ISSChartPieLegendUnitView.h"
#import "ISSChartHistogramLegendUnitView.h"
#import "ISSChartLineLegendUnitView.h"

@implementation ISSChartLengendUtil

+ (ISSChartLegendUnitView*)newLegendUnitViewWithChartType:(ISSChartLegendType)legendType
{
	ISSChartLegendUnitView *legendUnitView = nil;
	switch (legendType) {
		case ISSChartLegendDashBoard:
			legendUnitView = [[ISSChartDashboardLegendUnitView alloc] initWithFrame:CGRectZero];
			break;
		case ISSChartLegendPie:
			legendUnitView = [[ISSChartPieLegendUnitView alloc] initWithFrame:CGRectZero];
			break;
		case ISSChartLegendHistogram:
			legendUnitView = [[ISSChartHistogramLegendUnitView alloc] initWithFrame:CGRectZero];
			break;
		case ISSChartLegendLine:
			legendUnitView = [[ISSChartLineLegendUnitView alloc] initWithFrame:CGRectZero];
			break;
		default:
			legendUnitView = [[ISSChartLegendUnitView alloc] initWithFrame:CGRectZero];
			break;
	}
	return legendUnitView;
}

@end
