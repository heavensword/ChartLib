//
//  ISSChartLineLegendUnitView.m
//  ChartLib
//
//  Created by Sword on 13-12-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartLineLegendUnitView.h"
#import "ISSChartLegend.h"
#import "ISSChartLineProperty.h"
#import "ISSChartUtil.h"

@implementation ISSChartLineLegendUnitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
    ISSChartLineProperty *lineProperty = _legend.parent;
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat textWidth = _legend.textSize.width;
    CGFloat textHeight = _legend.textSize.height;
    CGFloat radius = lineProperty.radius;
    CGFloat marginX = (viewWidth - _legend.legnedSize.width)/2;
    CGFloat marginY = (height - lineProperty.lineWidth)/2;
	
    //draw legend
    CGMutablePathRef legendPath = CGPathCreateMutable();
    CGPathMoveToPoint(legendPath, NULL, marginX, marginY);
    CGPathAddLineToPoint(legendPath, NULL, marginX + radius, marginY);
    CGPathAddLineToPoint(legendPath, NULL, marginX + 4*radius, marginY);
    CGPathMoveToPoint(legendPath, NULL, marginX, marginY);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetLineWidth(context, lineProperty.lineWidth);
    CGContextSetStrokeColorWithColor(context, lineProperty.strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, lineProperty.fillColor.CGColor);
    CGContextAddPath(context, legendPath);
    CGPathRelease(legendPath);
    CGContextDrawPath(context, kCGPathStroke);
    
    //draw join
    CGPathRef joinPath = [ISSChartUtil newPointJoinPath:CGPointMake(marginX + 2*radius, marginY) style:lineProperty.pointStyle radius:radius];
    CGContextSetLineWidth(context, lineProperty.joinLineWidth);
    CGContextAddPath(context, joinPath);
    CGPathRelease(joinPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //draw hint text
    marginX = marginX + _legend.spacing + 4*radius;
    marginY = MAX((CGRectGetHeight(self.bounds) - _legend.textSize.height)/2, 0);
    CGContextSetFillColorWithColor(context, _legend.textColor.CGColor);
    [_legend.name drawInRect:CGRectMake(marginX, marginY, textWidth, textHeight) withFont:_legend.font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
	CGContextRestoreGState(context);
}


@end
