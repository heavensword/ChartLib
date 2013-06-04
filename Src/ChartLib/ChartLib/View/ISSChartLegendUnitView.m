//
//  ISSChartLegendUnitView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLegendUnitView.h"
#import "ISSChartLegend.h"
#import "NSString+ITTAdditions.h"

@implementation ISSChartLegendUnitView

- (void)dealloc
{
    [_legend release];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    // Drawing code
    switch (_legend.type) {
        case ISSChartLegendHistogram:
            [self drawHistogramLegend:context];
            break;
        default:
            break;
    }
    CGContextRestoreGState(context);
}

#pragma mark - private methods
- (void)drawHistogramLegend:(CGContextRef)context
{
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat legendHeight = height/2;
    CGFloat legendWidth = legendHeight*2;
    CGFloat marginY = (height - legendHeight)/2;
    //draw legend 
    CGContextSetFillColorWithColor(context, _legend.color.CGColor);
    CGContextFillRect(context, CGRectMake(0, marginY, legendWidth, legendHeight));
    
    //draw hint text
    CGFloat spcaing = 3;
    CGFloat marginX = legendWidth + spcaing;
    CGFloat textWidth = CGRectGetWidth(self.bounds) - legendWidth - spcaing;
    CGFloat textHeight = [_legend.name heightWithFont:_legend.font withLineWidth:textWidth];
    marginY = 0;
    if (textHeight < height) {
        marginY = (height - textHeight)/2;
    }
    CGContextSetFillColorWithColor(context, _legend.textColor.CGColor);
    [_legend.name drawInRect:CGRectMake(marginX, marginY, textWidth, textHeight) withFont:_legend.font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
}
@end
