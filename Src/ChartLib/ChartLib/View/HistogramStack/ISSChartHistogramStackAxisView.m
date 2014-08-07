//
//  ISSChartHistogramStackAxisView.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackAxisView.h"

#import "ISSChartAxis.h"
#import "ISSDashing.h"
#import "ISSChartAxisItem.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartHistogramView.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartHistogramStackView.h"

@interface ISSChartHistogramStackAxisView()
{
    
}
@end

@implementation ISSChartHistogramStackAxisView

#pragma mark - private methods


#pragma mark - public methods


#pragma mark - lifecycle

- (void)dealloc
{
    [super dealloc];
}

- (void)drawYAxis:(CGContextRef)context
{
    CGFloat width = [_containerView getDrawableAreaSize].width;
    CGFloat height = [_containerView getDrawableAreaSize].height;
    ITTDINFO(@"height:%f",height);
    NSArray *axisItems = _coordinateSystem.yAxis.axisItems;
    ISSChartAxisProperty *yAxisProperty = _coordinateSystem.yAxis.axisProperty;
    
    CGFloat marginY;
    NSInteger index;
    CGFloat valueFloat;
    
    //draw y axis
    CGContextSetStrokeColorWithColor(context, yAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, yAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, yAxisProperty.axisStyle);
    
    CGContextMoveToPoint(context, _coordinateSystem.leftMargin, _coordinateSystem.topMargin);
    CGContextAddLineToPoint(context, _coordinateSystem.leftMargin, height - _coordinateSystem.bottomMargin);
    CGContextStrokePath(context);
    
    //draw y grids
    if (self.coordinateSystem.yAxis.axisProperty.axisStyle != kDashingNone) {
        CGContextSetStrokeColorWithColor(context, yAxisProperty.gridColor.CGColor);
        CGContextBeginPath(context);
        for (ISSChartAxisItem *axisItem in axisItems) {
            CGFloat valueFloat = axisItem.value;    
            marginY = [_containerView getYAxisMarginYWithValueY:valueFloat];
            CGContextMoveToPoint(context, _coordinateSystem.leftMargin, marginY);
            CGContextAddLineToPoint(context, width - _coordinateSystem.rightMargin, marginY);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
    //draw y labels
    index = 0;
    CGContextSetFillColorWithColor(context, yAxisProperty.textColor.CGColor);
    for (ISSChartAxisItem *axisItem in axisItems) {
        valueFloat = axisItem.value;
        marginY = [_containerView getYAxisMarginYWithValueY:valueFloat];
        NSString *label = axisItem.name;
        [label drawInRect:[_containerView getYLableFrame:marginY text:label] withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        index++;
    }
}

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
    NSArray *axisItems = _coordinateSystem.viceYAxis.axisItems;
    CGContextSetFillColorWithColor(context, yAxisProperty.textColor.CGColor);
    for (ISSChartAxisItem *axisItem in axisItems) {
        valueFloat = axisItem.value;
        marginY = [_containerView getViceYAxisMarginYWithValueY:valueFloat];
        NSString *label = axisItem.name;
        textRect = [_containerView getViceYLableFrame:marginY text:label];
        [label drawInRect:textRect withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        index++;
    }
}

- (void)drawXAxis:(CGContextRef)context
{
    ISSChartAxis *xAxis = _coordinateSystem.xAxis;
    ISSChartAxisProperty *xAxisProperty = xAxis.axisProperty;
    //draw x grids
    NSInteger count;
    NSInteger index;
    CGFloat marginX;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    count = [xAxis.axisItems count];
    //draw x axis
    CGContextSetStrokeColorWithColor(context, xAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, xAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, xAxisProperty.axisStyle);
    
    CGContextMoveToPoint(context, _coordinateSystem.leftMargin, height - _coordinateSystem.bottomMargin);
    CGContextAddLineToPoint(context, width - _coordinateSystem.rightMargin, height - _coordinateSystem.bottomMargin);
    CGContextStrokePath(context);
    
    if (xAxisProperty.axisStyle != kDashingNone) {
        CGContextSetStrokeColorWithColor(context, xAxisProperty.gridColor.CGColor);
        CGContextBeginPath(context);
        for (index = 0; index < count; index++) {
            marginX = [_containerView getXAxisMarginXWithIndex:index];
            CGContextMoveToPoint(context, marginX, _coordinateSystem.topMargin);
            CGContextAddLineToPoint(context, marginX, height - _coordinateSystem.bottomMargin);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    //draw x labels
    ISSChartAxisItem *axisItem;
    CGContextSetFillColorWithColor(context, xAxisProperty.textColor.CGColor);
    for (index = 0; index < count; index++) {
        axisItem = xAxis.axisItems[index];
        NSString *label = axisItem.name;
        CGRect textFrame = [_containerView getXLableFrame:index text:label];
        CGContextSaveGState(context);
        CGPoint center = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));
        if (xAxis.rotateAngle > 0) {
            CGContextTranslateCTM(context, center.x, center.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(degreesToRadian(xAxis.rotateAngle));
            CGContextConcatCTM(context, textTransform);
            CGContextTranslateCTM(context, -center.x, -center.y);
        }
        [label drawInRect:textFrame withFont:xAxisProperty.labelFont
            lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        CGContextRestoreGState(context);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawYAxis:context];
    [self drawViceYAxis:context];
    [self drawXAxis:context];
    CGContextRestoreGState(context);
}

@end
