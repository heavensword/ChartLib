//
//  ISSChartDashboardContentView.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardContentView.h"
#import "ISSChartdashboardData.h"
#import "ISSChartGraduation.h"
#import "ISSChartGraduationProperty.h"
#import "ISSChartGraduationInterval.h"
#import "ISSChartPointer.h"
#import "ISSChartCircle.h"
#import "UIDevice+ITTAdditions.h"

@interface ISSChartDashboardContentView()
{
	UILabel         *_valueLabel;
    NSMutableArray  *_pointerLayers;
}
@end

@implementation ISSChartDashboardContentView

- (void)dealloc
{
    [_pointerLayers release];
	[_valueLabel release];
	[_dashboardData release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pointerLayers = [[NSMutableArray alloc] init];
		self.opaque = FALSE;
        // Initialization code		
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();	
	[self drawArc:context];
	[self drawIntervals:context];
	[self drawGraduations:context];
	[self drawLabels:context];
	[self drawPointers:context];
	[self drawCircle:context];
}

#pragma mark - private methods

- (void)drawArc:(CGContextRef)context
{
	CGContextSaveGState(context);
	CGPoint origin = self.dashboardData.origin;
	CGFloat radius = self.dashboardData.radius;
	CGFloat innerRadius = self.dashboardData.innerRadius;
	CGFloat startDegree = self.dashboardData.startAngle;
	CGFloat endDegree = self.dashboardData.endAngle;
	
	ISSChartGraduation *firstGraduation = [self.dashboardData.graduations firstObject];
	ISSChartGraduation *lastGraduation = [self.dashboardData.graduations lastObject];
	ISSChartGraduationProperty *firstGraduationProperty = firstGraduation.graduationProperty;
	ISSChartGraduationProperty *lastGraduationProperty = lastGraduation.graduationProperty;
	
    CGContextSetStrokeColorWithColor(context, self.dashboardData.arcLineColor.CGColor);
	CGContextSetLineWidth(context, self.dashboardData.arcLineWidth);
	
	CGFloat			blur = 4;
	CGSize          shadowOffset = CGSizeMake (0, 2);
    CGFloat         shadowColorValues[] = {0/255.0, 0/255.0, 0/255.0, 1.0};
    CGColorRef      shadowColor;
    CGColorSpaceRef shadowColorSpace;
	
    shadowColorSpace = CGColorSpaceCreateDeviceRGB ();
    shadowColor = CGColorCreate (shadowColorSpace, shadowColorValues);
	//set shadow for inner arc
    CGContextSetShadowWithColor (context, shadowOffset, blur, shadowColor);
	
	//draw inner arc and join line between out arc and inner arc
	CGContextMoveToPoint(context, firstGraduationProperty.pointOnOuterCircle.x, firstGraduationProperty.pointOnOuterCircle.y);
	CGContextAddLineToPoint(context, firstGraduationProperty.pointOnInnerCircle.x, firstGraduationProperty.pointOnInnerCircle.y);
    CGContextAddArc(context, origin.x , origin.y, innerRadius, startDegree, endDegree, 0);
	CGContextAddLineToPoint(context, lastGraduationProperty.pointOnInnerCircle.x, lastGraduationProperty.pointOnInnerCircle.y);
	CGContextAddLineToPoint(context, lastGraduationProperty.pointOnOuterCircle.x, lastGraduationProperty.pointOnOuterCircle.y);
	CGContextDrawPath(context, kCGPathStroke);
	
	//set shadow for out arc
    CGContextSetShadowWithColor (context, CGSizeMake(0, -0.1), blur, shadowColor);
	//draw outer arc
    CGContextAddArc(context, origin.x , origin.y, radius, startDegree, endDegree, 0);
	CGContextDrawPath(context, kCGPathStroke);

    CGColorRelease (shadowColor);// 13
    CGColorSpaceRelease (shadowColorSpace);
	

	CGContextRestoreGState(context);
}

- (void)drawGraduations:(CGContextRef)context
{
	CGContextSaveGState(context);
	NSArray *graduations = self.dashboardData.graduations;
	NSInteger count = [graduations count];
	ISSChartGraduation *graduation;
	ISSChartGraduationProperty *graduationProperty;
	for (NSInteger i = 0; i < count; i++) {
		graduation = graduations[i];
		graduationProperty = graduation.graduationProperty;
		
		CGContextSetLineWidth(context, graduationProperty.lineWidth);
		CGContextSetStrokeColorWithColor(context, graduationProperty.lineColor.CGColor);
		CGContextMoveToPoint(context, graduationProperty.pointOnOuterCircle.x, graduationProperty.pointOnOuterCircle.y);
		CGContextAddLineToPoint(context, graduationProperty.pointOnInnerCircle.x, graduationProperty.pointOnInnerCircle.y);
		CGContextDrawPath(context, kCGPathStroke);
	}
	CGContextRestoreGState(context);
}

- (void)drawLabels:(CGContextRef)context
{
	CGContextSaveGState(context);
	NSArray *labels = self.dashboardData.labels;
	ISSChartGraduationProperty *graduationProperty;
	for (ISSChartGraduation *graduation in labels) {
		graduationProperty = graduation.graduationProperty;
		//draw bg image
		if (graduationProperty.image) {
			[graduationProperty.image drawInRect:graduationProperty.imageFrame];
		}
		//draw text
		CGContextSetLineWidth(context, graduationProperty.lineWidth);
		CGContextSetStrokeColorWithColor(context, graduationProperty.textColor.CGColor);
		CGContextSetFillColorWithColor(context, graduationProperty.textColor.CGColor);
		[graduationProperty.label drawInRect:graduationProperty.textFrame withFont:graduationProperty.textFont lineBreakMode:NSLineBreakByTruncatingTail];
	}
	CGContextRestoreGState(context);
}

- (void)rotatePointer
{
    [self performSelector:@selector(shakeAnimation) withObject:nil afterDelay:0.3];
}

- (void)shakeAnimation
{
    NSInteger index = 0;
    ISSChartPointer *pointer;
    for (CALayer *pointerLayer in _pointerLayers) {
        pointer = _dashboardData.pointers[index];
        NSMutableArray *values = [NSMutableArray array];
        CGFloat degree = 3.0;
        CGFloat step = 0.5;
        NSInteger count = (NSInteger)degree/step;
        for(NSInteger i = 0; i < count; i++) {
            CGFloat radian = degreesToRadian(degree);
            if (i % 2) {
                radian *= -1;
            }
            [values addObject:[NSNumber numberWithFloat:pointer.degree + radian]];
            degree -= step;
        }
        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        shakeAnimation.fillMode = kCAFillModeForwards;
        shakeAnimation.duration = 0.4;
        shakeAnimation.values = values;
        shakeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        shakeAnimation.removedOnCompletion = TRUE;
        [pointerLayer addAnimation:shakeAnimation forKey:[NSString stringWithFormat:@"pointershakeanimation%d", index]];
        index++;
    }
}

- (void)updateValueLabel
{
	_valueLabel.text = self.dashboardData.valueLabel;
	return;
	[UIView animateWithDuration:0.3 animations:^{
		_valueLabel.alpha = 0.0;
	} completion:^(BOOL finished){
		if (finished) {
			[UIView animateWithDuration:0.1 animations:^{
				_valueLabel.text = self.dashboardData.valueLabel;
				_valueLabel.alpha = 1.0;
			}];
		}
	}];
}

- (void)drawPointers:(CGContextRef)context
{
    //first remove all existing pointer layers
    [_pointerLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer *subLayer = obj;
        [subLayer removeFromSuperlayer];
    }];
    
    NSInteger offsetCount = [self.dashboardData.pointers count] - [_pointerLayers count];
    if(offsetCount > 0) {
        for (NSInteger i = 0; i < offsetCount; i++) {
            CALayer *layer = [CALayer layer];
            layer.anchorPoint = CGPointMake(1.0, 0.0);
            layer.anchorPoint = CGPointMake(1.0, 0.0);
            [_pointerLayers addObject:layer];
        }
    }
    else if(offsetCount < 0) {
        offsetCount = fabsf(offsetCount);
        for (NSInteger i = 0; i < offsetCount; i++) {
            [_pointerLayers removeLastObject];
        }
    }
    CALayer *pointerLayer;
    NSInteger index = 0;
    for (ISSChartPointer *pointer in self.dashboardData.pointers) {
        pointerLayer = _pointerLayers[index];
        pointerLayer.transform = CATransform3DIdentity;
		CGRect pointerFrame = pointer.rect;
		pointerLayer.frame = pointerFrame;
		pointerLayer.position = CGPointMake(CGRectGetMaxX(pointerFrame), CGRectGetMaxY(pointerFrame));
        pointerLayer.transform = CATransform3DMakeRotation(pointer.degree, 0, 0, 1.0);
        pointerLayer.contents = (id)pointer.image.CGImage;
        [self.layer addSublayer:pointerLayer];
        index++;
    }
    [self rotatePointer];
}

