//
//  ISSHistogramChartView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"

@class ISSChartLineData;
@class ISSChartLineView;
@class ISSChartLine;
@class ISSChartAxisItem;

@interface ISSChartLineView : ISSChartView

@property (nonatomic, retain) ISSChartLineData *lineData;

/*!
 * pan callback when finger move on the view
 * \params lineView a ISSChartLineView instance
 * \params lines line view may has multiple lines, an array of ISSChartLine
 * \params index the index of point on the line
 * \params xAxisItem current user selected axis item
 */
@property (nonatomic, copy) ISSChartHintView* (^didSelectedLinesBlock)(ISSChartLineView *lineView, NSArray *lines, NSInteger index, ISSChartAxisItem *xAxisItem);

@property (nonatomic, copy) void (^didTappedOnLinesBlock)(ISSChartLineView *lineView, NSArray *lines, NSInteger index, ISSChartAxisItem *xAxisItem);


/*!
 * init method
 * \params frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it.
 * \params lineData line view may has multiple lines, an array of ISSChartLine
 * \params index the index of point on line which list in lines parameter
 * \returns An initialized ISSChartView object or nil if the object couldn't be created
 */
- (id)initWithFrame:(CGRect)frame lineData:(ISSChartLineData*)lineData;

@end
