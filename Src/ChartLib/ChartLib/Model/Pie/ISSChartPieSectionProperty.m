//
//  ISSChartPieSectionProperty.m
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartPieSectionProperty.h"
#import "UIColor-Expanded.h"

@implementation ISSChartPieSectionProperty

- (void)dealloc
{
	[_fillColors release];
	[_textFont release];
    [_strokeColor release];
	[_percentageString release];
	[_valueString release];
	[_nameString release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
		_textFont = [[UIFont systemFontOfSize:14] retain];
		_textRectIntersection = FALSE;
        _strokeColor = [[UIColor clearColor] retain];
        _strokeWidth = DEFAULT_LINE_WIDTH;
		_fillColors = [@[[UIColor randomColor], [UIColor randomColor]] retain];
    }
    return self;
}

- (id)initWithPieSectionProperty:(ISSChartPieSectionProperty*)pieSectionProperty
{
    self = [super init];
    if (self) {
		_index = pieSectionProperty.index;
		_lineOriginPoint = pieSectionProperty.lineOriginPoint;
		_lineStartPoint = pieSectionProperty.lineStartPoint;
		_lineEndPoint = pieSectionProperty.lineEndPoint;
		_textRectIntersection = pieSectionProperty.textRectIntersection;
		_valueRect = pieSectionProperty.valueRect;
		_percentageRect = pieSectionProperty.percentageRect;
		_nameRect = pieSectionProperty.nameRect;
        _expand = pieSectionProperty.expand;
        _startDegree = pieSectionProperty.startDegree;
        _endDegree = pieSectionProperty.endDegree;
        _radius = pieSectionProperty.radius;
        _innerRadius = pieSectionProperty.innerRadius;
        _strokeWidth = pieSectionProperty.strokeWidth;
        _strokeColor = [pieSectionProperty.strokeColor retain];
        _fillColors = [pieSectionProperty.fillColors retain];
		_textFont = [pieSectionProperty.textFont retain];		
		_percentageString = [pieSectionProperty.percentageString copy];
		_valueString = [pieSectionProperty.valueString copy];
		_nameString = [pieSectionProperty.nameString copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartPieSectionProperty *copy = [[ISSChartPieSectionProperty allocWithZone:zone] initWithPieSectionProperty:self];
    return copy;
}

- (UIColor*)fillColor
{
	return _fillColors[0];
}

- (NSArray*)gradientColors
{
	NSMutableArray *gradientColors = [NSMutableArray array];
	for (UIColor *color in _fillColors) {
		[gradientColors addObject:(id)color.CGColor];
	}
	return gradientColors;
}
@end
