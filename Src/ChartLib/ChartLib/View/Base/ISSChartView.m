//
//  ISSChartView.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"
#import "ISSDashing.h"
#import "ISSChartAxis.h"
#import "ISSChartHintView.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartBaseData.h"
#import "ISSChartAxisItem.h"

@interface ISSChartView()
{
	UITapGestureRecognizer	*_tapGestureRecognizer;
	UITapGestureRecognizer	*_doubleTapGestureRecognizer;
	UIPanGestureRecognizer	*_panGestureRecognizer;
}
@end

@implementation ISSChartView

- (void)dealloc
{
	ITTDINFO(@"%@ dealloc", NSStringFromClass([self class]));
	[self removeGestureRecognizer:_tapGestureRecognizer];
	[self removeGestureRecognizer:_doubleTapGestureRecognizer];
	[self removeGestureRecognizer:_panGestureRecognizer];
	[_doubleTapGestureRecognizer release];
	[_tapGestureRecognizer release];
	[_panGestureRecognizer release];
	[_chartData release];	
    [_reuseHintViewDic release];
    [_legendView release];
    [_axisView release];
    [_title release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isFirstDisplay = TRUE;
        _baseXMargin = 0;
        _baseYMargin = 0;
		self.panEnable = TRUE;
		self.doubleTapEnable = TRUE;
		self.tapEnable = TRUE;
        self.opaque = FALSE;
    }
    return self;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    return 0;
}

/*!
 * 根据Y值计算出此值所对应的Y坐标，坐标原点(0, 0)为左上角
 */
- (CGFloat)getYAxisMarginYWithValueY:(CGFloat)valueY
{
    return 0;
}

- (CGFloat)getViceYAxisMarginYWithValueY:(CGFloat)valueY
{
    return 0;    
}

- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    ISSChartCoordinateSystem *coordinateSystem = self.chartData.coordinateSystem;
    CGFloat width = coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height/2, width - 5, height);
    return frame;
}

- (CGRect)getViceYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    return CGRectZero;
}

- (CGRect)getXLableFrame:(NSInteger)index text:(NSString*)label
{
    CGFloat marginX = [self getXAxisMarginXWithIndex:index];
    CGFloat textHeight = CGFLOAT_MAX;
    UIFont *font = self.chartData.coordinateSystem.xAxis.axisProperty.labelFont;
    CGFloat textWidth = [label widthWithFont:font withLineHeight:textHeight];
    textHeight = [label heightWithFont:font withLineWidth:textWidth];
    CGFloat offsetHeight = 0;
    CGFloat radian = degreesToRadian(self.chartData.coordinateSystem.xAxis.rotateAngle);
    if (radian && radian != M_PI) {
        if (radian > M_PI) {
            radian = 2 * M_PI - radian;
        }
		offsetHeight = (textWidth / 2) * fabs(sinf(radian));
		//add x offset
//		marginX -= (textWidth / 2) * cosf(radian);
    }
    CGFloat marginY = [self getDrawableAreaSize].height + self.chartData.coordinateSystem.topMargin + offsetHeight;
    CGRect frame = CGRectMake(marginX - textWidth/2, marginY, textWidth, textHeight);
    return frame;
}

- (CGRect)getXLableFrameWithAxisIndex:(NSInteger)index item:(ISSChartAxisItem*)axisItem
{
	NSString *label = axisItem.name;
    CGFloat marginX = [self getXAxisMarginXWithIndex:index];
    CGFloat textHeight = CGFLOAT_MAX;
    UIFont *font = self.chartData.coordinateSystem.xAxis.axisProperty.labelFont;
    CGFloat textWidth = [label widthWithFont:font withLineHeight:textHeight];
    textHeight = [label heightWithFont:font withLineWidth:textWidth];
    CGFloat offsetHeight = 0;
	CGFloat radian = 0;
	if (axisItem.rotationAngle) {
		radian = degreesToRadian(axisItem.rotationAngle);
	}
	else if(self.chartData.coordinateSystem.xAxis.rotateAngle) {
		radian = degreesToRadian(self.chartData.coordinateSystem.xAxis.rotateAngle);
	}
    if (radian && radian != M_PI) {
        if (radian > M_PI) {
            radian = 2 * M_PI - radian;
        }
		offsetHeight = (textWidth / 2) * fabs(sinf(radian));
		//add x offset		
//		marginX -= (textWidth / 2) * cosf(radian);
    }
    CGFloat marginY = [self getDrawableAreaSize].height + self.chartData.coordinateSystem.topMargin + offsetHeight;
    CGRect frame = CGRectMake(marginX - textWidth/2, marginY, textWidth, textHeight);
    return frame;
}

- (void)caculateDrawableAreaSize
{
}

