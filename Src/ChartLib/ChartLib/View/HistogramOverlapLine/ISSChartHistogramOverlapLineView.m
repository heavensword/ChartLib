//
//  ISSChartHistogramOverlapView.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapLineView.h"
#import "ISSChartHistogramOverlapAxisView.h"
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



#import "ISSChartHistogramOverlapLineData.h"
#import "ISSChartHistogramOverlapView.h"
#import "ISSChartHistogramOverlapLineLegendView.h"
#import "ISSChartHistogramOverlapLineHintView.h"
#import "ISSChartHintTextProperty.h"


@interface ISSChartHistogramOverlapLineView()
{
    ISSChartHistogramOverlapContentView     *_histogramOverlapContentView;
    ISSChartLineContentView					*_lineContentView;
    UIView									*_hintLineView;
    NSInteger								_previousIndex;
}
@end

@implementation ISSChartHistogramOverlapLineView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
    Block_release(_didTappedBarsBlock);
    Block_release(_didSelectedBarsBlock);
    [_lineContentView release];
    [_histogramOverlapLineData release];
    [_histogramOverlapContentView release];
    [_hintLineView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame histogramOverlapLineData:(ISSChartHistogramOverlapLineData*)histogramOverlapLineData
{
    self = [super initWithFrame:frame];
    if (self) {
        _drawableAreaSize = self.bounds.size;
        _histogramOverlapContentView = [[ISSChartHistogramOverlapContentView alloc] initWithFrame:self.bounds];
        _histogramOverlapContentView.alpha = 0.0;
        
        _lineContentView = [[ISSChartLineContentView alloc] initWithFrame:self.bounds];
        _lineContentView.alpha = 0;
        
        _axisView = [[ISSChartHistogramOverlapAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = histogramOverlapLineData.coordinateSystem;
        _axisView.containerView = self;
        
        _legendView = [[ISSChartHistogramOverlapLineLegendView alloc] initWithFrame:CGRectZero];
		
		[histogramOverlapLineData readyData];
        self.histogramOverlapLineData = histogramOverlapLineData;
        [self addSubview:_axisView];
        [self addSubview:_histogramOverlapContentView];
        [self addSubview:_lineContentView];
        [self addSubview:_legendView];
    }
    return self;
}

- (void)setHistogramOverlapLineDataAndUpdate:(ISSChartHistogramOverlapLineData *)histogramOverlapLineData
{
    RELEASE_SAFELY(_histogramOverlapLineData);
    _histogramOverlapLineData = [histogramOverlapLineData retain];
    RELEASE_SAFELY(_chartData);
	_chartData = [histogramOverlapLineData retain];
	
    BOOL shouldAdjust = FALSE;
    if (_histogramOverlapLineData.legendTextArray && [_histogramOverlapLineData.legendTextArray count]) {
        shouldAdjust = TRUE;
    }
    [self caculateDrawableAreaSize];
    [self caculateBarSizeAndFrame];
    [self caculatePointPosition];
    if (shouldAdjust) {
        _legendView.frame = [self getLegendFrame:_histogramOverlapLineData.coordinateSystem legendPosition:_histogramOverlapLineData.legendPosition];
        [self adjustContentViewFrame];
        [self adjustAxisViewFrame];
    }
	[self adjustAxis];
}

-(void)setHistogramOverlapLineData:(ISSChartHistogramOverlapLineData *)histogramOverlapData
{
	[self setHistogramOverlapLineDataAndUpdate:histogramOverlapData];
    _axisView.coordinateSystem = _histogramOverlapLineData.coordinateSystem;
    _histogramOverlapContentView.barGroups = [_histogramOverlapLineData barGroups];
    _lineContentView.lines = _histogramOverlapLineData.lines;
    _legendView.direction = [_histogramOverlapLineData getLegendDirection];
    _legendView.chartData = _histogramOverlapLineData;
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
	
    ISSChartHistogramOverlapLineData *originHistogramOverlapLineData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartHistogramOverlapLineData *newHistogramOverlapLineData = userInfo[KEY_NEW_VALUE];
    ISSChartHistogramOverlapLineData *currentHistogramOverlapLineData = [newHistogramOverlapLineData copy];
	
    NSInteger count = 0;
    NSInteger groupCount = [[originHistogramOverlapLineData barGroups] count];
    for (NSInteger group = 0; group < groupCount; group++) {
        ISSChartHistogramBarGroup *oldBarGroup = [originHistogramOverlapLineData barGroups][group];
        ISSChartHistogramBarGroup *newBarGroup = [newHistogramOverlapLineData barGroups][group];
        ISSChartHistogramBarGroup *currentBarGroup = [currentHistogramOverlapLineData barGroups][group];
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
	
    CGPoint oldValue;
    CGPoint newValue;
    CGPoint currentValue;
    CGFloat offSetValueY;
    NSInteger lineCount = [newHistogramOverlapLineData.lines count];
    for (NSInteger i = 0; i < lineCount; i++) {
        ISSChartLine *oldLine = originHistogramOverlapLineData.lines[i];
        ISSChartLine *newLine = newHistogramOverlapLineData.lines[i];
        ISSChartLine *currentLine = currentHistogramOverlapLineData.lines[i];
        ISSChartLineProperty *oldLineProperty = oldLine.lineProperty;
        ISSChartLineProperty *newLineProperty = newLine.lineProperty;
        ISSChartLineProperty *currentLineProperty = currentLine.lineProperty;
        count = [oldLine.lineProperty.points count];
        NSMutableArray *currentPoints = [[NSMutableArray alloc] initWithCapacity:count];
        for (NSInteger j = 0; j < count; j++) {
            oldValue = [oldLineProperty.points[j] CGPointValue];
            newValue = [newLineProperty.points[j] CGPointValue];
            currentValue = [currentLineProperty.points[j] CGPointValue];
            offSetValueY = newValue.y - oldValue.y;
            currentValue.x = newValue.x;
            currentValue.y = oldValue.y + offSetValueY * progress;
            [currentPoints addObject:[NSValue valueWithCGPoint:currentValue]];
        }
        currentLineProperty.points = currentPoints;
        [currentPoints release];
    }
	
    _histogramOverlapContentView.barGroups = [currentHistogramOverlapLineData barGroups];
    _lineContentView.lines = currentHistogramOverlapLineData.lines;
    [currentHistogramOverlapLineData release];
	
    if (final) {
		self.histogramOverlapLineData = newHistogramOverlapLineData;
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
    for (ISSChartHistogramBarGroup *group in [_histogramOverlapLineData barGroups]) {
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
- (void)caculatePointPosition
{
    NSInteger index;
    CGFloat marginX;
    CGFloat marginY;
    NSValue *pointValue;
    NSMutableArray *points;
    for (ISSChartLine *line in _histogramOverlapLineData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        points = [[NSMutableArray alloc] init];
        index = 0;
        for (NSNumber *value in line.values) {
            CGFloat valueFloat = [value floatValue];
            marginX = [self getXAxisMarginXWithIndex:index];
            marginY = [self getViceYAxisMarginYWithValueY:valueFloat];
            pointValue = [NSValue valueWithCGPoint:CGPointMake(marginX, marginY)];
            [points addObject:pointValue];
            index++;
        }
        lineProperty.points = points;
        [points release];
    }
}

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
    [self caculateDrawableAreaSize:_histogramOverlapLineData.coordinateSystem];
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (CGFloat)getMarginXWithBar:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = barGroup.index * barGroup.width;
    marginX += _histogramOverlapLineData.coordinateSystem.leftMargin + _histogramOverlapLineData.groupSpcaing / 2;
    return marginX;
}

- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapLineData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapLineData.coordinateSystem;
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

- (void)caculateBarSizeAndFrame
{
    NSArray *barGroups = [_histogramOverlapLineData barGroups];
    CGFloat barCountPerGroup = [_histogramOverlapLineData barCountOfPerGroup];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat groupWidth = drawableAreaSize.width / [barGroups count];
    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCountPerGroup;
    CGFloat maximumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MAXIMUM_BAR_WIDTH * barCountPerGroup;
    float factor= 0.618;
    
    if (groupWidth < minimumGroupWidth) {
        _histogramOverlapLineData.groupSpcaing = DEFAULT_BAR_GROUP_SPACING;
        _histogramOverlapLineData.barWidth = DEFAULT_MINIMUM_BAR_WIDTH;
        groupWidth = minimumGroupWidth;
    }
	else if(groupWidth > maximumGroupWidth) {
        _histogramOverlapLineData.groupSpcaing = groupWidth - DEFAULT_MAXIMUM_BAR_WIDTH * barCountPerGroup;
        _histogramOverlapLineData.barWidth = DEFAULT_MAXIMUM_BAR_WIDTH;
    }
	else {
        _histogramOverlapLineData.groupSpcaing = (1.0 - factor) * groupWidth;
		_histogramOverlapLineData.barWidth = groupWidth * factor;
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
    return CGRectMake(marginX, marginY, _histogramOverlapLineData.barWidth, barHeight);
}

#pragma  mark - axis methods
- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = _histogramOverlapLineData.coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:_histogramOverlapLineData.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height/2, width - 5, height);
    return frame;
}


- (CGRect)getViceYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapLineData.coordinateSystem;
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
    UIFont *font = _histogramOverlapLineData.coordinateSystem.xAxis.axisProperty.labelFont;
    CGFloat width = [label widthWithFont:font withLineHeight:textHeight];
    textHeight = [label heightWithFont:font withLineWidth:width];
    CGFloat radian = degreesToRadian(_histogramOverlapLineData.coordinateSystem.xAxis.rotateAngle);
    CGFloat offsetHeight = 0;
    if (radian && radian != M_PI) {
        if (radian > M_PI) {
            radian = 2*M_PI - radian;
        }
        offsetHeight = fabsf((width * fabs(sin(radian)) - textHeight)/2);
        textHeight = width * fabs(sin(radian));
    }
    CGFloat marginY = [self getDrawableAreaSize].height + _histogramOverlapLineData.coordinateSystem.topMargin + offsetHeight;
    CGRect frame = CGRectMake(marginX , marginY, width, textHeight);
    return frame;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    ISSChartHistogramBarGroup *group = [_histogramOverlapLineData barGroups][index];
    NSInteger barCount = [group.bars count];
    NSInteger barIndex = barCount/2;
    ISSChartHistogramBar *bar = group.bars[barIndex];
    CGFloat marginX = [self getMarginXWithBar:bar group:group];
	marginX += _histogramOverlapLineData.barWidth / 2;
    return marginX;
}

- (CGFloat)getYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapLineData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueY / yAxis.valueRange - yAxis.minValue / yAxis.valueRange);
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

- (CGFloat)getViceYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapLineData.coordinateSystem;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    ISSChartAxis *viceYAxis = coordinateSystem.viceYAxis;
    CGFloat rate =  valueY / viceYAxis.valueRange - viceYAxis.minValue / viceYAxis.valueRange;;;
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate * drawAreaSize.height;
    return marginY;
}

#pragma mark - public methods

- (void)displayFirstShowAnimationWithCompletion:(void (^)(BOOL))completion
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
        CGRect lineOriginFrame = _lineContentView.frame;
        CGRect currentFrame = lineOriginFrame;
        currentFrame.size.width = _histogramOverlapLineData.coordinateSystem.leftMargin;
        _lineContentView.frame = currentFrame;
        _histogramOverlapContentView.alpha = 1.0;
        _lineContentView.alpha = 1.0;
        
        [UIView animateWithDuration:kISSChartFirstAnimationDuration animations:^{
            _lineContentView.frame = lineOriginFrame;
        }];
		ISSChartHistogramOverlapLineData *newHistogramLineData = [_histogramOverlapLineData copy];
		[_histogramOverlapLineData adjustDataToZeroState];
		self.histogramOverlapLineData = _histogramOverlapLineData;
		_histogramOverlapContentView.alpha = 1.0;
		_lineContentView.alpha = 1.0;
		[self animationWithData:newHistogramLineData completion:^(BOOL finished){
			if (finished) {
                self.userInteractionEnabled = TRUE;
                if (completion) {
                    completion(TRUE);
                }
                _isFirstDisplay = FALSE;
			}
		}];
		[newHistogramLineData release];
    }
}

