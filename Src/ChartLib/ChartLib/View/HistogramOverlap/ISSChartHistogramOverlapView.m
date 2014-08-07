//
//  ISSChartHistogramOverlapView.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapView.h"
#import "ISSChartHistogramOverlapAxisView.h"
#import "ISSChartHistogramOverlapLegendView.h"
#import "ISSChartHintView.h"
#import "ISSChartLineContentView.h"
#import "ISSChartHistogramOverlapContentView.h"

#import "ISSChartHistogramLineData.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartHistogramBarGroup.h"

#import "ISSChartHistogramData.h"
#import "ISSChartLineData.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"

#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChatGallery.h"

#import "ISSChartHistogramOverlapData.h"
#import "ISSChartHistogramOverlapView.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartHistogramOverlapHintView.h"

@interface ISSChartHistogramOverlapView()
{
    ISSChartHistogramOverlapLegendView     *_legendView;
    ISSChartHistogramOverlapContentView      *_histogramOverlapContentView;
    ISSChartLineContentView             *_lineContentView;
	
    UIView                     *_hintLineView;
    NSInteger                  _previousIndex;
}
@end

@implementation ISSChartHistogramOverlapView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
    Block_release(_didTappedOnBarsBlock);
	Block_release(_didSelectedBarsBlock);
    [_lineContentView release];
    [_legendView release];
    [_histogramOverlapData release];
    [_histogramOverlapContentView release];
    [_hintLineView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_previousIndex = NSNotFound;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame histogramOverlapData:(ISSChartHistogramOverlapData*)histogramOverlapData
{
    self = [super initWithFrame:frame];
    if (self) {
		_previousIndex = NSNotFound;
        _drawableAreaSize = self.bounds.size;
        _histogramOverlapContentView = [[ISSChartHistogramOverlapContentView alloc] initWithFrame:self.bounds];
        _histogramOverlapContentView.alpha = 0.0;
        
        _lineContentView = [[ISSChartLineContentView alloc] initWithFrame:self.bounds];
        _lineContentView.alpha = 0;
        
        _axisView = [[ISSChartHistogramOverlapAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = histogramOverlapData.coordinateSystem;
        _axisView.containerView = self;
        
        _legendView = [[ISSChartHistogramOverlapLegendView alloc] initWithFrame:CGRectZero];
        [histogramOverlapData readyData];
        self.histogramOverlapData = histogramOverlapData;
        [self addSubview:_axisView];
        [self addSubview:_histogramOverlapContentView];
        [self addSubview:_lineContentView];
        [self addSubview:_legendView];
    }
    return self;
}

- (void)setHistogramOverDataAndUpdate:(ISSChartHistogramOverlapData *)histogramOverlapData
{
    RELEASE_SAFELY(_histogramOverlapData);
    _histogramOverlapData = [histogramOverlapData retain];
    RELEASE_SAFELY(_chartData);
	_chartData = [histogramOverlapData retain];
    
    BOOL shouldAdjust = FALSE;
    if (_histogramOverlapData.legendTextArray && [_histogramOverlapData.legendTextArray count]) {
        shouldAdjust = TRUE;
    }
    [self caculateDrawableAreaSize];
    [self caculateBarSizeAndFrame];
    if (shouldAdjust) {
        _legendView.frame = [self getLegendFrame:_histogramOverlapData.coordinateSystem legendPosition:_histogramOverlapData.legendPosition];
        [self adjustContentViewFrame];
        [self adjustAxisViewFrame];
    }
	[self adjustAxis];
}

-(void)setHistogramOverlapData:(ISSChartHistogramOverlapData *)histogramOverlapData
{
	[self setHistogramOverDataAndUpdate:histogramOverlapData];
    _axisView.coordinateSystem = _histogramOverlapData.coordinateSystem;
    _histogramOverlapContentView.barGroups = [_histogramOverlapData barGroups];
    _legendView.direction = [_histogramOverlapData getLegendDirection];
    _legendView.chartData = _histogramOverlapData;
}

- (void)dataUpdateAnimation:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    BOOL final = FALSE;
    iteration++;
    
    ISSChartHistogramOverlapData *originHistogramOverlapData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartHistogramOverlapData *newHistogramOverlapData = userInfo[KEY_NEW_VALUE];
    
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    userInfo[KEY_ITERTATION] = @(iteration);
    ISSChartHistogramOverlapData *currentHistogramOverlapData = [newHistogramOverlapData copy];
    NSInteger count = 0;
    NSInteger groupCount = [[originHistogramOverlapData barGroups] count];
    for (NSInteger group = 0; group < groupCount; group++) {
        ISSChartHistogramBarGroup *oldBarGroup = [originHistogramOverlapData barGroups][group];
        ISSChartHistogramBarGroup *newBarGroup = [newHistogramOverlapData barGroups][group];
        ISSChartHistogramBarGroup *currentBarGroup = [currentHistogramOverlapData barGroups][group];
        count = [oldBarGroup.bars count];
        for (NSInteger i = 0; i < count; i++) {
            ISSChartHistogramBar *oldBar = [oldBarGroup.bars objectAtIndex:i];
            ISSChartHistogramBar *newBar = [newBarGroup.bars objectAtIndex:i];
            ISSChartHistogramBar *currentBar = [currentBarGroup.bars objectAtIndex:i];
			CGRect oldBarFrame = oldBar.barProperty.frame;
			CGRect newBarFrame = newBar.barProperty.frame;
			CGRect currentBarFrame = currentBar.barProperty.frame;
			
			currentBarFrame.origin.y = oldBarFrame.origin.y + (newBarFrame.origin.y - oldBarFrame.origin.y)*progress;
			currentBarFrame.size.height = oldBarFrame.size.height + (newBarFrame.size.height - oldBarFrame.size.height)*progress;
			currentBar.barProperty.frame = currentBarFrame;
        }
    }
    _histogramOverlapContentView.barGroups = [currentHistogramOverlapData barGroups];
    [currentHistogramOverlapData release];
    if (final) {
		self.histogramOverlapData = newHistogramOverlapData;
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

#pragma mark - private methods
- (BOOL)isPointOnBarWithX:(ISSChartHistogramBar*)bar location:(CGPoint)location
{
    BOOL intersects = FALSE;
    CGRect rect = bar.barProperty.frame;
    location.y = CGRectGetMidY(rect);
    if (CGRectContainsPoint(rect, location)) {
        intersects = TRUE;
    }
    return intersects;
}

- (ISSChartHistogramBar*)findSelectedBarIndexWithLocatin:(CGPoint)location
{
    ISSChartHistogramBar *selectedBar = nil;
    for (ISSChartHistogramBarGroup *group in [_histogramOverlapData barGroups]) {
        NSArray *bars = group.bars;
        for (ISSChartHistogramBar *bar in bars) {
            if ([self isPointOnBarWithX:bar location:location]) {
                selectedBar = bar;
                break;
            }
        }
    }
    return selectedBar;
}

#pragma mark - private methods

//---
/*
 - (void)caculatePointPosition
 {
 NSInteger index;
 CGFloat marginX;
 CGFloat marginY;
 NSValue *pointValue;
 NSMutableArray *points;
 for (ISSChartLine *line in _histogramOverlapData.lines) {
 ISSChartLineProperty *lineProperty = line.lineProperty;
 points = [[NSMutableArray alloc] init];
 index = 0;
 
 
 for (NSNumber *value in line.values) {
 CGFloat valueFloat = [value floatValue];
 marginX = [self getXAxisMarginXWithIndex:index];
 
 marginY = [self getViceYAxisMarginYWithValueY:valueFloat];
 
 ITTDINFO(@"marginY:%f",marginY);
 pointValue = [NSValue valueWithCGPoint:CGPointMake(marginX, marginY)];
 [points addObject:pointValue];
 index++;
 }
 lineProperty.points = points;
 [points release];
 }
 }
 */
- (CGRect)getDrawableFrame
{
    CGRect frame = self.bounds;
    return frame;
}

- (void)adjustContentViewFrame
{
    _histogramOverlapContentView.frame = [self getDrawableFrame];
    _lineContentView.frame = [self getDrawableFrame];
}

- (void)adjustAxisViewFrame
{
    _axisView.frame = [self getDrawableFrame];
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_histogramOverlapData.coordinateSystem];
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (CGFloat)getMarginXWithBar:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = barGroup.index * barGroup.width ;
    marginX += _histogramOverlapData.coordinateSystem.leftMargin + _histogramOverlapData.groupSpcaing/2;
    return marginX;
}

- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate ;
	if (valueY >= yAxis.baseValue) {
		rate =  (valueY - yAxis.baseValue) / yAxis.valueRange;
	}
	else {
		rate =  (yAxis.baseValue - valueY) / yAxis.valueRange;
	}
    CGFloat height = drawAreaSize.height * rate;
    return height;
}

- (CGFloat)getMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
	CGFloat valueHeightWithBaseValue = [self getHeightWithValue:valueY];
	CGFloat baseValueMarginY = [self getYAxisMarginYWithValueY:yAxis.baseValue];
	CGFloat marginY;
	if (valueY >= yAxis.baseValue) {
		marginY = baseValueMarginY - valueHeightWithBaseValue;
	}
	else {
		marginY = baseValueMarginY;
	}
    return marginY;
}

- (CGFloat)getYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueY / yAxis.valueRange - yAxis.minValue / yAxis.valueRange);
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

