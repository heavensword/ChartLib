//
//  ISSHistogram.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramData;
@class ISSChartHistogramView;

@interface ISSChartHistogramContentView : UIView

@property (nonatomic, assign) ISSChartHistogramView *histogramView;
@property (nonatomic, assign) ISSChartFillStyle histogramStyle;
@property (nonatomic, retain) NSArray *barGroups;

@end
