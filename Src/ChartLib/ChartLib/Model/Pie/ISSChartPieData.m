//
//  ISSChartLineData.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartPieData.h"
#import "ISSChartPieSection.h"
#import "ISSChartColorUtil.h"
#import "ISSChartLegend.h"
#import "ISSChartPieSectionProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartCircleUtil.h"

@implementation ISSChartPieData

- (void)dealloc
{
    [_sections release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _pieStyle = ISSChartFillPlain;
        _strokeWidth = DEFAULT_LINE_WIDTH;
        _radius = DEFAULT_PIE_RADIUS;
        _innerRadius = DEFAULT_PIE_INNER_RADIUS;        
        _sectionSpacing = DEFAULT_SECTION_SPACING;
        _coordinateSystem = [[ISSChartCoordinateSystem alloc] init];
    }
    return self;
}

- (id)initWithPieData:(ISSChartPieData*)pieData
{
    self = [super init];
    if (self) {
		_legendFontSize = pieData.legendFontSize;
		_origin = pieData.origin;
        _pieStyle = pieData.pieStyle;
        _radius = pieData.radius;
        _innerRadius = pieData.innerRadius;
        _legendPosition = pieData.legendPosition;
        _coordinateSystem = [pieData.coordinateSystem copy];
        _legendPosition = pieData.legendPosition;
        _legendTextArray = [pieData.legendTextArray retain];
        _legends = [[NSMutableArray alloc] initWithArray:pieData.legends copyItems:TRUE];
        _sections = [[NSArray alloc] initWithArray:pieData.sections copyItems:TRUE];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ISSChartPieData *copy = [[ISSChartPieData allocWithZone:zone] initWithPieData:self];
    return copy;
}

#pragma mark - private methods
- (void)checkPieProperty
{
    for (ISSChartPieSection *section in _sections) {
        if (!section.pieSectionProperty) {
            ISSChartPieSectionProperty *pieSectionProperty = [[ISSChartPieSectionProperty alloc] init];
            section.pieSectionProperty = pieSectionProperty;
            [pieSectionProperty release];
        }
    }
}

#pragma mark - public methods


- (void)caculatePieDegree
{
    CGFloat degree;
    _offsetStartDegree = 0;
    CGFloat startDegree = _offsetStartDegree;
    CGFloat total = [self valueTotal];
    NSInteger index = 0;
    ISSChartPieSectionProperty *pieSectionProperty;
    for (ISSChartPieSection *section in _sections) {
        pieSectionProperty = section.pieSectionProperty;
        degree = degreesToRadian((section.value/total)*360.0);
        pieSectionProperty.startDegree = startDegree;
        pieSectionProperty.endDegree = startDegree + degree;
        pieSectionProperty.radius = self.radius;
        pieSectionProperty.innerRadius = self.innerRadius;
        pieSectionProperty.index = index;		
        startDegree = pieSectionProperty.endDegree;
        index++;
    }
}

- (void)adjustRadius:(CGFloat)radius innerRadius:(CGFloat)innerRadius
{
    self.radius = radius;
    self.innerRadius = innerRadius;
    ISSChartPieSectionProperty *pieSectionProperty;
    for (ISSChartPieSection *section in _sections) {
        pieSectionProperty = section.pieSectionProperty;
        pieSectionProperty.radius = radius;
        pieSectionProperty.innerRadius = innerRadius;
        
    }
}

- (void)setSections:(NSArray *)sections
{
    NSAssert(nil != sections, @"nil sections");
    RELEASE_SAFELY(_sections);
    _sections = [sections retain];
    [self checkPieProperty];
    [self caculatePieDegree];
}

- (void)readyHintTextFrame
{
	BOOL textRectHasIntersection;
	
    NSInteger legendIndex = 0;
	
    CGFloat middleDegree;
    CGFloat textWidth;
	CGFloat valueTextWidth;
	CGFloat percentageTextWidth;
	CGFloat legendTextWidth;
    CGFloat textHeight = 30;
    CGFloat labelX;
    CGFloat labelY;
    CGFloat marginX;
    CGFloat marginY;
    CGFloat startDegree;
    CGFloat endDegree;
    CGFloat radius = self.radius;
    CGFloat total = [self valueTotal];
	CGPoint origin = self.origin;
    CGFloat lineSpcaing = 10;
    CGFloat spacing = 1;
    CGPoint lineEndPoint;
    CGPoint lineStartPoint;
    CGFloat spaceOfTexts = 6;
    NSString *value;
    NSString *percentage;
    UIFont *font;
	
	ISSChartLegend *legend;
    ISSChartPieSectionProperty *pieSectionProperty;
	
    NSArray *sections = [self sortedSections];
	
    BOOL displayFullHintMessage = [self displayFullHintMessage];
	CGRect currentTextRect;
    NSArray *legentArray = self.legends;
    for (ISSChartPieSection *pieSection in sections) {
        if (fabs(pieSection.value) > 0) {
            pieSectionProperty = pieSection.pieSectionProperty;
			font = pieSectionProperty.textFont;
            startDegree = pieSectionProperty.startDegree;
            endDegree = pieSectionProperty.endDegree;
            legend = legentArray[legendIndex];
			
            value = [NSString stringWithFormat:@"%.2f", pieSection.value];
            percentage = [NSString stringWithFormat:@"%.2f%%", (pieSection.value/total)*100];
			pieSectionProperty.nameString = legend.name;
			pieSectionProperty.percentageString = percentage;
			pieSectionProperty.valueString = value;
			
            middleDegree = (startDegree + endDegree)/2;
            valueTextWidth = [value widthWithFont:font withLineHeight:textHeight];
            percentageTextWidth = [percentage widthWithFont:font withLineHeight:textHeight];
            if (displayFullHintMessage) {
                legendTextWidth = [[legend name] widthWithFont:font withLineHeight:textHeight];
                textHeight = MAX([value heightWithFont:font withLineWidth:valueTextWidth],  [percentage heightWithFont:font withLineWidth:percentageTextWidth]);
                textWidth = percentageTextWidth + spaceOfTexts + valueTextWidth + spaceOfTexts + legendTextWidth;
            }
			else{
                textHeight = [percentage heightWithFont:font withLineWidth:percentageTextWidth];
                textWidth = percentageTextWidth;
            }
            PointPosition position = [ISSChartCircleUtil pointPosition:middleDegree];
            CGPoint pointOnCircle = [ISSChartCircleUtil pointOnCircleWithRadian:middleDegree radius:radius center:origin];
            marginX = pointOnCircle.x;
            marginY = pointOnCircle.y;
			switch (position) {
				case PointPositionRightBottom: {
					labelX = marginX + lineSpcaing;
					labelY = marginY + lineSpcaing;
					lineStartPoint = CGPointMake(labelX, labelY + textHeight + spacing);
					lineEndPoint = CGPointMake(lineStartPoint.x + textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionLeftBottom: {
					labelX = marginX - lineSpcaing - textWidth;
					labelY = marginY + lineSpcaing;
					lineStartPoint = CGPointMake(labelX + textWidth, labelY + textHeight + spacing);
					lineEndPoint = CGPointMake(lineStartPoint.x - textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionRightTop:{
					labelX = marginX + lineSpcaing;
					labelY = marginY - lineSpcaing - textHeight;
					lineStartPoint = CGPointMake(labelX, labelY + textHeight + spacing);
					lineEndPoint = CGPointMake(lineStartPoint.x + textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionLeftTop: {
					labelX = marginX - lineSpcaing - textWidth;
					labelY = marginY - lineSpcaing - textHeight;
					if (labelY < 0) {
						labelY = 0;
					}
					lineStartPoint = CGPointMake(labelX + textWidth, labelY + textHeight + spacing);
					lineEndPoint = CGPointMake(lineStartPoint.x - textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionRight:{
					labelX = marginX + lineSpcaing;
					labelY = marginY - textHeight;
					lineStartPoint = CGPointMake(labelX, labelY);
					lineEndPoint = CGPointMake(lineStartPoint.x + textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionBottom:{
					labelX = marginX + lineSpcaing;
					labelY = marginY + lineSpcaing;
					lineStartPoint = CGPointMake(labelX, labelY + textHeight);
					lineEndPoint = CGPointMake(lineStartPoint.x + textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionLeft:{
					labelX = marginX - textWidth - lineSpcaing;
					labelY = marginY - textHeight - lineSpcaing;
					lineStartPoint = CGPointMake(marginX - lineSpcaing, marginY - lineSpcaing);
					lineEndPoint = CGPointMake(lineStartPoint.x - textWidth, lineStartPoint.y);
					break;
				}
				case PointPositionTop:{
					labelX = marginX + lineSpcaing;
					labelY = marginY - textHeight - lineSpcaing;
					lineStartPoint = CGPointMake(labelX, labelY + textHeight);
					lineEndPoint = CGPointMake(lineStartPoint.x + textWidth, lineStartPoint.y);
					break;
				}
				default:
					break;
			}
			currentTextRect = CGRectMake(labelX, labelY, textWidth, textHeight);
			textRectHasIntersection = [self textRectHasIntersectionWithPrevionsTextBeforeIndex:legendIndex textRect:currentTextRect];
			pieSectionProperty.textRectIntersection = textRectHasIntersection;
			if (!textRectHasIntersection) {
				//caculate value and name text rect
				if (displayFullHintMessage) {
					pieSectionProperty.valueRect = CGRectMake(labelX + percentageTextWidth + spaceOfTexts, labelY, valueTextWidth, textHeight);
					pieSectionProperty.nameRect = CGRectMake(labelX + percentageTextWidth + 2 * spaceOfTexts + valueTextWidth, labelY, legendTextWidth, textHeight);
				}
				//caculate percentage text rect
				pieSectionProperty.percentageRect = CGRectMake(labelX, labelY , percentageTextWidth, textHeight);
			}
			pieSectionProperty.lineOriginPoint = pointOnCircle;
			pieSectionProperty.lineStartPoint = lineStartPoint;
			pieSectionProperty.lineEndPoint = lineEndPoint;
        }
        legendIndex++;
    }
}

- (NSArray*)sortedSections
{
	return [self.sections sortedArrayUsingComparator:^(id obj1, id obj2){
		ISSChartPieSection *pieSection1 = obj1;
		ISSChartPieSection *pieSection2 = obj2;
		NSComparisonResult result = NSOrderedSame;
		if (pieSection1.value > pieSection2.value) {
			result = NSOrderedAscending;
		}
		else if((pieSection1.value < pieSection2.value) ) {
			result = NSOrderedDescending;
		}
		return result;
	}];
}

- (BOOL)textRectHasIntersectionWithPrevionsTextBeforeIndex:(NSInteger)index textRect:(CGRect)textRect
{
	NSArray *sortedSections = [self sortedSections];
	NSArray *sectionsBeforeIndex = [sortedSections subarrayWithRange:NSMakeRange(0, index)];
	BOOL textRectHasIntersection = FALSE;
	ISSChartPieSectionProperty *pieSectionProperty;
	for (ISSChartPieSection *pieSection in sectionsBeforeIndex) {
		pieSectionProperty = pieSection.pieSectionProperty;
		//if current text rect intersect with previous text, break
		if (CGRectIntersectsRect(pieSectionProperty.percentageRect, textRect)||
			CGRectIntersectsRect(pieSectionProperty.valueRect, textRect)||
			CGRectIntersectsRect(pieSectionProperty.nameRect, textRect)) {
			textRectHasIntersection = TRUE;
			break;
		}
	}
	return textRectHasIntersection;
}

- (CGFloat)valueTotal
{
    CGFloat total = 0.0;
    for (ISSChartPieSection *section in _sections) {
        total += section.value;
    }
    return total;
}

- (NSMutableArray*)legends
{
    if (!_legends) {
        NSInteger count = [self.legendTextArray count];
        _legends = [[NSMutableArray alloc] initWithCapacity:count];
        ISSChartPieSection *pieSection;
        ISSChartPieSectionProperty *pieSectionProperty;
        for (NSInteger i = 0; i < count; i++) {
            pieSection = _sections[i];
            if (fabs(pieSection.value)) {
                pieSectionProperty = pieSection.pieSectionProperty;
                ISSChartLegend *legend = [[ISSChartLegend alloc] init];
                legend.name = _legendTextArray[i];
                legend.type = ISSChartLegendPie;
                legend.textColor = pieSectionProperty.fillColors[0];
                [_legends addObject:legend];
                [legend release];                
            }
        }
    }
    return _legends;
}

- (void)readyData
{
	[self readyHintTextFrame];
}

- (ISSChartPieSection*)findSelectedPieSectionWithLocation:(CGPoint)location
{
    ISSChartPieSection *foundSection = nil;
    ISSChartPieSectionProperty *pieSectionProperty;
    NSArray *sections = self.sections;
    CGFloat radius;
    CGFloat innerRadius;
    CGFloat startDegree;
    CGFloat endDegree;
    CGPoint origin = self.origin;
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

@end