- (void)drawCircle:(CGContextRef)context
{
	ISSChartCircle *circle = self.dashboardData.circle;
	CALayer *centerLayer = [CALayer layer];
	centerLayer.contents = (id)circle.image.CGImage;
	centerLayer.frame = circle.rect;
	[self.layer addSublayer:centerLayer];
	
	if (!_valueLabel) {
		_valueLabel = [[UILabel alloc] initWithFrame:circle.rect];
		_valueLabel.text = self.dashboardData.valueLabel;
		_valueLabel.textAlignment = NSTextAlignmentCenter;
		_valueLabel.font = self.dashboardData.valueTextFont;
		_valueLabel.textColor = self.dashboardData.valueTextColor;
		_valueLabel.backgroundColor = [UIColor clearColor];
		_valueLabel.minimumScaleFactor = 0.25;
		_valueLabel.adjustsFontSizeToFitWidth = TRUE;
	}
    [self addSubview:_valueLabel];
}

- (void)drawIntervals:(CGContextRef)context
{
	CGContextSaveGState(context);
	NSInteger colorCount;
	CGPoint origin = self.dashboardData.origin;
	CGFloat radius = self.dashboardData.radius;
	CGFloat innerRadius = self.dashboardData.innerRadius;
	ISSChartGraduation *startGraduation;
	ISSChartGraduation *endGraduation;
	ISSChartGraduationProperty *startGraduationProperty;
	ISSChartGraduationProperty *endGraduationProperty;
	
	CGPoint startPointOnOuterCircle;
//	CGPoint endPointOnOuterCircle;
	CGPoint startPointOnInnterCircle;
	CGPoint endPointOnInnterCircle;

	
	for (ISSChartGraduationInterval *graduationInterval in self.dashboardData.graduationIntervals) {
		CGContextSaveGState(context);
		startGraduation = graduationInterval.startGraduation;
		endGraduation = graduationInterval.endGraduation;
		startGraduationProperty = startGraduation.graduationProperty;
		endGraduationProperty = endGraduation.graduationProperty;
		
		startPointOnInnterCircle = startGraduationProperty.pointOnInnerCircle;
		startPointOnOuterCircle = startGraduationProperty.pointOnOuterCircle;
		endPointOnInnterCircle = endGraduationProperty.pointOnInnerCircle;
//		endPointOnOuterCircle = endGraduationProperty.pointOnOuterCircle;
		
		CGContextMoveToPoint(context, startPointOnInnterCircle.x, startPointOnInnterCircle.y);
		CGContextAddLineToPoint(context, startPointOnOuterCircle.x, startPointOnOuterCircle.y);
		CGContextAddArc(context, origin.x, origin.y, radius, startGraduationProperty.degree, endGraduationProperty.degree, 0);
		CGContextAddLineToPoint(context, endPointOnInnterCircle.x, endPointOnInnterCircle.y);
		CGContextAddArc(context, origin.x, origin.y, innerRadius, endGraduationProperty.degree, startGraduationProperty.degree, 1);
		
		colorCount = [graduationInterval.colors count];
		if (2 == colorCount) {
			//draw radial gradient
			CGFloat locs[2] = {0.0, 1.0};
			CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
			CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, graduationInterval.cgcolors, locs);
			CGColorSpaceRelease(mySpace);
			CGContextClip(context);
			CGContextDrawRadialGradient(context, gradientRef, origin, innerRadius, origin, radius, 0);
			CFRelease(gradientRef);
		}
		else if (3 == colorCount) {
			//draw radial gradient
			CGFloat locs[3] = {0.0, 0.3, 1.0};
			CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
			CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, graduationInterval.cgcolors, locs);
			CGColorSpaceRelease(mySpace);
			CGContextClip(context);
			CGContextDrawRadialGradient(context, gradientRef, origin, innerRadius, origin, radius, 0);
			CFRelease(gradientRef);			
		}
		else {
			UIColor *fillColor = graduationInterval.colors[0];
			CGContextSetFillColorWithColor(context, fillColor.CGColor);
			CGContextFillPath(context);
		}
		CGContextRestoreGState(context);
	}
	CGContextRestoreGState(context);
}

#pragma mark - public methods
-(void)setDashboardData:(ISSChartDashboardData *)dashboardData
{
	RELEASE_SAFELY(_dashboardData);
	_dashboardData = [dashboardData retain];
    [self setNeedsDisplay];
}

@end
