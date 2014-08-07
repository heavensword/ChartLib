//
//  ISSAxis.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLineAxisView.h"
#import "ISSChartAxis.h"
#import "ISSDashing.h"
#import "ISSChartAxisItem.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartHistogramView.h"
#import "ISSChartCoordinateSystem.h"

@interface ISSChartHistogramLineAxisView()
{

}
@end

@implementation ISSChartHistogramLineAxisView

#pragma mark - public methods


#pragma mark - lifecycle

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawYAxis:context];
    [self drawViceYAxis:context];
    [self drawXAxis:context];    
    CGContextRestoreGState(context);
}

#pragma mark - private methods
/*!
 * 因为是组合图, 所以添加个副Y轴的绘制方法
 */
- (void)drawViceYAxis:(CGContextRef)context
{
    NSInteger index;
    CGFloat marginX;
    CGFloat marginY;
    CGFloat valueFloat;
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGRect textRect;
    
    ISSChartAxisProperty *yAxisProperty = _coordinateSystem.viceYAxis.axisProperty;
    
    //draw y axis
    CGContextSetStrokeColorWithColor(context, yAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, yAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, yAxisProperty.axisStyle);
    
    marginX = viewWidth - _coordinateSystem.rightMargin;
    CGContextMoveToPoint(context, marginX, _coordinateSystem.topMargin);
    CGContextAddLineToPoint(context, marginX, viewHeight - _coordinateSystem.bottomMargin);
    CGContextStrokePath(context);
    
    //draw y labels
    index = 0;
    ISSChartAxisItem *viceAxisItem;
    NSArray *axisItems = _coordinateSystem.yAxis.axisItems;
    NSArray *viceAxisItems = _coordinateSystem.viceYAxis.axisItems;
    CGContextSetFillColorWithColor(context, yAxisProperty.textColor.CGColor);
    for (ISSChartAxisItem *axisItem in axisItems) {
        valueFloat = axisItem.value;
        viceAxisItem = viceAxisItems[index];
        marginY = [_containerView getYAxisMarginYWithValueY:valueFloat];
        NSString *label = viceAxisItem.name;
        textRect = [_containerView getViceYLableFrame:marginY text:label];
        [label drawInRect:textRect withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        index++;
    }
}

@end
