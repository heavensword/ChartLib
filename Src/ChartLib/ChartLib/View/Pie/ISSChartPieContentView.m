//
//  ISSChartPieContentView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/17/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartPieContentView.h"
#import "ISSChartPieData.h"
#import "ISSChartPieSection.h"
#import "ISSChartPieSectionProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartCircleUtil.h"

@interface ISSChartPieContentView()
{
    BOOL _isAnimation;
}
@end

@implementation ISSChartPieContentView

- (void)dealloc
{
	[_pieData release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = FALSE;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPercentageInfo:context];
    [self drawPie:context];
}

- (void)drawPieSection:(ISSChartPieSection *)pieSection context:(CGContextRef)context
                origin:(CGPoint)origin radius:(CGFloat)radius innerRadius:(CGFloat)innerRadius
{
    CGContextSaveGState(context);
    ISSChartPieSectionProperty *pieSectionProperty;
    CGFloat startDegree;
    CGFloat endDegree;
    pieSectionProperty = pieSection.pieSectionProperty;
    startDegree = pieSectionProperty.startDegree;
    endDegree = pieSectionProperty.endDegree;
    
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetShouldAntialias(context, true);
    CGContextSetStrokeColorWithColor(context, pieSectionProperty.strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, pieSectionProperty.fillColor.CGColor);
    CGContextSetLineWidth(context, pieSectionProperty.strokeWidth);
    
    //join arc path
	CGPoint startPointOnInnterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:startDegree radius:innerRadius center:origin];
	CGPoint startPointOnOuterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:startDegree radius:radius center:origin];
    
	CGPoint endPointOnInnterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:endDegree radius:innerRadius center:origin];
	CGPoint endPointOnOuterCircle = [ISSChartCircleUtil pointOnCircleWithRadian:endDegree radius:radius center:origin];
	
	CGContextMoveToPoint(context, startPointOnInnterCircle.x, startPointOnInnterCircle.y);
	CGContextAddLineToPoint(context, startPointOnOuterCircle.x, startPointOnOuterCircle.y);
    CGContextAddArc(context, origin.x , origin.y, radius, startDegree, endDegree, 0);
	CGContextAddLineToPoint(context, endPointOnOuterCircle.x, endPointOnOuterCircle.y);
	CGContextAddLineToPoint(context, endPointOnInnterCircle.x, endPointOnInnterCircle.y);
	CGContextAddArc(context, origin.x , origin.y, innerRadius, endDegree, startDegree, 1);
	NSArray *gradientColors = pieSectionProperty.gradientColors;
	NSInteger gradientColorCount = [gradientColors count];
	if (2 == gradientColorCount) {
		//draw radial gradient
		CGFloat locs[2] = {0.0, 1.0};
		CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, (CFArrayRef)pieSectionProperty.gradientColors, locs);
		CGColorSpaceRelease(mySpace);
		CGContextClip(context);
		CGContextDrawRadialGradient(context, gradientRef, origin, innerRadius, origin, radius, 0);
		CGGradientRelease(gradientRef);
		//draw the out of gradient
        //		CGContextMoveToPoint(context, startPointOnInnterCircle.x, startPointOnInnterCircle.y);
        //		CGContextAddLineToPoint(context, startPointOnOuterCircle.x, startPointOnOuterCircle.y);
        //		CGContextAddArc(context, origin.x , origin.y, radius, startDegree, endDegree, 0);
        //		CGContextAddLineToPoint(context, endPointOnOuterCircle.x, endPointOnOuterCircle.y);
        //		CGContextAddLineToPoint(context, endPointOnInnterCircle.x, endPointOnInnterCircle.y);
        //		CGContextAddArc(context, origin.x , origin.y, innerRadius, endDegree, startDegree, 1);
        //		CGContextDrawPath(context, kCGPathStroke);
	}
	else if (3 == gradientColorCount) {
		//draw radial gradient
		CGFloat locs[3] = {0.0, 0.5, 1.0};
		CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, (CFArrayRef)pieSectionProperty.gradientColors, locs);
		CGColorSpaceRelease(mySpace);
		CGContextClip(context);
		CGContextDrawRadialGradient(context, gradientRef, origin, innerRadius, origin, radius, 0);
		CGGradientRelease(gradientRef);
		//draw the out of gradient
        //		CGContextMoveToPoint(context, startPointOnInnterCircle.x, startPointOnInnterCircle.y);
        //		CGContextAddLineToPoint(context, startPointOnOuterCircle.x, startPointOnOuterCircle.y);
        //		CGContextAddArc(context, origin.x , origin.y, radius, startDegree, endDegree, 0);
        //		CGContextAddLineToPoint(context, endPointOnOuterCircle.x, endPointOnOuterCircle.y);
        //		CGContextAddLineToPoint(context, endPointOnInnterCircle.x, endPointOnInnterCircle.y);
        //		CGContextAddArc(context, origin.x , origin.y, innerRadius, endDegree, startDegree, 1);
        //		CGContextDrawPath(context, kCGPathStroke);
	}
	else {
		CGContextDrawPath(context, kCGPathFillStroke);
	}
    CGContextRestoreGState(context);
}

