//
//  ISSChartPieView.h
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartPieData;
@class ISSChartPieSection;
@class ISSChartLegend;

@interface ISSChartPieView : ISSChartView

@property (nonatomic, retain) ISSChartPieData *pieData;
@property (nonatomic, copy) ISSChartHintView* (^didSelectSection)(ISSChartPieView *pieView, ISSChartPieSection *pieSection, ISSChartLegend *legend);

- (id)initWithFrame:(CGRect)frame pieData:(ISSChartPieData*)pieData;

- (void)animationWithPieData:(ISSChartPieData*)pieData completion:(void (^)(BOOL))completion;

@end
