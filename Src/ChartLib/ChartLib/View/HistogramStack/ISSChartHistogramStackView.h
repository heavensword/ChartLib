//
//  ISSChartHistogramOverlapView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"
@class ISSChartHistogramStackData;
@class ISSChartHintView;
@class ISSChartHistorgrameOverlapHintView;

@interface ISSChartHistogramStackView : ISSChartView
@property(nonatomic, retain) ISSChartHistogramStackData *histogramStackData;
@property (nonatomic, copy) ISSChartHintView* (^didSelectedAreaPointBlock)(ISSChartHistogramStackView *,NSInteger, NSArray *);

- (id)initWithFrame:(CGRect)frame histogramStackData:(ISSChartHistogramStackData*)histogramStackData;
- (void)animationWithNewHistogramStack:(ISSChartHistogramStackData*)histogramStackData completion:(void (^)(BOOL))completion;

@end


