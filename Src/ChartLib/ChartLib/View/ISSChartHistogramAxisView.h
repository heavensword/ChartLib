//
//  ISSAxis.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"
#import "ISSChartAxisView.h"

@class ISSChartAxis;
@class ISSChartHistogramCoordinateSystem;
@class ISSChartHistogramView;

@interface ISSChartHistogramAxisView : ISSChartAxisView

@property (nonatomic, assign) ISSChartHistogramView *histogramView;
@property (nonatomic, retain) ISSChartHistogramCoordinateSystem *coordinateSystem;

- (id)initWithFrame:(CGRect)frame coordinateSystem:(ISSChartHistogramCoordinateSystem*)coordinateSystem;

@end