- (void)drawPie:(CGContextRef)context
{
    CGPoint origin = _pieData.origin;
    CGFloat strokeWidth = _pieData.strokeWidth;
    ISSChartPieSectionProperty *pieSectionProperpty;
    NSArray *sections = _pieData.sections;
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetAllowsAntialiasing(context, TRUE);
    for (ISSChartPieSection *pieSection in sections) {
        pieSectionProperpty = pieSection.pieSectionProperty;
        if (1 == [sections count]) {
            pieSectionProperpty.strokeColor = pieSectionProperpty.fillColor;
        }
        if (_isAnimation && pieSectionProperpty.animating) {
            [self drawPieSection:pieSection context:context origin:origin radius:pieSectionProperpty.radius innerRadius:pieSectionProperpty.innerRadius];
        }
        else {
            [self drawPieSection:pieSection context:context origin:origin radius:pieSectionProperpty.radius innerRadius:pieSectionProperpty.innerRadius];
        }
    }
}

- (void)drawPercentageInfo:(CGContextRef)context
{
    CGContextSaveGState(context);
    ISSChartCoordinateSystem *coordinateSystem = _pieData.coordinateSystem;
    NSArray *sections = _pieData.sections;
    ISSChartPieSectionProperty *pieSectionProperty;
    CGContextSetLineWidth(context, 1.0);
    for (ISSChartPieSection *pieSection in sections) {
		pieSectionProperty = pieSection.pieSectionProperty;
        if (!pieSectionProperty.textRectIntersection) {
			CGContextSetStrokeColorWithColor(context, pieSectionProperty.fillColor.CGColor);
			CGContextSetFillColorWithColor(context, pieSectionProperty.fillColor.CGColor);
			//draw percentage
			[pieSectionProperty.percentageString drawInRect:pieSectionProperty.percentageRect withFont:pieSectionProperty.textFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
			//draw value and label
			if (_pieData.displayFullHintMessage) {
				[pieSectionProperty.valueString drawInRect:pieSectionProperty.valueRect withFont:pieSectionProperty.textFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
				[pieSectionProperty.nameString drawInRect:pieSectionProperty.nameRect withFont:pieSectionProperty.textFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
				
			}
			CGContextMoveToPoint(context, pieSectionProperty.lineOriginPoint.x, pieSectionProperty.lineOriginPoint.y);
			CGContextAddLineToPoint(context, pieSectionProperty.lineStartPoint.x, pieSectionProperty.lineStartPoint.y);
			CGContextAddLineToPoint(context, pieSectionProperty.lineEndPoint.x, pieSectionProperty.lineEndPoint.y);
			CGContextDrawPath(context, kCGPathStroke);
        }
    }
    CGContextRestoreGState(context);
    coordinateSystem.rightMargin = CGRectGetWidth(self.bounds) - coordinateSystem.rightMargin;
}

- (ISSChartPieSection*)findSelectedPieSectionWithLocation:(CGPoint)location
{
    ISSChartPieSection *foundSection = nil;
    ISSChartPieSectionProperty *pieSectionProperty;
    NSArray *sections = _pieData.sections;
    CGFloat radius;
    CGFloat innerRadius;
    CGFloat startDegree;
    CGFloat endDegree;
    CGPoint origin = _pieData.origin;
    for (ISSChartPieSection *pieSection in sections) {
        pieSectionProperty = pieSection.pieSectionProperty;
        startDegree = pieSectionProperty.startDegree;
        endDegree = pieSectionProperty.endDegree;
        radius = pieSectionProperty.radius;
        innerRadius = pieSectionProperty.innerRadius;
        CGMutablePathRef sectionPath = CGPathCreateMutable();
        CGPathMoveToPoint(sectionPath, NULL, origin.x, origin.y);
        CGPathAddArc(sectionPath, NULL, origin.x, origin.y, radius, startDegree, endDegree, false);
        CGPathMoveToPoint(sectionPath, NULL, origin.x, origin.y);
        CGPathAddArc(sectionPath, NULL, origin.x, origin.y, innerRadius, startDegree, endDegree, false);
		
        if (CGPathContainsPoint(sectionPath, NULL, location, TRUE)) {
            foundSection = pieSection;
            CGPathRelease(sectionPath);
            break;
        }
        CGPathRelease(sectionPath);
    }
    return foundSection;
}

- (void)dataUpdateAnimation:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    BOOL final = FALSE;
    iteration++;
    
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    userInfo[KEY_ITERTATION] = @(iteration);
    
    CGPoint originRadiuses = [userInfo[KEY_ORIGIN_VALUE] CGPointValue];
    CGPoint newRadiuses = [userInfo[KEY_NEW_VALUE] CGPointValue];
    ISSChartPieSection *pieSection = userInfo[KEY_PIE_SECTION];
    
    CGFloat originRadius = originRadiuses.x;
    CGFloat originInnerRadius = originRadiuses.y;
    CGFloat newRadius = newRadiuses.x;
    CGFloat newInnerRadius = newRadiuses.y;
    
    CGFloat offsetRadius = newRadius - originRadius;
    CGFloat offsetInnerRadius = newInnerRadius - originInnerRadius;
    
    pieSection.pieSectionProperty.radius = originRadius + offsetRadius * progress;
    pieSection.pieSectionProperty.innerRadius = originInnerRadius + offsetInnerRadius * progress;
	
    if (final) {
        _isAnimation = FALSE;
        pieSection.pieSectionProperty.animating = FALSE;
        [timer invalidate];
        timer = nil;
    }
    [self setNeedsDisplay];
}

- (void)animationWithPieSection:(ISSChartPieSection*)originPieSection
{
    _isAnimation = TRUE;
    originPieSection.pieSectionProperty.animating = TRUE;
    CGFloat originRadius = _pieData.radius;
    CGFloat newRadius = _pieData.radius;
    CGFloat originInnerRadius = _pieData.innerRadius;
    CGFloat newInnerRadius = _pieData.innerRadius;
    CGFloat offsetRadius = (originRadius - originInnerRadius)/2;
    if (originPieSection.pieSectionProperty.expand) {
        newRadius += offsetRadius;
        newInnerRadius += offsetRadius;
    }
    else {
        originRadius += offsetRadius;
        originInnerRadius += offsetRadius;
    }
    
    CGFloat interval = 1.0/kISSChartAnimationFPS;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[KEY_ITERTATION] = @(0);
    userInfo[KEY_DURATION] = @(0.05);
    userInfo[KEY_ORIGIN_VALUE] = [NSValue valueWithCGPoint:CGPointMake(originRadius, originInnerRadius)];
    userInfo[KEY_NEW_VALUE] = [NSValue valueWithCGPoint:CGPointMake(newRadius, newInnerRadius)];
    userInfo[KEY_PIE_SECTION] = originPieSection;
    
    [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                   selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
}

#pragma mark - public methods
- (void)setPieData:(ISSChartPieData *)pieData
{
    RELEASE_SAFELY(_pieData);
    _pieData = [pieData retain];
    [self setNeedsDisplay];
}

@end
