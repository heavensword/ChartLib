//
//  ISSHistogram.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramContentView.h"
#import "ISSChartHistogramAxisView.h"
#import "ISSChatGallery.h"
#import "ISSChartHistogramData.h"
#import "ISSChartBar.h"
#import "ISSChartBarProperty.h"
#import "ISSChartAxis.h"
#import "Consts.h"
#import "ISSChartBarGroup.h"
#import "NSString+ITTAdditions.h"

@interface ISSChartHistogramContentView()
{
}
@end

@implementation ISSChartHistogramContentView

#pragma mark - lifecycle

- (void)dealloc
{
    [_histogram release];
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
    for (ISSChartBarGroup *group in _histogram.barGroups) {
        for (ISSChartBar *bar in group.bars) {
            ISSChartBarProperty *property = bar.barProperty;
            CGRect frame = property.frame;
            CGContextSetStrokeColorWithColor(context, property.strokeColor.CGColor);
            CGContextSetFillColorWithColor(context, property.fillColor.CGColor);
            CGContextSetLineWidth(context, property.strokeWidth);
            
            CGContextMoveToPoint(context, CGRectGetMinX(frame), CGRectGetMinY(frame));
            CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMinY(frame));
            CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
            CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
            CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMinY(frame));
            
            if (ISSHistogramGradient == self.histogram.histogramStyle) {
                CGContextSaveGState(context);
                CGContextClip(context);
                CGPoint startPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
                CGPoint endPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
                
                CGFloat locs[2] = {0.0, 1.0};
                CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
                NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];
                [myColors addObject:(id)[property.gradientStartColor CGColor]];
                [myColors addObject:(id)[property.gradientEndColor CGColor]];
                CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, (CFArrayRef)myColors, locs);
                CGColorSpaceRelease(mySpace);
                CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
                CGGradientRelease(gradientRef);
                CGContextRestoreGState(context);
            }
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - public methods
- (void)setHistogram:(ISSChartHistogramData *)historgram
{
    NSAssert(!(historgram == nil), @"nil histogram parameter!");
    NSAssert(!(historgram.bars == nil), @"nil bars parameter of histogram!");
    
    [_histogram release];
    _histogram = nil;
    _histogram = [historgram retain];
        
    [self setNeedsDisplay];
}
@end