- (void)caculateBarSizeAndFrame
{
    NSArray *barGroups = [_histogramOverlapData barGroups];
    CGFloat barCountPerGroup = [_histogramOverlapData barCountOfPerGroup];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat groupWidth = drawableAreaSize.width / [barGroups count];
    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCountPerGroup;
    CGFloat maximumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MAXIMUM_BAR_WIDTH * barCountPerGroup;
    float factor= 0.618;
    
    if (groupWidth < minimumGroupWidth) {
        _histogramOverlapData.groupSpcaing = DEFAULT_BAR_GROUP_SPACING;
        _histogramOverlapData.barWidth = DEFAULT_MINIMUM_BAR_WIDTH;
        groupWidth = minimumGroupWidth;
    }
	else if(groupWidth > maximumGroupWidth) {
        _histogramOverlapData.groupSpcaing = groupWidth - DEFAULT_MAXIMUM_BAR_WIDTH*barCountPerGroup;
        _histogramOverlapData.barWidth = DEFAULT_MAXIMUM_BAR_WIDTH;
    }
	else {
        _histogramOverlapData.groupSpcaing = (1.0 - factor) * groupWidth;
		_histogramOverlapData.barWidth = groupWidth * factor;
    }
    for (ISSChartHistogramBarGroup *group in barGroups) {
        group.width = groupWidth;
        for (ISSChartHistogramBar *bar in group.bars) {
            ISSChartHistogramBarProperty *property = bar.barProperty;
            property.frame = [self getBarFrame:bar group:group];
            property.backgroundFrame = property.frame;
            property.backgroundFrame = property.frame;
        }
    }
}

