//
//  ISSHistogramChartView.m
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineView.h"
#import "ISSChartLineData.h"

#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChatGallery.h"
#import "ISSChartLineAxisView.h"
#import "ISSChartLineContentView.h"
#import "ISSChartLineLegendView.h"
#import "ISSChartLine.h"
#import "ISSChartLineProperty.h"
#import "ISSChartHintView.h"
#import "ISSChartLineHintView.h"

@interface ISSChartLineView()
{
    NSInteger                  _previousIndex;
    UIView                     *_hintLineView;
    ISSChartLineContentView    *_lineContentView;
}
@end

@implementation ISSChartLineView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
	ITTDINFO(@"linedata retaincount %d", [_lineData retainCount]);
    Block_release(_didSelectedLinesBlock);
    Block_release(_didTappedOnLinesBlock);
    [_lineData release];
    [_lineContentView release];
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

- (id)initWithFrame:(CGRect)frame lineData:(ISSChartLineData*)lineData
{
    self = [super initWithFrame:frame];
    if (self) {
        _drawableAreaSize = self.bounds.size;
        _lineContentView = [[ISSChartLineContentView alloc] initWithFrame:self.bounds];
        _lineContentView.alpha = 0.0;
        
        _axisView = [[ISSChartLineAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = lineData.coordinateSystem;
        _axisView.containerView = self;
        
        _legendView = [[ISSChartLineLegendView alloc] initWithFrame:CGRectZero];
        _legendView.direction = ISSChartLegendDirectionVertical;
        _previousIndex = NSNotFound;
        
        self.lineData = lineData;
        [self addSubview:_axisView];
        [self addSubview:_lineContentView];
        [self addSubview:_legendView];
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

- (void)setLineData:(ISSChartLineData *)lineData
{
    [self setLineDataAndUpdate:lineData];
    _axisView.coordinateSystem = _lineData.coordinateSystem;
    _lineContentView.lines = _lineData.lines;
    _legendView.direction = [_lineData getLegendDirection];
    _legendView.chartData = _lineData;
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
    
    ISSChartLineData *originLineData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartLineData *newLineData = userInfo[KEY_NEW_VALUE];
    ISSChartLineData *currentLineData = [newLineData copy];
    NSInteger count;
    CGPoint oldValue;
    CGPoint newValue;
    CGPoint currentValue;
    CGFloat offSetValueY;
    NSInteger lineCount = [newLineData.lines count];
    for (NSInteger i = 0; i < lineCount; i++) {
        ISSChartLine *oldLine = originLineData.lines[i];
        ISSChartLine *newLine = newLineData.lines[i];
        ISSChartLine *currentLine = currentLineData.lines[i];
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
    _lineContentView.lines = currentLineData.lines;    
    [currentLineData release];
    if (final) {
        self.lineData = newLineData;
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

- (void)setLineDataAndUpdate:(ISSChartLineData*)lineData
{
    RELEASE_SAFELY(_lineData);
    _lineData = [lineData retain];
	RELEASE_SAFELY(_chartData);
	_chartData = [lineData retain];
	[_lineData readyData];
    if (_lineData.legendTextArray && [_lineData.legendTextArray count]) {
        _legendView.frame = [self getLegendFrame:_lineData.coordinateSystem legendPosition:_lineData.legendPosition];
        [self adjustContentViewFrame];
        [self adjustAxisViewFrame];
    }
    [self caculateDrawableAreaSize];
    [self caculateGraduationWidthAndSpacing];
    [self caculatePointPosition];
	[self adjustAxis];	
}

- (void)adjustContentViewFrame
{
    _lineContentView.frame = [self getDrawableFrame];
}

- (void)adjustAxisViewFrame
{
    _axisView.frame = [self getDrawableFrame];
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_lineData.coordinateSystem];
}

- (void)caculateGraduationWidthAndSpacing
{
    NSInteger count = [_lineData.coordinateSystem.xAxis.axisItems count];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat graduationWidth = drawableAreaSize.width / count;
    CGFloat minimumGridWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH;
    CGFloat spacing;
    CGFloat factor = 0.618;
    if (graduationWidth < minimumGridWidth) {
        spacing = DEFAULT_BAR_GROUP_SPACING;
        graduationWidth = minimumGridWidth;
    }
    else {
        spacing = (1.0 - factor) * graduationWidth;
    }
    _lineData.graduationWidth = graduationWidth;
    _lineData.graduationSpacing = spacing;
}

- (void)caculatePointPosition
{
    CGFloat marginX;
    CGFloat marginY;
    NSValue *pointValue;
    NSMutableArray *points;
    for (ISSChartLine *line in _lineData.lines) {
        ISSChartLineProperty *lineProperty = line.lineProperty;
        NSInteger index = 0;
        points = [[NSMutableArray alloc] init];
        for (NSNumber *value in line.values) {
            CGFloat valueFloat = [value floatValue];
            marginX = [self getXAxisMarginXWithIndex:index];
            marginY = [self getYAxisMarginYWithValueY:valueFloat];
            pointValue = [NSValue valueWithCGPoint:CGPointMake(marginX, marginY)];
            [points addObject:pointValue];
            index++;
        }
        lineProperty.points = points;
        [points release];
    }
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (CGRect)getDrawableFrame
{
    CGRect frame = self.bounds;
    return frame;
}

- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _lineData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _lineData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _lineData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueY / yAxis.valueRange - yAxis.minValue / yAxis.valueRange);
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

#pragma  mark - axis methods
- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    CGFloat marginX = _lineData.coordinateSystem.leftMargin + (index + 0.5) * _lineData.graduationWidth;
    return marginX;
}

- (ISSChartLine*)findSelectedLineWithLocation:(CGPoint)location
{
    ISSChartLine *foundLine = nil;
    NSArray *lines = _lineData.lines;
    for (ISSChartLine *line in lines) {
        if ([line isPointOnLine:location]) {
            foundLine = line;
            break;
        }
    }
    return foundLine;
}

- (CGRect)getHintViewFrame:(CGRect)frame location:(CGPoint)location radius:(CGFloat)radius
{
    frame.origin.x = location.x + radius;
    frame.origin.y = location.y - 18;
    return frame;
}

- (void)showHintView:(ISSChartHintView*)hintView line:(ISSChartLine*)line location:(CGPoint)location
{
    if (hintView && line) {
        CGRect frame = hintView.frame;
        hintView.frame = [self getHintViewFrame:frame location:location radius:line.lineProperty.radius];
        [self addSubview:hintView];
        [hintView show];
    }
}

- (void)showHintLineView:(BOOL)show
{
    CGFloat alpha = 0.0;
    if (show) {
        if (!_hintLineView) {
            ISSChartCoordinateSystem *coordinateSystem = _lineData.coordinateSystem;
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
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _lineData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _lineData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)adjustHintViewPosition:(ISSChartHintView*)hintView radius:(CGFloat)radius
{
    ISSChartLineHintView *lineHintView = (ISSChartLineHintView*)hintView;
    if (CGRectGetMaxX(hintView.frame) > CGRectGetWidth(self.bounds)) {
        lineHintView.imageView.transform = CGAffineTransformScale(lineHintView.imageView.transform, -1, 1);
        lineHintView.right = CGRectGetMinX(hintView.frame) - radius;
    }
    else {
        lineHintView.transform = CGAffineTransformIdentity;
    }
}

- (void)handleHintViewOnLocation:(CGPoint)location
{
    ISSChartLine *line = [self findSelectedLineWithLocation:location];
    if (line) {
        NSInteger index = [line findValueIndexOfLineWithLocation:location];
        if (NSNotFound != index) {
            location = [line findPointLocationWithApproximateLocation:location];
            ISSChartHintView *hintView;
            if(NSNotFound == _previousIndex||_previousIndex != index) {
                if (_didSelectedLinesBlock) {
                    ISSChartAxisItem *axisItem = [_lineData xAxisItemAtIndex:index];
                    hintView = _didSelectedLinesBlock(self, self.lineData.lines, index, axisItem);
                    if (hintView) {
                        _previousIndex = index;
                        [self recycleAllHintViews];
                        [self showHintView:hintView line:line location:location];
                        [self adjustHintViewPosition:hintView radius:line.lineProperty.radius];
                    }
                }                
            }
        }
    }
}

#pragma mark - public methods
- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    NSAssert([chartData isKindOfClass:[ISSChartLineData class]], @"chart data is not line data format!");
    [self animationWithNewLineData:chartData completion:completion];
}

- (void)animationWithNewLineData:(ISSChartLineData*)lineData completion:(void (^)(BOOL))completion
{
    NSAssert((self.lineData != lineData), @"the same line data!");
    if ([[self.lineData lines] count] == [[lineData lines] count]) {
        ISSChartLineData *originLineData = [_lineData copy];
        [self setLineDataAndUpdate:lineData];        
        CGFloat interval = 1.0/kISSChartAnimationFPS;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[KEY_ITERTATION] = @(0);
        userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
        userInfo[KEY_ORIGIN_VALUE] = originLineData;
        userInfo[KEY_NEW_VALUE] = lineData;
        [originLineData release];
        if (completion != nil) {
            void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
            userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
        }
        [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                       selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
    }
    else {
        self.lineData = lineData;
        _lineContentView.alpha = 0.0;
        _isFirstDisplay = TRUE;
        [self displayFirstShowAnimationWithCompletion:completion];
    }
}

- (void)displayFirstShowAnimationWithCompletion:(void (^)(BOOL))completion
{
	if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
        CGRect originFrame = _lineContentView.frame;
        CGRect currentFrame = originFrame;
        currentFrame.size.width = _lineData.coordinateSystem.leftMargin;
        _lineContentView.frame = currentFrame;
        _lineContentView.alpha = 1.0;
        [UIView animateWithDuration:kISSChartFirstAnimationDuration animations:^{
            _lineContentView.frame = originFrame;
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

- (void)displayFirstShowAnimation
{
	[self displayFirstShowAnimationWithCompletion:NULL];
}

#pragma mark - gesture recognizer
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
    ISSChartLine *line = [self findSelectedLineWithLocation:location];
    if (line) {
        NSInteger index = [line findValueIndexOfLineWithLocation:location];
        if (NSNotFound != index) {
			if (_didTappedOnLinesBlock) {
				ISSChartAxisItem *axisItem = [_lineData xAxisItemAtIndex:index];
				_didTappedOnLinesBlock(self, self.lineData.lines, index, axisItem);
			}
		}
	}
}

- (void)handlePan:(UITapGestureRecognizer*)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
	UIGestureRecognizerState state = gestureRecognizer.state;
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
		case UIGestureRecognizerStateEnded:case UIGestureRecognizerStateCancelled:
			[self showHintLineView:FALSE];
			_previousIndex = NSNotFound;
			[self recycleAllHintViews];
			break;
		default:
			break;
	}
}

@end