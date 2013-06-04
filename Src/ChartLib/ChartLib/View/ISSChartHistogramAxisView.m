//
//  ISSAxis.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramAxisView.h"
#import "ISSChartAxis.h"
#import "ISSDashing.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartHistogramContentView.h"
#import "ISSChartHistogramCoordinateSystem.h"

@interface ISSChartHistogramAxisView()
{

}
@end

@implementation ISSChartHistogramAxisView

#pragma mark - private methods


#pragma mark - public methods


#pragma mark - lifecycle

- (void)dealloc
{
    _histogramView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame coordinateSystem:(ISSChartHistogramCoordinateSystem*)coordinateSystem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coordinateSystem = coordinateSystem;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat height = CGRectGetHeight(rect);
    CGFloat width = CGRectGetWidth(rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    ISSChartAxis *xAxis = self.coordinateSystem.xAxis;
    ISSChartAxis *yAxis = self.coordinateSystem.yAxis;
    
    ISSChartAxisProperty *xAxisProperty = xAxis.axisProperty;
    ISSChartAxisProperty *yAxisProperty = yAxis.axisProperty;
    
    //draw y axis
    CGContextSetStrokeColorWithColor(context, yAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, yAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, yAxisProperty.axisStyle);
    
    CGContextMoveToPoint(context, _coordinateSystem.leftMargin, _coordinateSystem.topMargin);
    CGContextAddLineToPoint(context, _coordinateSystem.leftMargin, height - _coordinateSystem.bottomMargin);
    CGContextStrokePath(context);

    NSInteger index = 0;
    NSInteger count;
    CGFloat marginX;
    CGFloat marginY;
    CGFloat valueFloat;
    
    //draw y grids
    if (self.coordinateSystem.yAxis.axisProperty.axisStyle != kDashingNone) {
        CGContextBeginPath(context);        
        for (id valueY in yAxis.values) {
            CGFloat valueFloat = [valueY floatValue];
            marginY = [_histogramView getAxisMarginYWithValueY:valueFloat];
            CGContextMoveToPoint(context, _coordinateSystem.leftMargin, marginY);
            CGContextAddLineToPoint(context, width - _coordinateSystem.rightMargin, marginY);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);        
    }
    
    //draw y labels
    index = 0;
    for (id valueY in yAxis.values) {
        valueFloat = [valueY floatValue];
        marginY = [_histogramView getAxisMarginYWithValueY:valueFloat];
        
        CGContextMoveToPoint(context, xAxisProperty.padding, marginY);
        CGContextAddLineToPoint(context, width - _coordinateSystem.rightMargin, marginY);
        
        NSString *label = [yAxis.names objectAtIndex:index];
        [label drawInRect:[_histogramView getYLableFrame:marginY text:label] withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        index++;
    }
    
    //draw x axis
    CGContextSetStrokeColorWithColor(context, xAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, xAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, xAxisProperty.axisStyle);

//    CGContextMoveToPoint(context, _coordinateSystem.leftMargin, height - _coordinateSystem.bottomMargin);
//    CGContextAddLineToPoint(context, width - _coordinateSystem.leftMargin, height - _coordinateSystem.bottomMargin);
//    CGContextStrokePath(context);

    //draw x grids
    index = 0;
    count = [xAxis.values count];    
    if (xAxisProperty.axisStyle != kDashingNone) {
        CGContextBeginPath(context);
        for (index = 0; index < count; index++) {
            marginX = [_histogramView getAxisXMarginXWithIndex:index];
            CGContextMoveToPoint(context, marginX, _coordinateSystem.topMargin);
            CGContextAddLineToPoint(context, marginX, height - _coordinateSystem.bottomMargin);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }    
    //draw x labels
    index = 0;
    for (index = 0; index < count; index++) {
        marginX = [_histogramView getAxisXMarginXWithIndex:index];
        NSString *label = [xAxis.names objectAtIndex:index];
        CGRect textFrame = [_histogramView getXLableFrame:index text:label];
        CGContextSaveGState(context);
        CGPoint center = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));
        if (xAxis.rotateAngle > 0) {
            CGContextTranslateCTM(context, center.x, center.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(degreesToRadian(xAxis.rotateAngle));
            CGContextConcatCTM(context, textTransform);
            CGContextTranslateCTM(context, -center.x, -center.y);
        }
        [label drawInRect:textFrame withFont:yAxisProperty.labelFont
            lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        CGContextRestoreGState(context);
    }
    
    CGContextRestoreGState(context);
}
@end
