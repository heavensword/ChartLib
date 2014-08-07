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
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartAxis.h"
#import "ISSChartHistogramBarGroup.h"

#import "ISSChartHistogramView.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartUtil.h"

@interface ISSChartHistogramContentView()
{
    NSMutableArray *_selectedBarArray;
    CGColorRef      _coloredPatternColor;
}
@end

#define H_SIZE 3.0
#define V_SIZE 3.0

void ColoredPatternCallback(void *info, CGContextRef context)
{
    //	// Dark Blue
    //    CGFloat unit = 3.0;
    //	CGContextSetRGBFillColor(context, 29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00);
    //	CGContextFillRect(context, CGRectMake(0.0, 0.0, unit, unit));
    //	CGContextFillRect(context, CGRectMake(unit, unit, unit, unit));
    //
    //	// Light Blue
    //	CGContextSetRGBFillColor(context, 204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00);
    //	CGContextFillRect(context, CGRectMake(unit, 0.0, unit, unit));
    //	CGContextFillRect(context, CGRectMake(0.0, unit, unit, unit));
    
    CGFloat subunit = H_SIZE/3.0;
    CGRect  myRect1 = {{0,0}, {subunit, subunit}},
    myRect2 = {{subunit, 0}, {subunit, subunit}},
    myRect3 = {{2*subunit,0}, {subunit, subunit}},
    myRect4 = {{0,subunit}, {subunit, subunit}},
    myRect5 = {{subunit, subunit}, {subunit, subunit}},
    myRect6 = {{2*subunit, subunit}, {subunit, subunit}},
    myRect7 = {{0,2*subunit}, {subunit, subunit}},
    myRect8 = {{subunit, 2*subunit}, {subunit, subunit}},
    myRect9 = {{2*subunit, 2*subunit}, {subunit, subunit}};
    
    CGFloat alpha = 0.4;
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, alpha);
    CGContextFillRect (context, myRect1);
    
    CGContextSetRGBFillColor (context, RGB(230), RGB(230), RGB(230), alpha);
    CGContextFillRect (context, myRect2);
    
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, alpha);
    CGContextFillRect (context, myRect3);
    
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, alpha);
    CGContextFillRect (context, myRect4);
    
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, alpha);
    CGContextFillRect (context, myRect5);
    
    CGContextSetRGBFillColor (context, RGB(230), RGB(230), RGB(230), alpha);
    CGContextFillRect (context, myRect6);
    
    CGContextSetRGBFillColor (context, RGB(230), RGB(230), RGB(230), alpha);
    CGContextFillRect (context, myRect7);
    
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, alpha);
    CGContextFillRect (context, myRect8);
    
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, alpha);
    CGContextFillRect (context, myRect9);
}

@implementation ISSChartHistogramContentView

#pragma mark - lifecycle

