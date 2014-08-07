//
//  ISSChartHistogramOverlapView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramOverlapLineData;
@class ISSChartHintView;
@class ISSChartHistorgrameOverlapHintView;

@interface ISSChartHistogramOverlapLineView : ISSChartView

@property(nonatomic, retain) ISSChartHistogramOverlapLineData *histogramOverlapLineData;
@property(nonatomic, copy) ISSChartHintView * (^didSelectedBarsBlock)(ISSChartHistogramOverlapLineView *histogramOverlapLineView, NSInteger groupIndex);
@property(nonatomic, copy) void (^didTappedBarsBlock)(ISSChartHistogramOverlapLineView *histogramOverlapLineView, NSInteger groupIndex);

- (id)initWithFrame:(CGRect)frame histogramOverlapLineData:(ISSChartHistogramOverlapLineData*)histogramOverlapData;

@end