- (CGRect)getBarFrame:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = [self getMarginXWithBar:bar group:barGroup];
    CGFloat marginY = [self getMarginYWithValueY:bar.valueY];
    CGFloat barHeight = [self getHeightWithValue:bar.valueY];
    return CGRectMake(marginX, marginY, _histogramOverlapData.barWidth, barHeight);
}

#pragma  mark - axis methods
- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = _histogramOverlapData.coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:_histogramOverlapData.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height/2, width - 5, height);
    return frame;
}


- (CGRect)getViceYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapData.coordinateSystem;
    CGFloat marginX = CGRectGetWidth(self.bounds) - coordinateSystem.rightMargin + 5;
    CGFloat width = coordinateSystem.rightMargin;
    CGFloat height = [label heightWithFont:coordinateSystem.viceYAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(marginX, marginY - height/2, width - 5, height);
    return frame;
}

- (CGRect)getXLableFrame:(NSInteger)index text:(NSString*)label
{
    CGFloat marginX = [self getXAxisMarginXWithIndex:index];
    CGFloat textHeight = CGFLOAT_MAX;
    UIFont *font = _histogramOverlapData.coordinateSystem.xAxis.axisProperty.labelFont;
    CGFloat width = [label widthWithFont:font withLineHeight:textHeight];
    textHeight = [label heightWithFont:font withLineWidth:width];
    CGFloat radian = degreesToRadian(_histogramOverlapData.coordinateSystem.xAxis.rotateAngle);
    CGFloat offsetHeight = 0;
    if (radian && radian != M_PI) {
        if (radian > M_PI) {
            radian = 2*M_PI - radian;
        }
        offsetHeight = fabsf((width * fabs(sin(radian)) - textHeight)/2);
        textHeight = width * fabs(sin(radian));
    }
    CGFloat marginY = [self getDrawableAreaSize].height + _histogramOverlapData.coordinateSystem.topMargin + offsetHeight;
    CGRect frame = CGRectMake(marginX , marginY, width, textHeight);
    return frame;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    ISSChartHistogramBarGroup *group = [_histogramOverlapData barGroups][index];
    NSInteger barCount = [group.bars count];
    NSInteger barIndex = barCount / 2;
    ISSChartHistogramBar *bar = group.bars[barIndex];
    CGFloat marginX = [self getMarginXWithBar:bar group:group];
	marginX += _histogramOverlapData.barWidth / 2;
    return marginX;
}

