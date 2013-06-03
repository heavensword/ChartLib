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
    
    CGContextMoveToPoint(context, xAxisProperty.padding, yAxisProperty.padding);
    CGContextAddLineToPoint(context, xAxisProperty.padding, height - yAxisProperty.padding);
    CGContextStrokePath(context);

    NSInteger index = 0;
    CGFloat marginX;
    CGFloat marginY;
    CGFloat valueFloat;
    
    //draw y grids
    if (self.coordinateSystem.yAxis.axisProperty.axisStyle != kDashingNone) {
        CGContextBeginPath(context);        
        for (id valueY in yAxis.values) {
            CGFloat valueFloat = [valueY floatValue];
            marginY = [_histogramView getAxisMarginYWithValueY:valueFloat];
            CGContextMoveToPoint(context, xAxisProperty.padding, marginY);
            CGContextAddLineToPoint(context, width - xAxisProperty.padding, marginY);
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
        CGContextAddLineToPoint(context, width - xAxisProperty.padding, marginY);
        
        NSString *label = [yAxis.names objectAtIndex:index];
        [label drawInRect:[_histogramView getYLableFrame:marginY text:label] withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        index++;
    }
    
    //draw x axis
    CGContextSetStrokeColorWithColor(context, xAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, xAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, xAxisProperty.axisStyle);

    CGContextMoveToPoint(context, xAxisProperty.padding, height - yAxisProperty.padding);
    CGContextAddLineToPoint(context, width - xAxisProperty.padding, height - yAxisProperty.padding);
    CGContextStrokePath(context);

    //draw x grids
    index = 0;    
    if (xAxisProperty.axisStyle != kDashingNone) {
        CGContextBeginPath(context);
        for (id valueX in xAxis.values) {
            marginX = [_histogramView getAxisXMarginXWithIndex:index];
            ITTDINFO(@"marginX %f", marginX);            
            CGContextMoveToPoint(context, marginX, yAxisProperty.padding);
            CGContextAddLineToPoint(context, marginX, height - yAxisProperty.padding);
            index++;            
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }    
    //draw x labels
    index = 0;
    for (id valueX in xAxis.values) {
        marginX = [_histogramView getAxisXMarginXWithIndex:index];
        NSString *label = [xAxis.names objectAtIndex:index];
        CGRect textFrame = [_histogramView getXLableFrame:marginX text:label];        
        CGContextSaveGState(context);
        CGPoint point = CGPointMake(textFrame.origin.x + CGRectGetWidth(textFrame)/2,
                                    textFrame.origin.y + CGRectGetHeight(textFrame)/2);
        CGContextTranslateCTM(context, point.x, point.y);
        CGAffineTransform textTransform = CGAffineTransformMakeRotation(degreesToRadian(xAxis.rotateAngle));
        CGContextConcatCTM(context, textTransform);
        CGContextTranslateCTM(context, -point.x, -point.y);
        [label drawInRect:textFrame withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        index++;
        CGContextRestoreGState(context);
    }
    
    CGContextRestoreGState(context);
}
@end
