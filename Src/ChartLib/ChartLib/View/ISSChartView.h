//
//  ISSChartView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kISSChartAnimationDuration                 0.2
#define kISSChartAnimationFPS                      60.0

@class ISSChartAxis;
@class ISSChartHistogramAxisView;
@class ISSChartHistogramLegendView;
@class ISSChartHistogramCoordinateSystem;

@interface ISSChartView : UIView
{
@protected
    ISSChartHistogramAxisView *_axisView;
    ISSChartHistogramLegendView        *_lengendView;
}

@property (nonatomic, retain, readonly) ISSChartHistogramAxisView *axisView;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) CGFloat baseXMargin;
@property (nonatomic, assign) CGFloat baseYMargin;

- (CGFloat)getAxisXMarginXWithIndex:(NSInteger)index;
- (CGFloat)getAxisMarginYWithValueY:(CGFloat)valueY;

- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label;
- (CGRect)getXLableFrame:(CGFloat)marginX text:(NSString*)label;


@end
