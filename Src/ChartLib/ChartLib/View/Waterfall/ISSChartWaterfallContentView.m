//
//  ISSChartWaterfallContentView.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallContentView.h"
#import "ISSChartSymbolGenerator.h"
#import "ISSChartWaterfallSymbolData.h"
#import "ISSChartUtil.h"

@interface ISSChartWaterfallContentView()
{
    void (^_completion)(void);
}

@end
@implementation ISSChartWaterfallContentView


- (void)dealloc
{
	_containerView = nil;	
	Block_release(_completion);
    [_symbolDatas release];
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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawSysboms:context];
    CGContextRestoreGState(context);
}

- (void)showDisplayAnimation:(void (^)(void))completion
{    
}

- (void)addViewAndAnimateView:(UIView *)imgView isGoUp:(BOOL)flag
{
    CGRect origniFrame = imgView.frame;
    CGRect newFrame = origniFrame;
    if (flag == YES) {
        newFrame.origin.y += newFrame.size.height;
        newFrame.size.height = 0;
    }else{
        newFrame.size.height = 0;
    }
    [imgView setFrame:newFrame];
    [self addSubview:imgView];
    
    [UIView animateWithDuration:1 animations:^{
        [imgView setFrame:origniFrame];
    } completion:^(BOOL finished) {
        if (finished && _completion) {
            _completion();
            Block_release(_completion);
            _completion = nil;
        }
    }];
}

- (void)drawSysboms:(CGContextRef)context
{
    for (ISSChartWaterfallSymbolData *symbolData in _symbolDatas) {
        [self drawSymbol:context symbol:symbolData];
    }
}

- (void)drawSymbol:(CGContextRef)context symbol:(ISSChartWaterfallSymbolData*)symbol
{
    CGContextSaveGState(context);
    CGRect frame = symbol.frame;
    CGContextSetStrokeColorWithColor(context, symbol.strokeColor.CGColor);
    CGContextSetLineWidth(context, symbol.strokeWidth);
    CGContextSetBlendMode(context, kCGBlendModeNormal);

	CGMutablePathRef borderPath = CGPathCreateMutable();
    CGFloat arrowHeight = CGRectGetWidth(frame) / 3;
    switch (symbol.symbolType) {
        case ISSChartSymbolRectangle:
            //move to left-top point
            CGPathMoveToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
            //add right-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMinY(frame));
            //add right-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
            //add left-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMaxY(frame));
            //add left-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
            break;
        case ISSChartSymbolArrowDown:
            //move to left-top point
            CGPathMoveToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
            //add right-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMinY(frame));
            //add right-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame) - arrowHeight);
            //add arrow-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMidX(frame), CGRectGetMaxY(frame));
            //add left-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMaxY(frame) - arrowHeight);
            //add left-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
            break;
        case ISSChartSymbolArrowUp:
            //move to left-top point
            CGPathMoveToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame) + arrowHeight);
            //add arrow-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMidX(frame), CGRectGetMinY(frame));
            //add right-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMinY(frame) + arrowHeight);
            //add right-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
            //add left-bottom point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMaxY(frame));
            //add left-top point
            CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame) + arrowHeight);
            break;
        default:
            break;
    }
	
	NSArray *gradientColors = symbol.gradientColors;
	NSInteger gradientColorCount = [gradientColors count];
    CGPoint startPoint = [ISSChartUtil linerGradientStartPoint:frame fillType:symbol.fillType];
    CGPoint endPoint = [ISSChartUtil linerGradientEndPoint:frame fillType:symbol.fillType];
    if ([ISSChartUtil needDrawDradient:gradientColorCount]) {
        [ISSChartUtil drawLinerGradient:context gradientColors:gradientColors clippedPath:borderPath startPoint:startPoint endPoint:endPoint];
    }
    else {
		CGContextAddPath(context, borderPath);
        CGContextSetFillColorWithColor(context, symbol.fillColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
	CGPathRelease(borderPath);
    CGContextRestoreGState(context);
}

#pragma mark - public methods
- (void)setSymbolDatas:(NSArray *)symbolDatas
{
    RELEASE_SAFELY(_symbolDatas);
    _symbolDatas = [symbolDatas retain];
    [self setNeedsDisplay];
}
@end
