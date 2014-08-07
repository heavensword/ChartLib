//
//  ISSHistogramChartView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramData;
@class ISSChartHintView;
@class ISSChartHistogramBar;
@class ISSChartAxisItem;

@interface ISSChartHistogramView : ISSChartView

@property (nonatomic, assign) BOOL shouldShowHintLine;
@property (nonatomic, retain) ISSChartHistogramData *histogramData;
@property (nonatomic, copy) ISSChartHintView* (^didSelectedBarBlock)(ISSChartHistogramView *histogramView, ISSChartHistogramBar *bar, ISSChartAxisItem *xAxisItem);
@property (nonatomic, copy) void (^didTappedOnBarBlock)(ISSChartHistogramView *histogramView, ISSChartHistogramBar *bar, ISSChartAxisItem *xAxisItem);


- (ISSChartHistogramBar*)findSelectedBarIndexWithLocatin:(CGPoint)location;
- (ISSChartHistogramBar*)findBarIndexWithLocatin:(CGPoint)location;

- (id)initWithFrame:(CGRect)frame histogram:(ISSChartHistogramData*)histogram;

- (void)filterVisiableAreaByValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;
- (void)selectedBar:(ISSChartHistogramBar*)bar;
- (void)deselectedBar:(ISSChartHistogramBar*)bar;
- (void)resetFilter;

@end
