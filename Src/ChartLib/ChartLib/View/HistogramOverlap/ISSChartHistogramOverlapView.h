//
//  ISSChartHistogramOverlapView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramOverlapData;
@class ISSChartHintView;
@class ISSChartHistorgrameOverlapHintView;

@interface ISSChartHistogramOverlapView : ISSChartView

@property(nonatomic, retain) ISSChartHistogramOverlapData *histogramOverlapData;
@property(nonatomic, copy) ISSChartHintView * (^didSelectedBarsBlock)(ISSChartHistogramOverlapView *histogramOverlapView, NSInteger groupIndex);
@property(nonatomic, copy) void (^didTappedOnBarsBlock)(ISSChartHistogramOverlapView *histogramOverlapView, NSInteger groupIndex);


- (id)initWithFrame:(CGRect)frame histogramOverlapData:(ISSChartHistogramOverlapData*)histogramOverlapData;

@end


