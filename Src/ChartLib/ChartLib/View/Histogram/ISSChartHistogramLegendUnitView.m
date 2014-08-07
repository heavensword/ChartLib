//
//  ISSChartHistogramLegendUnitView.m
//  ChartLib
//
//  Created by Sword on 13-12-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLegendUnitView.h"
#import "ISSChartLegend.h"

@implementation ISSChartHistogramLegendUnitView

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
	CGFloat viewWidth = CGRectGetWidth(self.bounds);
	CGFloat viewHeight = CGRectGetHeight(self.bounds);
	CGFloat legendHeight = _legend.size.height;
	CGFloat legendWidth = _legend.size.width;
	CGFloat textWidth = _legend.textSize.width;
	CGFloat textHeight = _legend.textSize.height;
	
	CGFloat marginX = (viewWidth - _legend.legnedSize.width)/2;
	CGFloat marginY = (viewHeight - legendHeight)/2;
	//draw legend
	CGContextSetFillColorWithColor(context, _legend.fillColor.CGColor);
	CGContextFillRect(context, CGRectMake(marginX, marginY, legendWidth, legendHeight));
	
	//draw hint text
	marginX += legendWidth + _legend.spacing;
	marginY = MAX((CGRectGetHeight(self.bounds) - textHeight)/2, 0);
	CGContextSetFillColorWithColor(context, _legend.textColor.CGColor);
	[_legend.name drawInRect:CGRectMake(marginX, marginY, textWidth, textHeight) withFont:_legend.font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
	CGContextRestoreGState(context);
}

@end