#pragma mark - public methods
- (void)displayFirstShowAnimation
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
		ISSChartHistogramOverlapData *newHistogramOverlapData = [_histogramOverlapData copy];
		[_histogramOverlapData adjustDataToZeroState];
		self.histogramOverlapData = _histogramOverlapData;
		_histogramOverlapContentView.alpha = 1.0;
		[self animationWithData:newHistogramOverlapData completion:^(BOOL finished){
			if (finished) {
				self.userInteractionEnabled = TRUE;
                _isFirstDisplay = FALSE;
			}
		}];
		[newHistogramOverlapData release];
    }	
}

- (void)displayFirstShowAnimationWithCompletion:(void (^)(BOOL))completion
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
        
        CGRect originFrame = _histogramOverlapContentView.frame;
        CGRect currentFrame = originFrame;
        currentFrame.size.height = 2*_histogramOverlapData.coordinateSystem.bottomMargin;
        currentFrame.origin.y = CGRectGetMaxY(originFrame) - 2*_histogramOverlapData.coordinateSystem.bottomMargin;
        _histogramOverlapContentView.frame = currentFrame;
        
        CGRect lineOriginFrame = _lineContentView.frame;
        currentFrame = lineOriginFrame;
        currentFrame.size.width = _histogramOverlapData.coordinateSystem.leftMargin;
        _lineContentView.frame = currentFrame;
        
        _histogramOverlapContentView.alpha = 1.0;
        _lineContentView.alpha = 1.0;
        
        [UIView animateWithDuration:kISSChartFirstAnimationDuration animations:^{
            _histogramOverlapContentView.frame = originFrame;
            _lineContentView.frame = lineOriginFrame;
        } completion:^(BOOL finished){
            if (finished) {
                self.userInteractionEnabled = TRUE;
				if (completion) {
					completion(TRUE);
				}
                _isFirstDisplay = FALSE;
            }
        }];
    }
}

- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    if (chartData) {
        NSAssert([chartData isKindOfClass:[ISSChartHistogramOverlapData class]], @"chart data is not pie date format!");
		[chartData readyData];
        [self animationWithNewHistogramOverlap:chartData completion:completion];
    }
}

- (void)animationWithNewHistogramOverlap:(ISSChartHistogramOverlapData*)histogramOverlapData completion:(void (^)(BOOL))completion
{
    if (histogramOverlapData && _histogramOverlapData != histogramOverlapData) {
        
        if ([[_histogramOverlapData barGroups] count] != [[histogramOverlapData barGroups] count]) {
            self.histogramOverlapData = histogramOverlapData;
            _histogramOverlapContentView.alpha = 0.0;
            _lineContentView.alpha = 0.0;
            _isFirstDisplay = TRUE;
            [self displayFirstShowAnimationWithCompletion:completion];
        }
        else {
			ISSChartHistogramOverlapData *originHistogramOverData = [_histogramOverlapData copy];
			[self setHistogramOverDataAndUpdate:histogramOverlapData];
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = originHistogramOverData;
            userInfo[KEY_NEW_VALUE] = histogramOverlapData;
			[originHistogramOverData release];
            if (nil != completion) {
                void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
                userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
            }
            [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                           selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
        }
    }
}

#pragma mark - hint view

- (float)getColumnWidth
{
    return  _drawableAreaSize.width / self.histogramOverlapData.coordinateSystem.xAxis.axisItems.count;
}

- (CGRect)getHintViewFrame:(CGRect)frame location:(CGPoint)location
{
    frame.origin.x = location.x + 15;
    frame.origin.y = location.y - CGRectGetHeight(frame)/2;
    return frame;
}

- (void)showHintView:(ISSChartHintView*)hintView line:(ISSChartLine*)line location:(CGPoint)location
{
    if (hintView && line) {
        CGRect frame = hintView.frame;
        hintView.frame = [self getHintViewFrame:frame location:location];
        [self addSubview:hintView];
        [hintView show];
    }
}

- (void)showHintLineView:(BOOL)show
{
    CGFloat alpha = 0.0;
    if (show) {
        if (!_hintLineView) {
            ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapData.coordinateSystem;
            CGRect frame = CGRectMake(0, coordinateSystem.topMargin, 1.0, CGRectGetHeight(self.bounds) - coordinateSystem.topMargin - coordinateSystem.bottomMargin);
            _hintLineView = [[UIView alloc] initWithFrame:frame];
            _hintLineView.backgroundColor = RGBCOLOR(190, 190, 190);
            _hintLineView.alpha = 0.0;
            [self addSubview:_hintLineView];
        }
        [self bringSubviewToFront:_hintLineView];
        alpha = 1.0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _hintLineView.alpha = alpha;
    }];
}

