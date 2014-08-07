//
//  ISSChartWaterfallView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-8.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//


#import "ISSChartView.h"

@class ISSChartWaterfallData;
@class ISSChartWaterfallSymbolData;
@class ISSChartHintView;

@interface ISSChartWaterfallView : ISSChartView
{
    
}

@property(nonatomic, retain)ISSChartWaterfallData *waterfallData;


@property (nonatomic, copy) ISSChartHintView* (^didSelectedSymbolBlock)(ISSChartWaterfallView *waterfallView, ISSChartWaterfallSymbolData *symbol, ISSChartAxisItem *axisItem);
@property (nonatomic, copy) void (^didTappedOnSymbolBlock)(ISSChartWaterfallView *waterfallView, ISSChartWaterfallSymbolData *symbol, ISSChartAxisItem *axisItem);

- (id)initWithFrame:(CGRect)frame waterfallData:(ISSChartWaterfallData *)waterfallData;

@end
