//
//  ISSChartDashboardDataFactory.m
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardFactory.h"
#import "ISSChartDashboardDataParser.h"
#import "ISSChartDashboardData.h"
#import "ISSChartPointer.h"
#import "ISSChartDashboardView.h"

@implementation ISSChartDashboardFactory

- (id)thumbnailChartData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"dashboard" ofType:@"txt"];
	NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	ISSChartParser *parser = [[ISSChartDashboardDataParser alloc] init];
	ISSChartDashboardData *dashboardData = [parser chartDataWithJson:jsonString];
	[parser release];
	
	dashboardData.origin = CGPointMake(160.0f, 180.0f);
	dashboardData.innerRadius = 84.0f;
	dashboardData.radius = 112.0f;
    for (ISSChartPointer *pointer in dashboardData.pointers) {
        pointer.image = [UIImage imageNamed:@"pointer_small"] ;
    }
    ISSChartCoordinateSystem *coordinateSystem = dashboardData.coordinateSystem;
	coordinateSystem.bottomMargin = 100;
	[dashboardData ajustLengendSize:CGSizeMake(15, 15)];	
	return dashboardData;
}

- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData
{
	ISSChartDashboardView *dashboardView = [[ISSChartDashboardView alloc] initWithFrame:frame];
	dashboardView.dashboardData = chartData;
	return [dashboardView autorelease];
}

@end
