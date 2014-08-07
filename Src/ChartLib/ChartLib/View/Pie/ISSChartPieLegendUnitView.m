//
//  ISSChartPieLegendUnitView.m
//  ChartLib
//
//  Created by Sword on 13-11-28.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartPieLegendUnitView.h"
#import "ISSChartLegend.h"

@implementation ISSChartPieLegendUnitView


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGFloat legendHeight = _legend.size.width;
    CGFloat legendWidth = _legend.size.height;
    CGSize legendSize = _legend.legnedSize;
    
    CGFloat textWidth = _legend.textSize.width;
    CGFloat textHeight = _legend.textSize.height;
    CGFloat marginX = (CGRectGetWidth(self.bounds) - legendSize.width)/2;;
    CGFloat marginY = (viewHeight - _legend.size.height)/2;
    
    //draw legend
    CGContextSetFillColorWithColor(context, _legend.textColor.CGColor);
    CGContextFillRect(context, CGRectMake(marginX, marginY, legendWidth, legendHeight));
    
    //draw hint text
    marginX += _legend.size.width + _legend.spacing;
    marginY = MAX((viewHeight - _legend.textSize.height)/2, 0);
    CGContextSetFillColorWithColor(context, _legend.textColor.CGColor);
    [_legend.name drawInRect:CGRectMake(marginX, marginY, textWidth, textHeight) withFont:_legend.font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
	
	CGContextRestoreGState(context);
}
@end
