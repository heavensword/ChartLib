//
//  ISSHistogramChartView.m
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//
#import "ISSChartHistogramLineView.h"
#import "ISSChartHistogramLineAxisView.h"
#import "ISSChartHistogramLineLegendView.h"
#import "ISSChartHintView.h"
#import "ISSChartLineContentView.h"
#import "ISSChartHistogramContentView.h"

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
#import "ISSChartHistogramLineHintView.h"
#import "ISSChartAxisItem.h"

@interface ISSChartHistogramLineView()
{
	NSInteger							_previousIndex;
	UIView								*_hintLineView;
    ISSChartHistogramLineLegendView     *_legendView;
    ISSChartHistogramContentView        *_histogramContentView;
    ISSChartLineContentView             *_lineContentView;
}
@end

@implementation ISSChartHistogramLineView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
    Block_release(_didTappedOnBarBlock);
    Block_release(_didSelectedBarBlock);
    [_lineContentView release];
    [_legendView release];
    [_histogramLineData release];
    [_histogramContentView release];
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

- (id)initWithFrame:(CGRect)frame histogramLineData:(ISSChartHistogramLineData*)histogramLineData
{
    self = [super initWithFrame:frame];
    if (self) {
		_previousIndex = NSNotFound;
        _drawableAreaSize = self.bounds.size;
        _histogramContentView = [[ISSChartHistogramContentView alloc] initWithFrame:self.bounds];
        _histogramContentView.alpha = 0.0;
        _lineContentView = [[ISSChartLineContentView alloc] initWithFrame:self.bounds];
        _lineContentView.alpha = 0;
        
        _axisView = [[ISSChartHistogramLineAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = histogramLineData.coordinateSystem;
        _axisView.containerView = self;
		
        _legendView = [[ISSChartHistogramLineLegendView alloc] initWithFrame:CGRectZero];
		
		[histogramLineData readyData];
        self.histogramLineData = histogramLineData;
        [self addSubview:_axisView];
        [self addSubview:_histogramContentView];
        [self addSubview:_lineContentView];
        [self addSubview:_legendView];        
    }
    return self;
}

- (void)setHistogramLineDataAndUpdate:(ISSChartHistogramLineData *)histogramLineData
{
	RELEASE_SAFELY(_histogramLineData);
    _histogramLineData = [histogramLineData retain];
    RELEASE_SAFELY(_chartData);
	_chartData = [histogramLineData retain];
	
    BOOL shouldAdjust = FALSE;
    if (_histogramLineData.legendTextArray && [_histogramLineData.legendTextArray count]) {
        shouldAdjust = TRUE;
    }
    [self caculateDrawableAreaSize];
    [self caculateBarSizeAndFrame];
    [self caculatePointPosition];
    if (shouldAdjust) {
        _legendView.frame = [self getLegendFrame:_histogramLineData.coordinateSystem legendPosition:_histogramLineData.legendPosition];
        [self adjustContentViewFrame];
        [self adjustAxisViewFrame];
    }
	[self adjustAxis];
}

- (void)setHistogramLineData:(ISSChartHistogramLineData *)histogramLineData
{
    [self setHistogramLineDataAndUpdate:histogramLineData];
    _axisView.coordinateSystem = _histogramLineData.coordinateSystem;
    _histogramContentView.histogramStyle = _histogramContentView.histogramStyle;
    _histogramContentView.barGroups = [_histogramLineData barGroups];
    _lineContentView.lines = _histogramLineData.lines;
    _legendView.direction = [_histogramLineData getLegendDirection];
    _legendView.chartData = _histogramLineData;
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
	
    ISSChartHistogramLineData *originHistogramLineData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartHistogramLineData *newHistogramLineData = userInfo[KEY_NEW_VALUE];
    ISSChartHistogramLineData *currentHistogramLineData = [newHistogramLineData copy];
	
    NSInteger count = 0;
    NSInteger groupCount = [[originHistogramLineData barGroups] count];
    for (NSInteger group = 0; group < groupCount; group++) {
        ISSChartHistogramBarGroup *oldBarGroup = [originHistogramLineData barGroups][group];
        ISSChartHistogramBarGroup *newBarGroup = [newHistogramLineData barGroups][group];
        ISSChartHistogramBarGroup *currentBarGroup = [currentHistogramLineData barGroups][group];
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
    NSInteger lineCount = [newHistogramLineData.lines count];
    for (NSInteger i = 0; i < lineCount; i++) {
        ISSChartLine *oldLine = originHistogramLineData.lines[i];
        ISSChartLine *newLine = newHistogramLineData.lines[i];
        ISSChartLine *currentLine = currentHistogramLineData.lines[i];
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
   
    _histogramContentView.barGroups = [currentHistogramLineData barGroups];
    _lineContentView.lines = currentHistogramLineData.lines;
    [currentHistogramLineData release];
	
    if (final) {
		self.histogramLineData = newHistogramLineData;
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

- (ISSChartHistogramBar*)findBarIndexWithLocatin:(CGPoint)location
{
    ISSChartHistogramBar *selectedBar = nil;
    for (ISSChartHistogramBarGroup *group in [_histogramLineData barGroups]) {
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
    for (ISSChartLine *line in _histogramLineData.lines) {
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


- (void)adjustContentViewFrame
{
    _histogramContentView.frame = [self getDrawableFrame];
    _lineContentView.frame = [self getDrawableFrame];
}

- (void)adjustAxisViewFrame
{
    _axisView.frame = [self getDrawableFrame];
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_histogramLineData.coordinateSystem];
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (CGFloat)getMarginXWithBar:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = barGroup.index * barGroup.width + bar.index * _histogramLineData.barWidth;
    marginX += _histogramLineData.coordinateSystem.leftMargin + _histogramLineData.groupSpcaing/2;
    return marginX;
}

- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramLineData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _histogramLineData.coordinateSystem;
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
    NSArray *barGroups = [_histogramLineData barGroups];
    CGFloat barCountPerGroup = [_histogramLineData barCountOfPerGroup];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat groupWidth = drawableAreaSize.width / [barGroups count];
    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCountPerGroup;
    CGFloat factor = 0.618;
    if (groupWidth < minimumGroupWidth) {
        _histogramLineData.groupSpcaing = DEFAULT_BAR_GROUP_SPACING;
        _histogramLineData.barWidth = DEFAULT_MINIMUM_BAR_WIDTH;
        groupWidth = minimumGroupWidth;
    }
    else {
        _histogramLineData.groupSpcaing = (1.0 - factor) * groupWidth;
        _histogramLineData.barWidth = (groupWidth*factor)/barCountPerGroup;
    }
    for (ISSChartHistogramBarGroup *group in barGroups) {
        group.width = groupWidth;
        for (ISSChartHistogramBar *bar in group.bars) {
            ISSChartHistogramBarProperty *property = bar.barProperty;
            property.frame = [self getBarFrame:bar group:group];
        }
    }
}

- (CGRect)getBarFrame:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = [self getMarginXWithBar:bar group:barGroup];
    CGFloat marginY = [self getMarginYWithValueY:bar.valueY];
    CGFloat barHeight = [self getHeightWithValue:bar.valueY];
    return CGRectMake(marginX, marginY, _histogramLineData.barWidth, barHeight);
}

#pragma  mark - axis methods
- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = _histogramLineData.coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:_histogramLineData.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height/2, width - 5, height);
    return frame;
}

- (CGRect)getViceYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramLineData.coordinateSystem;
    CGFloat marginX = CGRectGetWidth(self.bounds) - coordinateSystem.rightMargin + 5;
    CGFloat width = coordinateSystem.rightMargin;
    CGFloat height = [label heightWithFont:coordinateSystem.viceYAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(marginX, marginY - height/2, width - 5, height);
    return frame;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    ISSChartHistogramBarGroup *group = [_histogramLineData barGroups][index];
    NSInteger barCount = [group.bars count];
    NSInteger barIndex = barCount/2;
    ISSChartHistogramBar *bar = group.bars[barIndex];
    CGFloat marginX = [self getMarginXWithBar:bar group:group];
    if (barCount % 2) {
        marginX += _histogramLineData.barWidth/2;
    }
    return marginX;
}

- (CGFloat)getYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramLineData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  valueY / yAxis.valueRange - yAxis.minValue / yAxis.valueRange;;
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

- (CGFloat)getViceYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramLineData.coordinateSystem;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    ISSChartAxis *viceYAxis = coordinateSystem.viceYAxis;
    CGFloat rate =  valueY / viceYAxis.valueRange - viceYAxis.minValue / viceYAxis.valueRange;;;
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

- (void)showHintLineView:(BOOL)show
{
    CGFloat alpha = 0.0;
    if (show) {
        if (!_hintLineView) {
            ISSChartCoordinateSystem *coordinateSystem = _histogramLineData.coordinateSystem;
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

- (void)updateHintLineViewFrame:(CGPoint)location
{
    CGPoint center = _hintLineView.center;
    center.x = location.x;
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _histogramLineData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _histogramLineData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)adjustHintViewPosition:(ISSChartHintView*)hintView offset:(CGSize)offset
{
    ISSChartHistogramLineHintView *histogramLineHintView = (ISSChartHistogramLineHintView*)hintView;
	histogramLineHintView.imageView.transform = CGAffineTransformIdentity;
    if (CGRectGetMaxX(hintView.frame) >= CGRectGetWidth(self.bounds)) {
        histogramLineHintView.imageView.transform = CGAffineTransformScale(histogramLineHintView.imageView.transform, -1, 1);
        histogramLineHintView.right = CGRectGetMinX(hintView.frame) - offset.width;
    }
    else {
    }
}

- (void)handleHintViewOnLocation:(CGPoint)location
{
    ISSChartHistogramBar *bar = [self findBarIndexWithLocatin:location];
    if (bar) {
        NSInteger index = bar.groupIndex * [_histogramLineData barCountOfPerGroup] + bar.index;
		NSInteger indexOfValueOnLine = bar.groupIndex;
		ISSChartAxisItem *axisItem = [_histogramLineData getXAxisItemWithBar:bar];
		ITTDINFO(@"index %d previous index %d bar.groupIndex %d name %@", index, _previousIndex, bar.groupIndex, axisItem.name);
        if(NSNotFound == _previousIndex|| _previousIndex != index) {
            if (_didSelectedBarBlock) {
				ISSChartHintView *hintView = _didSelectedBarBlock(self, bar, self.histogramLineData.lines, indexOfValueOnLine, axisItem);
				if (hintView) {
					_previousIndex = index;
					[self recycleAllHintViews];
					[self showHintView:hintView bar:bar];
					[self adjustHintViewPosition:hintView offset:bar.barProperty.frame.size];
				}
            }
        }
    }
}

#pragma mark - public methods

- (void)displayFirstShowAnimation
{
	[self displayFirstShowAnimationWithCompletion:NULL];
}

- (void)displayFirstShowAnimationWithCompletion:(void (^)(BOOL))completion
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
        CGRect lineOriginFrame = _lineContentView.frame;
        CGRect currentFrame = lineOriginFrame;
        currentFrame.size.width = _histogramLineData.coordinateSystem.leftMargin;
        _lineContentView.frame = currentFrame;
        _histogramContentView.alpha = 1.0;
        _lineContentView.alpha = 1.0;
        
        [UIView animateWithDuration:kISSChartFirstAnimationDuration animations:^{
            _lineContentView.frame = lineOriginFrame;
        }];
		ISSChartHistogramLineData *newHistogramLineData = [_histogramLineData copy];
		[_histogramLineData adjustDataToZeroState];
		self.histogramLineData = _histogramLineData;
		_histogramContentView.alpha = 1.0;
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

- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    if (chartData) {
        NSAssert([chartData isKindOfClass:[ISSChartHistogramLineData class]], @"chart data is not histogram line data format!");
		[chartData readyData];
        [self animationWithNewHistogramLine:chartData completion:completion];
    }
}

- (void)animationWithNewHistogramLine:(ISSChartHistogramLineData*)historgramLineData completion:(void (^)(BOOL))completion
{
    if (historgramLineData && _histogramLineData != historgramLineData) {
        if ([_histogramLineData.lines count] != [historgramLineData.lines count]||
            [[_histogramLineData barGroups] count] != [[historgramLineData barGroups] count]) {
            self.histogramLineData = historgramLineData;
            _histogramContentView.alpha = 0.0;
            _lineContentView.alpha = 0.0;
            _isFirstDisplay = TRUE;
            [self displayFirstShowAnimationWithCompletion:completion];
        }
        else {
			ISSChartLineData *originLineData = [_histogramLineData copy];
			[self setHistogramLineDataAndUpdate:historgramLineData];
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = originLineData;
            userInfo[KEY_NEW_VALUE] = historgramLineData;
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

#pragma mark - gesture
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
    ISSChartHistogramBar *bar = [self findBarIndexWithLocatin:location];
    if (bar) {
		if (_didTappedOnBarBlock) {
            NSInteger indexOfValueOnLine = bar.groupIndex;
            _didTappedOnBarBlock(self, bar, self.histogramLineData.lines, indexOfValueOnLine, [_histogramLineData getXAxisItemWithBar:bar]);
		}
	}
}

- (void)handlePan:(UITapGestureRecognizer*)gestureRecognizer
{
	ITTDINFO(@"panGestureRecognizer.state %d", gestureRecognizer.state);
	ITTDINFO(@"- (void)handlePan:(UIPanGestureRecognizer*)panGestureRecognizer");
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