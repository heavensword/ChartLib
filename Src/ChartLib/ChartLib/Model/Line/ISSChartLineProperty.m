//
//  ISSChartLineProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineProperty.h"
#import "ISSChartColorUtil.h"

@implementation ISSChartLineProperty

- (void)dealloc
{
    [_points release];
    [_strokeColor release];
    [_fillColor release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _lineWidth = DEFAULT_LINE_WIDTH;
        _joinLineWidth = DEFAULT_LINE_JOIN_WIDTH;
        _radius = DEFAULT_RADIUS;
        _pointStyle = ISSChartLinePointJoinSolidCircle;
        _lineJoin = kCGLineJoinMiter;
        _lineCap = kCGLineCapSquare;
        _strokeColor = [[UIColor redColor] retain];
        _fillColor = [[UIColor whiteColor] retain];
		_strokeColor = [[ISSChartColorUtil colorWithType:rand() % NUMBER_OF_COLOR_IN_CHARTLIB] retain];
    }
    return self;
}

- (id)initWithLineProperty:(ISSChartLineProperty*)lineProperty
{
    self = [super init];
    if (self) {
        _lineWidth = lineProperty.lineWidth;
        _joinLineWidth = lineProperty.joinLineWidth;
        _radius = lineProperty.radius;
        _pointStyle = lineProperty.pointStyle;
        _lineCap = lineProperty.lineCap;
        _strokeColor = [lineProperty.strokeColor retain];
        _fillColor = [lineProperty.fillColor retain];
        _points = [[NSArray alloc] initWithArray:lineProperty.points copyItems:TRUE];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartLineProperty *copy = [[ISSChartLineProperty allocWithZone:zone] initWithLineProperty:self];
    return copy;
}

- (UIColor*)fillColor
{
    if (ISSChartLinePointJoinSolidCircle == _pointStyle||
        ISSChartLinePointJoinSolidRectangle == _pointStyle||
        ISSChartLinePointJoinSolidTriangle == _pointStyle) {
        RELEASE_SAFELY(_fillColor);
        _fillColor = [_strokeColor retain];
    }
    return _fillColor;
}
@end
