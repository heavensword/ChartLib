//
//  ChartDataGenerator.h
//  ChartLib
//
//  Created by Sword Zhou on 6/19/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "Manager.h"

@class ISSChartPieData;
@class ISSChartLineData;
@class ISSChartHistogramData;
@class ISSChartHistogramLineData;
@class ISSChartWaterfallData;
@class ISSChartHistogramOverlapData;
@class ISSChartHistogramOverlapLineData;
@class ISSChartHistogramStackData;
@class ISSChartHistogramStackLineData;
@class ISSChartDashboardData;

@interface ISSChartDataGenerator : Manager

- (ISSChartPieData*)pieData;
- (ISSChartPieData*)pieData:(NSInteger)count;
- (ISSChartPieData*)pieDataFromParser;
- (ISSChartLineData*)lineData;
- (ISSChartLineData*)lineDataFromParser;
- (ISSChartHistogramData*)histogramData;
- (ISSChartHistogramData*)histogramDataFromParser;
- (ISSChartHistogramLineData*)histogramLineData;
- (ISSChartHistogramLineData*)histogramLineDataFromParser;
- (ISSChartWaterfallData *)waterfallData;
- (ISSChartHistogramOverlapData *)histogramOverlapData;
- (ISSChartHistogramOverlapData *)histogramOverlapDataFromParser;
- (ISSChartHistogramOverlapLineData *)histogramOverlapLineData;
- (ISSChartHistogramOverlapLineData *)histogramOverlapLineDataFromParser;
- (ISSChartHistogramStackData *)histogramStackData;
- (ISSChartHistogramStackLineData *)histogramStackLineData;
- (ISSChartDashboardData *)dashboardData;
- (ISSChartDashboardData *)dashboardDataFromParser;
@end