- (void)caculateDrawableAreaSize:(ISSChartCoordinateSystem*)coordinateSystem
{
    CGFloat leftMargin = coordinateSystem.leftMargin;
    CGFloat topMargin = coordinateSystem.topMargin;
    CGFloat rightMargin = coordinateSystem.rightMargin;
    CGFloat bottomMargin = coordinateSystem.bottomMargin;
    CGFloat verticalMarginTotal = topMargin + bottomMargin;
    CGFloat horizontalMarginTotal = leftMargin + rightMargin;
    _drawableAreaSize = CGSizeMake(CGRectGetWidth(self.bounds) - horizontalMarginTotal, CGRectGetHeight(self.bounds) - verticalMarginTotal);    
}

- (ISSChartHintView*)dequeueHintViewWithIdentifier:(NSString*)identifier
{
    NSAssert(identifier != nil, @"nil identifier!");
    NSMutableSet *hintViewsSet = _reuseHintViewDic[identifier];
    ISSChartHintView *hintView = nil;
    if (hintViewsSet) {
        hintView = [[[hintViewsSet anyObject] retain] autorelease];
		if (hintView) {
			[hintViewsSet removeObject:hintView];			
		}
    }
    return hintView;
}

- (void)recycleAllHintViews
{
    if (!_reuseHintViewDic) {
        _reuseHintViewDic = [[NSMutableDictionary alloc] init];
    }
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[ISSChartHintView class]]) {
            [self recyleHintView:(ISSChartHintView*)subview];
        }
    }
}

- (void)recyleHintView:(ISSChartHintView *)hintView
{
    NSMutableSet *hintViewsSet = _reuseHintViewDic[hintView.reuseIdentifier];
    if (!hintViewsSet) {
        hintViewsSet = [[NSMutableSet alloc] init];
        _reuseHintViewDic[hintView.reuseIdentifier] = hintViewsSet;
        [hintViewsSet release];
    }
    [hintViewsSet addObject:hintView];
    [hintView removeFromSuperview];
}

#pragma mark - public methods
- (void)displayFirstShowAnimation
{
}

- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (CGRect)getLegendFrame:(ISSChartCoordinateSystem*)coordinateSystem legendPosition:(ISSChartLegendPosition)legendPosition
{
	return [self getLegendFrame:coordinateSystem legendPosition:legendPosition maxLegendSize:CGSizeMake(DEFAULT_LEGEND_UNIT_WIDTH, DEFAULT_LEGEND_UNIT_HEIGHT)];
}

- (CGRect)getLegendFrame:(ISSChartCoordinateSystem*)coordinateSystem legendPosition:(ISSChartLegendPosition)legendPosition maxLegendSize:(CGSize)maxLegendSize
{
    CGRect frame;
    CGFloat marginX;
    CGFloat marginY;
    CGFloat leftMargin = coordinateSystem.leftMargin;
    CGFloat topMargin = coordinateSystem.topMargin;
    CGFloat bottomMargin = coordinateSystem.bottomMargin;
    CGFloat rightMargin = 120;//coordinateSystem.rightMargin;
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    switch (legendPosition) {
        case ISSChartLegendPositionTop: {
            marginY = MAX((topMargin - DEFAULT_LEGEND_UNIT_HEIGHT)/2, 0);
            frame = CGRectMake(0, marginY, viewWidth, DEFAULT_LEGEND_UNIT_HEIGHT);
            break;
        }
        case ISSChartLegendPositionBottom: {
            marginY = CGRectGetHeight(self.bounds) - bottomMargin;
            marginY += MAX((bottomMargin - DEFAULT_LEGEND_UNIT_HEIGHT)/2, 0);
            frame = CGRectMake(0, marginY, viewWidth, DEFAULT_LEGEND_UNIT_HEIGHT);
            break;
        }
        case ISSChartLegendPositionLeft: {
            marginX = MAX((leftMargin - DEFAULT_LEGEND_UNIT_WIDTH)/2, 0);
            frame = CGRectMake(marginX, 0, DEFAULT_LEGEND_UNIT_WIDTH, viewHeight);
            break;
        }
        case ISSChartLegendPositionRight: {
            marginX = MIN(CGRectGetWidth(self.bounds) - rightMargin, CGRectGetWidth(self.bounds) - maxLegendSize.width);
            marginX += MAX((rightMargin - DEFAULT_LEGEND_UNIT_WIDTH)/2, 0);
            frame = CGRectMake(marginX, 0, DEFAULT_LEGEND_UNIT_WIDTH, viewHeight);
            break;
        }
        default:
            frame = CGRectZero;
            break;
    }
    return frame;
}

- (CGSize)getXAxisTotalWidth
{
	CGSize xAxisZie = CGSizeZero;
	NSArray *axisItems = _chartData.coordinateSystem.xAxis.axisItems;
	NSInteger index = 0;
	for (ISSChartAxisItem *axisItem in axisItems) {
		CGRect textFrame = [self getXLableFrame:index text:axisItem.name];
		xAxisZie.width += CGRectGetWidth(textFrame);
		xAxisZie.height += CGRectGetHeight(textFrame);
		index++;
	}
	return xAxisZie;
}