- (void)updateHintLineViewFrame:(CGPoint)location
{
    CGPoint center = _hintLineView.center;
    center.x = location.x;
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _histogramOverlapData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _histogramOverlapData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)showHintView:(ISSChartHintView*)hintView bar:(ISSChartHistogramBar*)bar
{
    if (hintView && bar) {
        CGRect frame = bar.barProperty.frame;
        CGRect hintFrame = hintView.frame;
        hintFrame.origin.x = frame.origin.x + CGRectGetWidth(frame);
        hintFrame.origin.y = frame.origin.y - 18;
        hintView.frame = hintFrame;
        [self addSubview:hintView];
        [hintView show];
    }
}

- (void)adjustHintViewPosition:(ISSChartHintView*)hintView offset:(CGSize)offset
{
    ISSChartHistogramOverlapHintView *histogramHintView = (ISSChartHistogramOverlapHintView*)hintView;
	histogramHintView.imageView.transform = CGAffineTransformIdentity;
    if (CGRectGetMaxX(hintView.frame) >= CGRectGetWidth(self.bounds)) {
        histogramHintView.imageView.transform = CGAffineTransformScale(histogramHintView.imageView.transform, -1, 1);
        histogramHintView.right = CGRectGetMinX(hintView.frame) - offset.width;
    }
    else {
    }
}

- (void)handleHintViewOnLocation:(CGPoint)location
{
	ISSChartHistogramBar *bar = [self findSelectedBarIndexWithLocatin:location];
	if (bar) {
		NSInteger groupIndex = bar.groupIndex;
		if(NSNotFound == _previousIndex || _previousIndex != groupIndex) {
			[self recycleAllHintViews];
			if (_didSelectedBarsBlock) {
				_previousIndex = groupIndex;
				ISSChartHistogramBarGroup *group = [_histogramOverlapData barGroups][groupIndex];
				ISSChartHintView *hintView = _didSelectedBarsBlock(self, groupIndex);
				if (hintView) {
					ISSChartHistogramBar *bar = group.bars[0];
					[self showHintView:hintView bar:bar];
					[self adjustHintViewPosition:hintView offset:bar.barProperty.frame.size];
				}
			}
		}
	}
}

#pragma mark - gesture
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
	ISSChartHistogramBar *bar = [self findSelectedBarIndexWithLocatin:location];
	if (bar) {
		NSInteger groupIndex = bar.groupIndex;
			if (_didTappedOnBarsBlock) {
                _didTappedOnBarsBlock(self, groupIndex);
			}
    }
}

- (void)handlePan:(UITapGestureRecognizer*)gestureRecognizer
{
	UIGestureRecognizerState state = gestureRecognizer.state;
	CGPoint location = [gestureRecognizer locationInView:self];
	switch (state) {
		case UIGestureRecognizerStateBegan:
			[self showHintLineView:TRUE];
			[self updateHintLineViewFrame:location];
			[self handleHintViewOnLocation:location];
			break;
		case UIGestureRecognizerStateChanged:
			[self updateHintLineViewFrame:location];
			[self handleHintViewOnLocation:location];
			break;
		case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled:
			_previousIndex = NSNotFound;
			[self showHintLineView:FALSE];
			[self recycleAllHintViews];
			break;
		default:
			break;
	}
}

@end

