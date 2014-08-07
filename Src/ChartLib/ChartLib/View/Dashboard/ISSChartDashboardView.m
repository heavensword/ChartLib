//
//  ISSChartDashboardView.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardView.h"
#import "ISSChatGallery.h"
#import "ISSChartDashboardContentView.h"
#import "ISSChartDashboardData.h"
#import "ISSChartDashboardLegendView.h"

@interface ISSChartDashboardView()
{
	ISSChartDashboardContentView *_dashboardContentView;
	ISSChartDashboardLegendView	 *_legendView;
}
@end

@implementation ISSChartDashboardView

- (void)dealloc
{
	[_legendView release];
	[_dashboardContentView release];
	[_dashboardData release];
	[super dealloc];
}

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_dashboardContentView = [[ISSChartDashboardContentView alloc] initWithFrame:self.bounds];
		[self addSubview:_dashboardContentView];
		
		_legendView = [[ISSChartDashboardLegendView alloc] initWithFrame:CGRectZero];
		[self addSubview:_legendView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - public methods
- (void)setDashboardData:(ISSChartDashboardData *)dashboardData
{
	RELEASE_SAFELY(_dashboardData);
	_dashboardData = [dashboardData retain];
	[_dashboardData readyData];	
	_dashboardContentView.dashboardData = _dashboardData;
	
	_legendView.frame = [self getLegendFrame:self.dashboardData.coordinateSystem legendPosition:self.dashboardData.legendPosition maxLegendSize:[self.dashboardData getMaxLegendUnitSize]];
	_legendView.chartData = self.dashboardData;
}

@end
