//
//  ISSHistogramChartView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramLineData;
@class ISSChartHintView;
@class ISSChartHistogramBar;
@class ISSChartLine;

@interface ISSChartHistogramLineView : ISSChartView

@property (nonatomic, retain) ISSChartHistogramLineData *histogramLineData;
@property (nonatomic, copy) ISSChartHintView* (^didSelectedBarBlock)(ISSChartHistogramLineView *histogramLineView, ISSChartHistogramBar *bar, NSArray *lines, NSInteger indexOfValueOnLine, ISSChartAxisItem *xAxisItem);

@property (nonatomic, copy) void (^didTappedOnBarBlock)(ISSChartHistogramLineView *histogramLineView, ISSChartHistogramBar *bar, NSArray *lines, NSInteger indexOfValueOnLine, ISSChartAxisItem *xAxisItem);


- (id)initWithFrame:(CGRect)frame histogramLineData:(ISSChartHistogramLineData*)histogramLineData;

@end