- (void)dealloc
{
	_histogramView = nil;
    CGColorRelease(_coloredPatternColor);
    [_selectedBarArray release];
    [_histogramView release];
    [_barGroups release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = TRUE;
        self.opaque = FALSE;
        self.clipsToBounds = TRUE;
        self.contentMode = UIViewContentModeBottom;
        _selectedBarArray = [[NSMutableArray alloc] init];
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
    for (ISSChartHistogramBarGroup *group in _barGroups) {
        for (ISSChartHistogramBar *bar in group.bars) {
            if (CGRectIntersectsRect(rect, bar.barProperty.frame)) {
                if (bar.barProperty.selected) {
                    [self drawPatternInRect:bar.barProperty.backgroundFrame context:context bar:bar];
                }
                [self drawBar:context bar:bar];
            }
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - private methods
- (void)createPatternColorSpace
{
    CGPatternCallbacks coloredPatternCallbacks = {0, ColoredPatternCallback, NULL};
    // First we need to create a CGPatternRef that specifies the qualities of our pattern.
    CGPatternRef coloredPattern = CGPatternCreate(
                                                  NULL, // 'info' pointer for our callback
                                                  CGRectMake(0.0, 0.0, 3.0, 3.0), // the pattern coordinate space, drawing is clipped to this rectangle
                                                  CGAffineTransformIdentity, // a transform on the pattern coordinate space used before it is drawn.
                                                  3.0, 3.0, // the spacing (horizontal, vertical) of the pattern - how far to move after drawing each cell
                                                  kCGPatternTilingNoDistortion,
                                                  true, // this is a colored pattern, which means that you only specify an alpha value when drawing it
                                                  &coloredPatternCallbacks); // the callbacks for this pattern.
    
    // To draw a pattern, you need a pattern colorspace.
    // Since this is an colored pattern, the parent colorspace is NULL, indicating that it only has an alpha value.
    CGColorSpaceRef _coloredPatternColorSpace = CGColorSpaceCreatePattern(NULL);
    CGFloat alpha = 1.0;
    // Since this pattern is colored, we'll create a CGColorRef for it to make drawing it easier and more efficient.
    // From here on, the colored pattern is referenced entirely via the associated CGColorRef rather than the
    // originally created CGPatternRef.
    _coloredPatternColor = CGColorCreateWithPattern(_coloredPatternColorSpace, coloredPattern, &alpha);
    CGColorSpaceRelease(_coloredPatternColorSpace);
    CGPatternRelease(coloredPattern);
}

- (void)drawBar:(CGContextRef)context bar:(ISSChartHistogramBar *)bar
{
    CGContextSaveGState(context);
//    [self drawPatternInRect:bar.barProperty.frame context:context bar:bar];
    ISSChartHistogramBarProperty *property = bar.barProperty;
    CGRect frame = property.frame;
    CGContextSetStrokeColorWithColor(context, property.strokeColor.CGColor);
    CGContextSetLineWidth(context, property.strokeWidth);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
	
	CGMutablePathRef borderPath = CGPathCreateMutable();
	CGPathMoveToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
	CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMinY(frame));
	CGPathAddLineToPoint(borderPath, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
	CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMaxY(frame));
	CGPathAddLineToPoint(borderPath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
	
	NSArray *gradientColors = property.gradientColors;
	NSInteger gradientColorCount = [gradientColors count];
    if ([ISSChartUtil needDrawDradient:gradientColorCount]) {
        CGPoint startPoint = [ISSChartUtil linerGradientStartPoint:frame fillType:property.fillType];
        CGPoint endPoint = [ISSChartUtil linerGradientEndPoint:frame fillType:property.fillType];
        [ISSChartUtil drawLinerGradient:context gradientColors:gradientColors clippedPath:borderPath startPoint:startPoint endPoint:endPoint];
    }
    else {
		CGContextAddPath(context, borderPath);		
        CGContextSetFillColorWithColor(context, property.fillColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    if (bar.barProperty.selected) {
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillRect(context, bar.barProperty.frame);
    }
	CGPathRelease(borderPath);
    CGContextRestoreGState(context);
}

- (void)drawPatternInRect:(CGRect)rect context:(CGContextRef)context bar:(ISSChartHistogramBar *)bar
{
    if (!_coloredPatternColor) {
        [self createPatternColorSpace];
    }
    CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context, _coloredPatternColor);
	CGContextFillRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:RGB(235) green:RGB(235) blue:RGB(235) alpha:0.7].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

- (void)updateSelectedBarMaskBackground:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    ISSChartHistogramBar *bar = userInfo[KEY_BAR];
    BOOL final = FALSE;
    iteration++;
    CGRect originRect = [userInfo[KEY_ORIGIN_VALUE] CGRectValue];
    CGRect destinationRect = [userInfo[KEY_NEW_VALUE] CGRectValue];
    CGRect currentRect = originRect;
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    userInfo[KEY_ITERTATION] = @(iteration);
    CGFloat offsetHeight = progress * (CGRectGetHeight(destinationRect) - CGRectGetHeight(originRect));
    currentRect.size.height = CGRectGetHeight(originRect) + offsetHeight;
    currentRect.origin.y -= offsetHeight;
    bar.barProperty.backgroundFrame = currentRect;
    [self setNeedsDisplayInRect:currentRect];
    if (final) {
        [timer invalidate];
        timer = nil;
        void (^completionHandlerCopy)(BOOL);
        completionHandlerCopy = userInfo[KEY_COMPLETION_BLOCK];
        if (completionHandlerCopy != nil) {
            completionHandlerCopy(TRUE);
            Block_release(completionHandlerCopy);
        }
    }
}

- (void)drawSelectedBarMaskBackgroundForBar:(ISSChartHistogramBar*)bar
{
    CGRect needRedrawRect = bar.barProperty.frame;
    if (CGRectGetHeight(needRedrawRect) > 0) {
        CGFloat viewHeight = CGRectGetHeight(self.bounds);
        CGFloat newHeight = viewHeight - _histogramView.histogramData.coordinateSystem.bottomMargin;
        CGRect destinationRect = needRedrawRect;
        destinationRect.origin.y = 0;
        destinationRect.size.height = newHeight;
        if (bar.barProperty.selected) {
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = [NSValue valueWithCGRect:needRedrawRect];
            userInfo[KEY_NEW_VALUE] =  [NSValue valueWithCGRect:destinationRect];
            userInfo[KEY_BAR] = bar;
            [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                           selector:@selector(updateSelectedBarMaskBackground:) userInfo:userInfo repeats:TRUE];
        }
        else {
            [self setNeedsDisplayInRect:destinationRect];
        }
    }
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ITTDINFO(@"- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event");
    [super touchesBegan:touches withEvent:event];
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self];
        ISSChartHistogramBar *bar = [_histogramView findSelectedBarIndexWithLocatin:location];
        if (bar && bar.barProperty.needDrawSelectedForehead) {
            bar.barProperty.selected = !bar.barProperty.selected;
            if (bar.barProperty.selected) {
                if ([_selectedBarArray count] >= 2) {
                    for (ISSChartHistogramBar *histogramBar in _selectedBarArray) {
                        if (histogramBar != bar) {
                            histogramBar.barProperty.selected = FALSE;
                            [self drawSelectedBarMaskBackgroundForBar:histogramBar];
                        }
                    }
                    [_selectedBarArray removeAllObjects];
                }
                [_selectedBarArray addObject:bar];
            }
            else {
                [_selectedBarArray removeObject:bar];
            }
            [self performSelector:@selector(drawSelectedBarMaskBackgroundForBar:) withObject:bar afterDelay:0.05];
        }
    }
}

#pragma mark - public methods
- (void)setBarGroups:(NSArray *)barGroups
{
    [_selectedBarArray removeAllObjects];
    if(barGroups && [barGroups count]) {
        RELEASE_SAFELY(_barGroups);
        _barGroups = [barGroups retain];
        [self setNeedsDisplay];
    }
}
@end
