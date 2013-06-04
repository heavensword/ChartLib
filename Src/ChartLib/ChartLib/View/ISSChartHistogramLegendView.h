//
//  ISSLegend.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramData;

@interface ISSChartHistogramLegendView : UIView

@property (nonatomic, assign) ISSChartLegendDirection direction;
@property (nonatomic, retain) ISSChartHistogramData *histogram;

@end
