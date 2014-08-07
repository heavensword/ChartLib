//
//  ISSChartAxisView.m
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartAxisView.h"
#import "ISSChartAxis.h"
#import "ISSDashing.h"
#import "ISSChartAxisItem.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartView.h"

@implementation ISSChartAxisView

- (void)dealloc
{
	_containerView = nil;
    [_coordinateSystem release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = FALSE;
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame coordinateSystem:(ISSChartCoordinateSystem*)coordinateSystem
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawYAxis:context];
    [self drawXAxis:context];
    CGContextRestoreGState(context);
}

- (void)setCoordinateSystem:(ISSChartCoordinateSystem *)coordinateSystem
{
    RELEASE_SAFELY(_coordinateSystem);
    _coordinateSystem = [coordinateSystem retain];
    [self setNeedsDisplay];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)drawYAxis:(CGContextRef)context
{
	CGContextSaveGState(context);
    CGFloat height = CGRectGetHeight(self.bounds);
    NSArray *axisItems = _coordinateSystem.yAxis.axisItems;
    ISSChartAxisProperty *yAxisProperty = _coordinateSystem.yAxis.axisProperty;
    
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
	[self drawYGrids:context];
    
    //draw y labels
    index = 0;
    CGContextSetFillColorWithColor(context, yAxisProperty.textColor.CGColor);
    for (ISSChartAxisItem *axisItem in axisItems) {
        valueFloat = axisItem.value;
        NSString *label = axisItem.name;
        [label drawInRect:axisItem.textRect withFont:yAxisProperty.labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        index++;
    }
	
	//draw xaxis unit
	if (yAxisProperty.needDisplayUnit) {
		if (_coordinateSystem.yAxis.unit && [_coordinateSystem.yAxis.unit length]) {
			NSString *unit = _coordinateSystem.yAxis.unit;
			UIFont *font = yAxisProperty.labelFont;
			CGFloat textWitdth = [unit widthWithFont:font withLineHeight:CGFLOAT_MAX];
			CGFloat textHeight = [unit heightWithFont:font withLineWidth:textWitdth];
			CGRect textRect = CGRectMake(_coordinateSystem.leftMargin - textWitdth/2, _coordinateSystem.topMargin - 3 * textHeight, textWitdth, textHeight);
			[unit drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
		}
	}
	
	CGContextRestoreGState(context);
}

- (void)drawXAxis:(CGContextRef)context
{
	CGContextSaveGState(context);
    ISSChartAxis *xAxis = _coordinateSystem.xAxis;
    ISSChartAxisProperty *xAxisProperty = xAxis.axisProperty;
    //draw x grids
    NSInteger index;
	CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    //draw x axis
    CGContextSetStrokeColorWithColor(context, xAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, xAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, xAxisProperty.axisStyle);
    
	//draw x axis
    CGContextMoveToPoint(context, _coordinateSystem.leftMargin, height - _coordinateSystem.bottomMargin);
    CGContextAddLineToPoint(context, width - _coordinateSystem.rightMargin, height - _coordinateSystem.bottomMargin);
    CGContextStrokePath(context);
    
	//draw x grids
	[self drawXGrids:context];
	
    //draw x labels
	index = 0;
	NSString *label;
	CGPoint center;
	CGRect textFrame;
    ISSChartAxisItem *axisItem;
    NSArray *axisItems = xAxis.axisItems;
    CGContextSetFillColorWithColor(context, xAxisProperty.textColor.CGColor);
    for (axisItem in axisItems) {
        label = axisItem.name;
        textFrame = axisItem.textRect;
        CGContextSaveGState(context);
        if (axisItem.rotationAngle) {
			center = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(degreesToRadian(axisItem.rotationAngle));
			CGContextTranslateCTM(context, center.x, center.y);
			CGContextConcatCTM(context, textTransform);
			CGContextTranslateCTM(context, -center.x, -center.y);
        }
        [label drawInRect:textFrame withFont:xAxisProperty.labelFont
            lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        CGContextRestoreGState(context);
		index++;
    }
	
	//draw xaxis unit
	if (xAxisProperty.needDisplayUnit) {
		if (xAxis.unit && [xAxis.unit length]) {
			NSString *unit = xAxis.unit;
			UIFont *font = xAxisProperty.labelFont;
			CGFloat textWitdth = [unit widthWithFont:font withLineHeight:CGFLOAT_MAX];
			CGFloat textHeight = [unit heightWithFont:font withLineWidth:textWitdth];
			CGRect textRect = CGRectMake(width - _coordinateSystem.rightMargin, height - _coordinateSystem.bottomMargin, textWitdth, textHeight);
			[unit drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
		}
	}
	CGContextRestoreGState(context);
}

- (void)drawXGrids:(CGContextRef)context
{
	CGContextSaveGState(context);
    ISSChartAxis *xAxis = _coordinateSystem.xAxis;
    ISSChartAxisProperty *xAxisProperty = xAxis.axisProperty;
    //draw x grids
    NSInteger count;
    NSInteger index;
    CGFloat marginX;
    CGFloat height = CGRectGetHeight(self.bounds);
    count = [xAxis.axisItems count];
    //draw x grids
    CGContextSetStrokeColorWithColor(context, xAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, xAxisProperty.strokeWidth);
    ISSContextSetLineDash(context, xAxisProperty.axisStyle);
	
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
	CGContextRestoreGState(context);
}

- (void)drawYGrids:(CGContextRef)context
{
	CGContextSaveGState(context);
    CGFloat width = CGRectGetWidth(self.bounds);
    NSArray *axisItems = _coordinateSystem.yAxis.axisItems;
    ISSChartAxisProperty *yAxisProperty = _coordinateSystem.yAxis.axisProperty;
    CGFloat marginY;
	CGFloat valueFloat;
    NSInteger index = 1;
	NSInteger count = [axisItems count];
	ISSChartAxisItem *axisItem;
    //draw y axis
    CGContextSetStrokeColorWithColor(context, yAxisProperty.strokeColor.CGColor);
    CGContextSetLineWidth(context, yAxisProperty.gridWith);
    ISSContextSetLineDash(context, yAxisProperty.axisStyle);
    
    //draw y grids
    if (self.coordinateSystem.yAxis.axisProperty.axisStyle != kDashingNone) {
        CGContextSetStrokeColorWithColor(context, yAxisProperty.gridColor.CGColor);
        CGContextBeginPath(context);
        for (index = 1; index < count; index++) {
			axisItem = axisItems[index];
            valueFloat = axisItem.value;
            marginY = [_containerView getYAxisMarginYWithValueY:valueFloat];
            CGContextMoveToPoint(context, _coordinateSystem.leftMargin, marginY);
            CGContextAddLineToPoint(context, width - _coordinateSystem.rightMargin, marginY);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
	CGContextRestoreGState(context);
}

@end