- (BOOL)xAxisHasIntersects
{
	BOOL intersects = FALSE;
	CGSize xAxisTotalSize = [self getXAxisTotalWidth];
	CGSize drawableAreaSize = [self getDrawableAreaSize];
	if (xAxisTotalSize.width > drawableAreaSize.width) {
		intersects = TRUE;
	}
	if (!intersects) {
		NSInteger index = 0;
		NSArray *axisItems = [self.chartData.coordinateSystem.xAxis axisItems];
		CGRect previousTextRect = CGRectZero;
		ISSChartAxisItem *axisItem;
		if (axisItems && [axisItems count]) {
			axisItem = axisItems[0];
			previousTextRect = [self getXLableFrame:index text:axisItem.name];
			index++;
		}
		for (; index < [axisItems count]; index++) {
			axisItem = axisItems[0];
			CGRect currentTextRect = [self getXLableFrame:index text:axisItem.name];
			if (CGRectIntersectsRect(previousTextRect, currentTextRect)) {
				intersects = TRUE;
				break;
			}
		}
	}
	return intersects;
}

- (void)adjustXAxis
{
	NSInteger index = 0;
	ISSChartAxis *xAxis = self.chartData.coordinateSystem.xAxis;
	NSArray *axisItems = [xAxis axisItems];
	BOOL intersects = [self xAxisHasIntersects];
	for (ISSChartAxisItem *axisItem in axisItems) {
		if (xAxis.rotateAngle) {
			axisItem.rotationAngle = xAxis.rotateAngle;
		}
		else {
			if (intersects) {
				axisItem.rotationAngle = -30;
			}
		}
		axisItem.textRect = [self getXLableFrameWithAxisIndex:index item:axisItem];
		index++;
	}
}

- (void)adjustAxis
{
	[self adjustXAxis];
	[self adjustYAxis];
}

- (void)adjustYAxis
{
	CGFloat valueFloat;
	CGFloat marginY;
	ISSChartAxis *yAxis = self.chartData.coordinateSystem.yAxis;
	NSArray *axisItems = yAxis.axisItems;
    for (ISSChartAxisItem *axisItem in axisItems) {
        valueFloat = axisItem.value;
        marginY = [self getYAxisMarginYWithValueY:valueFloat];
        NSString *label = axisItem.name;
		axisItem.textRect = [self getYLableFrame:marginY text:label];
    }
}

- (void)setTapEnable:(BOOL)tapEnable
{
	_tapEnable = tapEnable;
	if (_tapEnable) {
		if (!_tapGestureRecognizer) {
			_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
			_tapGestureRecognizer.numberOfTapsRequired = 1;
			_tapGestureRecognizer.numberOfTouchesRequired = 1;
			if (_doubleTapGestureRecognizer) {
				[_tapGestureRecognizer requireGestureRecognizerToFail:_doubleTapGestureRecognizer];
			}
			[self addGestureRecognizer:_tapGestureRecognizer];
		}
	}
	else {
		[self removeGestureRecognizer:_tapGestureRecognizer];
	}
}

- (void)setDoubleTapEnable:(BOOL)doubleTapEnable
{
	_doubleTapEnable = doubleTapEnable;
	if (_doubleTapEnable) {
		if (!_doubleTapGestureRecognizer) {
			_doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
			_doubleTapGestureRecognizer.numberOfTapsRequired = 2;
			_doubleTapGestureRecognizer.numberOfTouchesRequired = 1;			
			[_tapGestureRecognizer requireGestureRecognizerToFail:_doubleTapGestureRecognizer];
			[self addGestureRecognizer:_doubleTapGestureRecognizer];
		}
	}
	else {
		[self removeGestureRecognizer:_doubleTapGestureRecognizer];
	}
}

- (void)setPanEnable:(BOOL)panEnable
{
	_panEnable = panEnable;
	if (_panEnable) {
		if (!_panGestureRecognizer) {
			_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
			[self addGestureRecognizer:_panGestureRecognizer];
		}
	}
	else {
		[self removeGestureRecognizer:_panGestureRecognizer];
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer*)gestureRecognizer
{
	ITTDINFO(@"- (void)handleSingleTap:(UITapGestureRecognizer*)gestureRecognizer");
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)gestureRecognizer
{
	ITTDINFO(@"- (void)handleDoubleTap:(UITapGestureRecognizer*)gestureRecognizer");
}

- (void)handlePan:(UITapGestureRecognizer*)gestureRecognizer
{
	ITTDINFO(@"- (void)handlePanTap:(UITapGestureRecognizer*)gestureRecognizer");
}
- (CGRect)getDrawableFrame
{
    CGRect frame = self.bounds;
    return frame;
}

@end
