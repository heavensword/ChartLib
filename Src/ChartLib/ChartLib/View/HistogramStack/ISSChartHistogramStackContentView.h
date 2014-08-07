//
//  ISSChartHistogramOverlapContentView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ISSChartHistogramData;
@class ISSChartHistogramView;

@interface ISSChartHistogramStackContentView : UIView

@property (nonatomic, retain) ISSChartHistogramView *histogramView;
@property (nonatomic, retain) NSArray *barGroups;

@end
