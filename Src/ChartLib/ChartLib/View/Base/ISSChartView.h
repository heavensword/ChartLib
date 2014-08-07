//
//  ISSChartView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISSChartAxis;
@class ISSChartLegendView;
@class ISSChartAxisView;
@class ISSChartHintView;
@class ISSChartCoordinateSystem;
@class ISSChartBaseData;
@class ISSChartAxisItem;

@interface ISSChartView : UIView
{
@protected
    BOOL                      _isFirstDisplay;
    CGSize                    _drawableAreaSize;
    ISSChartAxisView          *_axisView;
    ISSChartLegendView        *_legendView;
    NSMutableDictionary       *_reuseHintViewDic;
	ISSChartBaseData		  *_chartData;
}

@property (nonatomic, retain) ISSChartBaseData *chartData;
@property (nonatomic, assign) BOOL tapEnable;
@property (nonatomic, assign) BOOL doubleTapEnable;
@property (nonatomic, assign) BOOL panEnable;

@property (nonatomic, retain, readonly) ISSChartAxisView *axisView;
@property (nonatomic, retain, readonly) ISSChartLegendView *legendView;
 
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) CGFloat baseXMargin;
@property (nonatomic, assign) CGFloat baseYMargin;

/*!
 * adjust x axis
 */
- (void)adjustAxis;
- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index;
- (CGFloat)getYAxisMarginYWithValueY:(CGFloat)valueY;
- (CGFloat)getViceYAxisMarginYWithValueY:(CGFloat)valueY;

- (CGSize)getDrawableAreaSize;

- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label;
- (CGRect)getViceYLableFrame:(CGFloat)marginY text:(NSString*)label;
- (CGRect)getXLableFrame:(NSInteger)index text:(NSString*)label;
- (CGRect)getXLableFrameWithAxisIndex:(NSInteger)index item:(ISSChartAxisItem*)axisItem;
- (CGRect)getLegendFrame:(ISSChartCoordinateSystem*)coordinateSystem legendPosition:(ISSChartLegendPosition)legendPosition;
- (CGRect)getLegendFrame:(ISSChartCoordinateSystem*)coordinateSystem legendPosition:(ISSChartLegendPosition)legendPosition maxLegendSize:(CGSize)maxLegendSize;
- (void)caculateDrawableAreaSize:(ISSChartCoordinateSystem*)coordinateSystem;
- (void)caculateDrawableAreaSize;

- (ISSChartHintView*)dequeueHintViewWithIdentifier:(NSString*)identifier;

/*!
 *	Update current graph data animatedly
 * \params chartData The new chart data will be drawed
 * \params completion The block call back when animation completed
 */
- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion;
- (void)recycleAllHintViews;
/*!
 *	Display an animation when view first appear
 */
- (void)displayFirstShowAnimation;
- (void)handleSingleTap:(UITapGestureRecognizer*)gestureRecognizer;
- (void)handleDoubleTap:(UITapGestureRecognizer*)gestureRecognizer;
- (void)handlePan:(UITapGestureRecognizer*)gestureRecognizer;
- (CGRect)getDrawableFrame;

@end
