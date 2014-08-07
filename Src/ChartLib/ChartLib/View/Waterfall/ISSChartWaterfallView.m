//
//  ISSChartWaterfallView.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-8.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallView.h"
#import "ISSChatGallery.h"
#import "ISSChartSymbolGenerator.h"
#import "ISSChartWaterfallData.h"
#import "ISSChartWaterfallAxisView.h"
#import "ISSChartWaterfallContentView.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisItem.h"
#import "ISSChartAxisProperty.h"
#import "ISSChatGallery.h"
#import "ISSChartHintView.h"
#import "ISSChartWaterfallSymbolData.h"
#import "ISSChartWaterfallHintView.h"


@interface ISSChartWaterfallView ()
{
    ISSChartWaterfallContentView *_waterfallContentView;
    UIView						 *_hintLineView;
    NSInteger                    _previousIndex;
}

@end
@implementation ISSChartWaterfallView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}


- (void)dealloc
{
	_waterfallContentView.containerView = nil;
    RELEASE_SAFELY(_waterfallContentView);
    RELEASE_SAFELY(_waterfallData);
    RELEASE_SAFELY(_hintLineView);
    Block_release(_didTappedOnSymbolBlock);
    Block_release(_didSelectedSymbolBlock);
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame waterfallData:(ISSChartWaterfallData *)waterfallData
{
    self = [super initWithFrame:frame];
    if (self) {
        _drawableAreaSize = self.bounds.size;
        _axisView = [[ISSChartWaterfallAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = waterfallData.coordinateSystem;
        _axisView.containerView = self;
        
        _waterfallContentView = [[ISSChartWaterfallContentView alloc] initWithFrame:self.bounds];
        _waterfallContentView.containerView = self;
        _waterfallContentView.alpha = 0.0;
        [waterfallData readyData];
        self.waterfallData = waterfallData;
        [self addSubview:_axisView];
        [self addSubview:_waterfallContentView];
        
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

#pragma mark - setter
- (void)setWaterfallDataAndUpdate:(ISSChartWaterfallData *)waterfallData
{
    RELEASE_SAFELY(_waterfallData);
    _waterfallData = [waterfallData retain];
	RELEASE_SAFELY(_chartData);
	_chartData = [waterfallData retain];
    _axisView.coordinateSystem = _waterfallData.coordinateSystem;
    [self caculateDrawableAreaSize];
    [self caculateSysmbolPosition];
	[self adjustAxis];
}

-(void)setWaterfallData:(ISSChartWaterfallData *)waterfallData
{
    [self setWaterfallDataAndUpdate:waterfallData];
    _axisView.coordinateSystem = _waterfallData.coordinateSystem;
    _waterfallContentView.symbolDatas = _waterfallData.symbols;
    
}

- (float)getColumnWidth
{
    return  _drawableAreaSize.width / self.waterfallData.coordinateSystem.xAxis.axisItems.count;
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_waterfallData.coordinateSystem];
}

- (void)caculateSysmbolPosition
{
    NSInteger count = [_waterfallData.symbols count];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat groupWidth = drawableAreaSize.width / count;
    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH;
    CGFloat factor= 0.618;
    if (groupWidth < minimumGroupWidth) {
        _waterfallData.barWidth = DEFAULT_MINIMUM_BAR_WIDTH;
        _waterfallData.spacing = DEFAULT_BAR_GROUP_SPACING;
    }
	else {
		_waterfallData.barWidth = groupWidth * factor;
        _waterfallData.spacing = (1.0 - factor) * groupWidth;
    }
    for (ISSChartWaterfallSymbolData *symbolData in _waterfallData.symbols) {
        symbolData.frame = [self symbolFrameWithSymbolData:symbolData];
    }
}

#pragma mark - private methods
- (CGRect)symbolFrameWithSymbolData:(ISSChartWaterfallSymbolData*)symbolData
{
    CGRect frame = CGRectZero;
    CGFloat marginX = [self getXAxisMarginXWithIndex:symbolData.index] - _waterfallData.barWidth / 2;
    CGFloat height = [self getHeightWithValue:symbolData.endValue - symbolData.startValue];
    if (0 == symbolData.index ||
        [_waterfallData.symbols count] - 1 == symbolData.index) {
        CGFloat marginY = [self getMarginYWithValueY:symbolData.endValue];
        frame = CGRectMake(marginX, marginY, _waterfallData.barWidth, height);
    }
    else {
        CGFloat marginY = [self getMarginYWithValueY:symbolData.endValue];
        frame = CGRectMake(marginX, marginY, _waterfallData.barWidth, height);
        
    }
    return frame;
}

#pragma  mark - axis methods
- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _waterfallData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _waterfallData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _waterfallData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueY / yAxis.valueRange - yAxis.minValue / yAxis.valueRange);
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = _waterfallData.coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:_waterfallData.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height, width - 5, height);
    return frame;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    CGFloat width = [self getDrawableAreaSize].width;
    CGFloat columnWidth = width / self.waterfallData.coordinateSystem.xAxis.axisItems.count;
    return columnWidth * index + self.waterfallData.coordinateSystem.leftMargin + _waterfallData.spacing / 2 + _waterfallData.barWidth / 2;
}

- (void)displayFirstShowAnimation
{
    [self displayFirstShowAnimationWithCompletion:NULL];
}

- (void)displayFirstShowAnimationWithCompletion:(void (^)(BOOL))completion
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
		ISSChartWaterfallData *newWaterfallData = [_waterfallData copy];
		[_waterfallData adjustDataToZeroState];
		self.waterfallData = _waterfallData;
		_waterfallContentView.alpha = 1.0;
		[self animationWithData:newWaterfallData completion:^(BOOL finished){
			if (finished) {
				self.userInteractionEnabled = TRUE;
                if (completion) {
                    completion(TRUE);                    
                }
                _isFirstDisplay = FALSE;
			}
		}];
		[newWaterfallData release];
    }
}

- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    [chartData readyData];
    [self animationWithWaterfallData:chartData completion:completion];
}

- (void)animationWithWaterfallData:(ISSChartWaterfallData*)waterfallData completion:(void (^)(BOOL))completion
{
    if (waterfallData && waterfallData != _waterfallData) {
        if ([waterfallData.symbols count] == [_waterfallData.symbols count]) {
            ISSChartWaterfallData *originWaterfallData = [_waterfallData copy];
            [self setWaterfallDataAndUpdate:waterfallData];
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = originWaterfallData;
            userInfo[KEY_NEW_VALUE] = waterfallData;
            [originWaterfallData release];
            if (nil != completion) {
                void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
                userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
            }
            [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                           selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
        }
        else {
            _isFirstDisplay = TRUE;
            self.waterfallData = waterfallData;
            [self displayFirstShowAnimationWithCompletion:completion];
        }
    }
}

- (void)dataUpdateAnimation:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    BOOL final = FALSE;
    iteration++;
    
    ISSChartWaterfallData *originWaterfallData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartWaterfallData *newWaterfallData = userInfo[KEY_NEW_VALUE];
    
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    userInfo[KEY_ITERTATION] = @(iteration);
    ISSChartWaterfallData *currentWaterfallData = [newWaterfallData copy];
    NSInteger symbolCount = [[originWaterfallData symbols] count];
    for (NSInteger group = 0; group < symbolCount; group++) {
        ISSChartWaterfallSymbolData *oldSymbol = [originWaterfallData symbols][group];
        ISSChartWaterfallSymbolData *newSymbol = [newWaterfallData symbols][group];
        ISSChartWaterfallSymbolData *currentSymbol = [currentWaterfallData symbols][group];
        CGRect oldBarFrame = oldSymbol.frame;
        CGRect newBarFrame = newSymbol.frame;
        CGRect currentBarFrame = currentSymbol.frame;
        if (ISSChartSymbolArrowDown == currentSymbol.symbolType && _isFirstDisplay) {
            currentBarFrame.size.height = oldBarFrame.size.height + (newBarFrame.size.height - oldBarFrame.size.height)*progress;
        }
        else {
            currentBarFrame.origin.y = oldBarFrame.origin.y + (newBarFrame.origin.y - oldBarFrame.origin.y)*progress;
            currentBarFrame.size.height = oldBarFrame.size.height + (newBarFrame.size.height - oldBarFrame.size.height)*progress;
        }
        currentSymbol.frame = currentBarFrame;
    }
    _waterfallContentView.symbolDatas = [currentWaterfallData symbols];
    [currentWaterfallData release];
    if (final) {
		self.waterfallData = newWaterfallData;
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

#pragma mark - hint view
- (ISSChartWaterfallSymbolData *)findSelectedSymbolWithLocation:(CGPoint)location
{
    ISSChartWaterfallSymbolData *foundSymbol = nil;
    ISSChartCoordinateSystem *coordinateSystem = _waterfallData.coordinateSystem;
    for (ISSChartWaterfallSymbolData *symbol in _waterfallData.symbols){
        CGRect newFrame = CGRectMake(symbol.frame.origin.x, coordinateSystem.topMargin,symbol.frame.size.width , [self getDrawableAreaSize].height);
        if (CGRectContainsPoint(newFrame, location)) {
            foundSymbol = symbol;
            break;
        }
    }
    return foundSymbol;
}


- (CGRect)getHintViewFrame:(CGRect)frame location:(CGPoint)location
{
    frame.origin.x = location.x + 15;
    frame.origin.y = location.y - CGRectGetHeight(frame)/2;
    return frame;
}

- (void)showHintView:(ISSChartHintView*)hintView symbol:(ISSChartWaterfallSymbolData*)symbol
{
    if (hintView && symbol) {
        CGRect frame = hintView.frame;
        frame.origin.x = CGRectGetMaxX(symbol.frame);
        frame.origin.y = CGRectGetMinY(symbol.frame) - 18;
        hintView.frame = frame;
        [self addSubview:hintView];
        [hintView show];
    }
}

- (void)showHintLineView:(BOOL)show
{
    CGFloat alpha = 0.0;
    if (show) {
        if (!_hintLineView) {
            ISSChartCoordinateSystem *coordinateSystem = _waterfallData.coordinateSystem;
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
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _waterfallData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _waterfallData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)handleHintViewOnLocation:(CGPoint)location
{
    ISSChartWaterfallSymbolData *symbol = [self findSelectedSymbolWithLocation:location];
    if (symbol) {
        if(NSNotFound == _previousIndex||_previousIndex != symbol.index) {
            if (_didSelectedSymbolBlock) {
                ISSChartAxisItem *axisItem = [_waterfallData xAxisItemAtIndex:symbol.index];
                ISSChartHintView *hintView = _didSelectedSymbolBlock(self, symbol, axisItem);
                if (hintView) {
                    _previousIndex = symbol.index;
                    [self recycleAllHintViews];
                    [self showHintView:hintView symbol:symbol];
                    [self adjustHintViewPosition:hintView offset:symbol.frame.size];
                }
            }
        }
    }
}

- (void)adjustHintViewPosition:(ISSChartHintView*)hintView offset:(CGSize)offset
{
    ISSChartWaterfallHintView *waterfallHintView = (ISSChartWaterfallHintView*)hintView;
	waterfallHintView.imageView.transform = CGAffineTransformIdentity;
    if (CGRectGetMaxX(hintView.frame) >= CGRectGetWidth(self.bounds)) {
        waterfallHintView.imageView.transform = CGAffineTransformScale(waterfallHintView.imageView.transform, -1, 1);
        waterfallHintView.right = CGRectGetMinX(hintView.frame) - offset.width;
    }
}

#pragma mark - gesture recognizer
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
    ISSChartWaterfallSymbolData *symbol = [self findSelectedSymbolWithLocation:location];
    if (symbol) {
        if (_didTappedOnSymbolBlock) {
            ISSChartAxisItem *axisItem = [_waterfallData xAxisItemAtIndex:symbol.index];
            _didTappedOnSymbolBlock(self, symbol, axisItem);
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
