//
//  ISSChartHistogramStackView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"
@class ISSChartHistogramStackLineData;
@class ISSChartHintView;
@class ISSChartHistorgrameStackHintView;

@interface ISSChartHistogramStackLineView : ISSChartView
@property(nonatomic, retain) ISSChartHistogramStackLineData *histogramStackLineData;
@property (nonatomic, copy) ISSChartHintView* (^didSelectedLinePointBlock)(ISSChartHistogramStackLineView *,NSInteger, NSArray *);

- (id)initWithFrame:(CGRect)frame histogramStackLineData:(ISSChartHistogramStackLineData*)histogramStackData;

- (void)animationWithNewHistogramStackLine:(ISSChartHistogramStackLineData*)histogramStackData completion:(void (^)(BOOL))completion;

- (CGRect)getDrawableFrame;

@end