- (void)displayFirstShowAnimation
{
    [self displayFirstShowAnimationWithCompletion:NULL];
}

- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    if (chartData) {
        NSAssert([chartData isKindOfClass:[ISSChartHistogramOverlapLineData class]], @"chart data is not histogram overlap line data format!");
		[chartData readyData];
        [self animationWithNewHistogramOverlapLine:chartData completion:completion];
    }
}

- (void)animationWithNewHistogramOverlapLine:(ISSChartHistogramOverlapLineData*)histogramOverlapData completion:(void (^)(BOOL))completion
{
    if (histogramOverlapData && _histogramOverlapLineData != histogramOverlapData) {
        if ([_histogramOverlapLineData.lines count] != [histogramOverlapData.lines count]||
            [[_histogramOverlapLineData barGroups] count] != [[histogramOverlapData barGroups] count]) {
            self.histogramOverlapLineData = histogramOverlapData;
            _histogramOverlapContentView.alpha = 0.0;
            _lineContentView.alpha = 0.0;
            _isFirstDisplay = TRUE;
            [self displayFirstShowAnimationWithCompletion:completion];
        }
        else {
			ISSChartLineData *originLineData = [_histogramOverlapLineData copy];
			[self setHistogramOverlapLineDataAndUpdate:histogramOverlapData];
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = originLineData;
            userInfo[KEY_NEW_VALUE] = histogramOverlapData;
			[originLineData release];
            if (completion != nil) {
                void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
                userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
            }
            [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                           selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
			
        }
    }
}

#pragma mark - hint view

- (ISSChartLine*)findSelectedLineWithLocation:(CGPoint)location
{
    ISSChartLine *foundLine = nil;
    NSArray *lines = _histogramOverlapLineData.lines;
    for (ISSChartLine *line in lines) {
        if ([line isPointOnLine:location]) {
            foundLine = line;
            break;
        }
    }
    return foundLine;
}

- (void)showHintLineView:(BOOL)show
{
    CGFloat alpha = 0.0;
    if (show) {
        if (!_hintLineView) {
            ISSChartCoordinateSystem *coordinateSystem = _histogramOverlapLineData.coordinateSystem;
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
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _histogramOverlapLineData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _histogramOverlapLineData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)adjustHintViewPosition:(ISSChartHintView*)hintView offset:(CGSize)offset
{
    ISSChartHistogramOverlapLineHintView *histogramOverlapLineHintView = (ISSChartHistogramOverlapLineHintView*)hintView;
	histogramOverlapLineHintView.backgroundImageView.transform = CGAffineTransformIdentity;
    if (CGRectGetMaxX(hintView.frame) >= CGRectGetWidth(self.bounds)) {
        histogramOverlapLineHintView.backgroundImageView.transform = CGAffineTransformScale(histogramOverlapLineHintView.backgroundImageView.transform, -1, 1);
        histogramOverlapLineHintView.right = CGRectGetMinX(hintView.frame) - offset.width;
    }
    else {
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

//- (void)handleHintViewOnLocation:(CGPoint)location
//{
//    ISSChartLine *line = [self findSelectedLineWithLocation:location];
//    if (line) {
//        NSInteger index = [line findValueIndexOfLineWithLocation:location];
//        if (NSNotFound != index) {
//            location = [line findPointLocationWithApproximateLocation:location];
//			ISSChartHistogramBar *bar = [self findSelectedBarIndexWithLocatin:location];
//			if(NSNotFound == _previousIndex || _previousIndex != index) {
//				if (_didSelectedBars) {
//					ISSChartHintView *hintView = _didSelectedBars(self, bar.groupIndex);
//					if (hintView) {
//						_previousIndex = index;
//						[self recycleAllHintViews];
//                        [self showHintView:hintView bar:bar];
//                        [self adjustHintViewPosition:hintView offset:bar.barProperty.frame.size];                        
//					}
//				}
//            }
//        }
//    }
//}

- (void)handleHintViewOnLocation:(CGPoint)location
{
	ISSChartHistogramBar *bar = [self findSelectedBarIndexWithLocatin:location];
	if (bar) {
		NSInteger groupIndex = bar.groupIndex;
		if(NSNotFound == _previousIndex || _previousIndex != groupIndex) {
			[self recycleAllHintViews];
			if (_didSelectedBarsBlock) {
				_previousIndex = groupIndex;
				ISSChartHistogramBarGroup *group = [_histogramOverlapLineData barGroups][groupIndex];
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

#pragma mark - UIResponder
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
	ISSChartHistogramBar *bar = [self findSelectedBarIndexWithLocatin:location];
	if (bar) {
        if (_didTappedBarsBlock) {
            _didTappedBarsBlock(self, bar.groupIndex);
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
			[self showHintLineView:FALSE];
			_previousIndex = NSNotFound;
			[self recycleAllHintViews];
			break;
		default:
			break;
	}
}
@end

