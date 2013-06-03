//
//  ISSHistogramChartView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartHistogramData;

@interface ISSChartHistogramView : ISSChartView

@property (nonatomic, retain) ISSChartHistogramData *histogram;
@property (nonatomic, copy) void (^didSelectedBarBlock)(ISSChartHistogramView*, NSInteger);
 
- (id)initWithFrame:(CGRect)frame histogram:(ISSChartHistogramData*)histogram;

- (void)animationWithNewHistogram:(ISSChartHistogramData*)historgram completion:(void (^)(BOOL))completion;

@end
