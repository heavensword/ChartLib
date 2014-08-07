//
//  ISSChartLine.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartUtil.h"
#import "ISSChartColorUtil.h"

@implementation ISSChartLine

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
	[_name release];
    [_lineProperty release];
    [_values release];
    [super dealloc];
}

- (id)initWithLine:(ISSChartLine*)line
{
    self = [super init];
    if (self) {
		_name = [line.name copy];
        _lineProperty = [line.lineProperty copy];
        _values = [[NSArray alloc] initWithArray:line.values copyItems:TRUE];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartLine *copy = [[ISSChartLine allocWithZone:zone] initWithLine:self];
    return copy;
}

- (BOOL)isPointContainsPoint:(CGPoint)containerPoint comparePoint:(CGPoint)point
                  pointStyle:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius
{
    CGRect rect = [ISSChartUtil pointJointRect:containerPoint style:style radius:radius];
    BOOL contains = FALSE;
    if (CGRectGetMaxX(rect) >= point.x && point.x >= CGRectGetMinX(rect)) {
        contains = TRUE;
    }
    return contains;
}

#pragma mark - public methods
- (BOOL)isPointOnLine:(CGPoint)location
{
    BOOL found = FALSE;
    NSArray *points = self.lineProperty.points;
    for (NSValue *pointValue in points) {
        if ([self isPointContainsPoint:[pointValue CGPointValue] comparePoint:location pointStyle:_lineProperty.pointStyle radius:_lineProperty.radius]){
            ITTDINFO(@"found!");
            found = TRUE;
            break;
        }
    }
    return found;
}

- (NSInteger)findValueIndexOfLineWithLocation:(CGPoint)location
{
    CGPoint point;
    NSInteger found = NSNotFound;
    NSArray *points = self.lineProperty.points;
    NSInteger count = [points count];
    for (NSInteger i = 0; i < count; i++) {
        point = [points[i] CGPointValue];
        if ([self isPointContainsPoint:point comparePoint:location pointStyle:_lineProperty.pointStyle radius:_lineProperty.radius]) {
            found = i;
            break;
        }
    }
    return found;
}

- (CGPoint)findPointLocationWithApproximateLocation:(CGPoint)location
{
    CGPoint point;
    NSArray *points = self.lineProperty.points;    
    for (NSValue *pointValue in points) {
        point = [pointValue CGPointValue];
        if ([self isPointContainsPoint:point comparePoint:location pointStyle:_lineProperty.pointStyle radius:_lineProperty.radius]) {
            point = [pointValue CGPointValue];
            break;
        }
    }
    return point;
}

- (CGPoint)firstPoint
{
    NSAssert(nil != _lineProperty.points, @"nil points!");
    NSAssert(0 != [_lineProperty.points count], @"empty points!");
    CGPoint firstPoint = [_lineProperty.points[0] CGPointValue];
    return firstPoint;
}

@end
