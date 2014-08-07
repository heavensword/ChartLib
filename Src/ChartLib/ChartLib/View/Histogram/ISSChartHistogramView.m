//
//  ISSHistogramChartView.m
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//
#import "ISSChartHistogramView.h"
#import "ISSChartHistogramContentView.h"
#import "ISSChartHistogramAxisView.h"
#import "ISSChartHistogramLegendView.h"
#import "ISSChartHistogramData.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartHistogramBarGroup.h"

#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChatGallery.h"
#import "ISSChartHintView.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartHistogramHintView.h"

@interface ISSChartHistogramView()
{
    NSInteger                       _previousIndex;
    UIView                          *_hintLineView;
    UIView                          *_minimumValueFilterView;
    UIView                          *_maxmumValueFilterView;
    ISSChartHistogramContentView    *_histogramContentView;
}
@end

@implementation ISSChartHistogramView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
	_histogramContentView.histogramView = nil;
    Block_release(_didTappedOnBarBlock);
    Block_release(_didSelectedBarBlock);
    [_hintLineView release];
    [_minimumValueFilterView release];
    [_maxmumValueFilterView release];
    [_histogramData release];
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

- (id)initWithFrame:(CGRect)frame histogram:(ISSChartHistogramData*)histogram
{
    self = [super initWithFrame:frame];
    if (self) {
        _shouldShowHintLine = TRUE;
        _previousIndex = NSNotFound;
        
        _drawableAreaSize = self.bounds.size;
        _histogramContentView = [[ISSChartHistogramContentView alloc] initWithFrame:self.bounds];
        _histogramContentView.histogramView = self;
        _histogramContentView.alpha = 0.0;
        
        _axisView = [[ISSChartHistogramAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = histogram.coordinateSystem;
        _axisView.containerView = self;
        
        _legendView = [[ISSChartHistogramLegendView alloc] initWithFrame:CGRectZero];
		[histogram readyData];
        self.histogramData = histogram;
        [self addSubview:_axisView];
        [self addSubview:_histogramContentView];
        [self addSubview:_legendView];
    }
    return self;
}

- (void)displayFirstShowAnimation
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
		ISSChartHistogramData *newHistogramData = [_histogramData copy];
		[_histogramData adjustDataToZeroState];
		self.histogramData = _histogramData;
		_histogramContentView.alpha = 1.0;
		[self animationWithData:newHistogramData completion:^(BOOL finished){
			if (finished) {
				self.userInteractionEnabled = TRUE;
                _isFirstDisplay = FALSE;
			}
		}];
		[newHistogramData release];
    }
}

- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    if (chartData) {
        NSAssert([chartData isKindOfClass:[ISSChartHistogramData class]], @"chart data is not histogram data format!");
		[chartData readyData];
        [self animationWithNewHistogram:chartData completion:completion];
    }
}

- (void)animationWithNewHistogram:(ISSChartHistogramData*)historgramData completion:(void (^)(BOOL))completion
{
    if (historgramData && self.histogramData != historgramData) {
        if ([[self.histogramData barGroups] count] == [[historgramData barGroups] count]) {
			ISSChartHistogramData *originHistogramData = [_histogramData copy];
			[self setHistogramDataAndUpdate:historgramData];
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = originHistogramData;
            userInfo[KEY_NEW_VALUE] = historgramData;
			[originHistogramData release];
            if (nil != completion) {
                void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
                userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
            }
            [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                           selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
        }
        else {
            [self setupDifferentGroupDataChangeAnimation:historgramData completion:completion];
        }
    }
}

- (void)setHistogramDataAndUpdate:(ISSChartHistogramData *)histogramData
{
	RELEASE_SAFELY(_histogramData);
    _histogramData = [histogramData retain];
	
    RELEASE_SAFELY(_chartData);
    _chartData = [histogramData retain];
    
    BOOL shouldAdjust = FALSE;
    if (_histogramData.legendTextArray && [_histogramData.legendTextArray count]) {
        shouldAdjust = TRUE;
    }
    [self caculateDrawableAreaSize];
    if (shouldAdjust) {
        _legendView.frame = [self getLegendFrame:_histogramData.coordinateSystem legendPosition:_histogramData.legendPosition];
        [self adjustContentViewFrame];
        [self adjustAxisViewFrame];
    }
    [self caculateBarSizeAndFrameForHistogramData:_histogramData];
	[self adjustAxis];
}

- (void)setHistogramData:(ISSChartHistogramData *)histogramData
{
    [self setHistogramDataAndUpdate:histogramData];
    _axisView.coordinateSystem = _histogramData.coordinateSystem;
    _histogramContentView.barGroups = [_histogramData barGroups];
    _legendView.chartData = _histogramData;
}

- (void)dataUpdateAnimation:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    BOOL final = FALSE;
    iteration++;
    
    ISSChartHistogramData *originHistogram = userInfo[KEY_ORIGIN_VALUE];
    ISSChartHistogramData *newHistogram = userInfo[KEY_NEW_VALUE];
    
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    userInfo[KEY_ITERTATION] = @(iteration);
    ISSChartHistogramData *currentHistogram = [newHistogram copy];
    NSInteger count = 0;
    NSInteger groupCount = [[originHistogram barGroups] count];
    for (NSInteger group = 0; group < groupCount; group++) {
        ISSChartHistogramBarGroup *oldBarGroup = [originHistogram barGroups][group];
        ISSChartHistogramBarGroup *newBarGroup = [newHistogram barGroups][group];
        ISSChartHistogramBarGroup *currentBarGroup = [currentHistogram barGroups][group];
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
    _histogramContentView.barGroups = [currentHistogram barGroups];
    [currentHistogram release];
    if (final) {
		self.histogramData = newHistogram;
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

- (void)differentGroupSizeDataUpdateAnimation:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    BOOL final = FALSE;
    iteration++;
    userInfo[KEY_ITERTATION] = @(iteration);
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    
    NSArray *originValueArray = userInfo[KEY_ORIGIN_VALUE];
    NSArray *destinamtionValueArray = userInfo[KEY_NEW_VALUE];
    NSArray *histogramContentViewArray = userInfo[KEY_VIEW];
    
    ISSChartHistogramContentView *originHistogramContentView = histogramContentViewArray[0];
    ISSChartHistogramContentView *newHistogramContentView = histogramContentViewArray[1];
    
    CGSize orginSize = [originValueArray[0] CGSizeValue];
    CGSize destinationSize = [destinamtionValueArray[0] CGSizeValue];
    CGSize newHistogramContentCurrentSize = orginSize;
    
    CGRect originFrame = [originValueArray[1] CGRectValue];
    CGRect destinationFrame = [destinamtionValueArray[1] CGRectValue];
    CGRect oldHistogramContentCurrentFrame = originFrame;
    
    newHistogramContentCurrentSize.width = orginSize.width + (destinationSize.width - orginSize.width) * progress;
    oldHistogramContentCurrentFrame.origin.x = CGRectGetMinX(originFrame) + (CGRectGetMinX(destinationFrame) - CGRectGetMinX(originFrame))*progress;
    
    [self caculateBarSizeAndFrameForDrawableAreaSize:newHistogramContentCurrentSize];
    [newHistogramContentView setNeedsDisplay];
    
    originHistogramContentView.frame = oldHistogramContentCurrentFrame;
    
    if (final) {
        [timer invalidate];
        timer = nil;
        [_histogramContentView removeFromSuperview];
        RELEASE_SAFELY(_histogramContentView);
        _histogramContentView = [newHistogramContentView retain];
        ISSChartHistogramData *histogramData = userInfo[KEY_DATA];
        self.histogramData = histogramData;
        
        void (^completionHandlerCopy)(BOOL);
        completionHandlerCopy = userInfo[KEY_COMPLETION_BLOCK];
        if (completionHandlerCopy != nil) {
            completionHandlerCopy(TRUE);
            Block_release(completionHandlerCopy);
        }
    }
}

- (void)setupDifferentGroupDataChangeAnimation:(ISSChartHistogramData*)historgramData completion:(void (^)(BOOL))completion
{
    CGFloat rightMargin = _histogramData.coordinateSystem.rightMargin;
    RELEASE_SAFELY(_histogramData);
    _histogramData = [historgramData retain];
    
    [self caculateDrawableAreaSize];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGSize beginSize = drawableAreaSize;
    beginSize.width = _histogramData.coordinateSystem.leftMargin;
    
    ISSChartHistogramContentView *newHistogramContentView = [[ISSChartHistogramContentView alloc] initWithFrame:self.bounds];
    newHistogramContentView.histogramView = self;
    [self caculateBarSizeAndFrameForHistogramData:_histogramData];
    newHistogramContentView.barGroups = [_histogramData barGroups];
    [self insertSubview:newHistogramContentView aboveSubview:_histogramContentView];
    [newHistogramContentView release];
    
    CGRect newContentOriginFrame = newHistogramContentView.frame;
    CGRect newContentStartFrame = newContentOriginFrame;
    newContentStartFrame.size.width = _histogramData.coordinateSystem.leftMargin;
    
    CGRect contentOriginFrame = _histogramContentView.frame;
    CGRect destinationFrame = contentOriginFrame;
    CGRect contentStartFrame = contentOriginFrame;
    destinationFrame.origin.x = CGRectGetWidth(self.bounds) - rightMargin;
    
    CGFloat interval = 1.0/kISSChartAnimationFPS;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[KEY_ITERTATION] = @(0);
    userInfo[KEY_DURATION] = @(kISSChartAnimationDuration + 0.4);
    userInfo[KEY_ORIGIN_VALUE] = @[[NSValue valueWithCGSize:beginSize], [NSValue valueWithCGRect:contentStartFrame]];
    userInfo[KEY_NEW_VALUE] = @[[NSValue valueWithCGSize:drawableAreaSize], [NSValue valueWithCGRect:destinationFrame]];;
    userInfo[KEY_VIEW] = @[_histogramContentView, newHistogramContentView];
    userInfo[KEY_DATA] = historgramData;
    if (completion != nil) {
        void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
        userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
    }
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(differentGroupSizeDataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
}

#pragma mark - private methods

- (BOOL)isPointOnBar:(ISSChartHistogramBar*)bar location:(CGPoint)location
{
    BOOL intersects = FALSE;
    CGRect rect = bar.barProperty.frame;
    if (bar.barProperty.selected) {
        rect.origin.y = _histogramData.coordinateSystem.topMargin;
        rect.size.height = CGRectGetHeight(self.bounds) - _histogramData.coordinateSystem.topMargin - _histogramData.coordinateSystem.bottomMargin;
    }
    if (CGRectContainsPoint(rect, location)) {
        intersects = TRUE;
    }
    return intersects;
}

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

- (ISSChartHistogramLegendView*)legendView
{
    return (ISSChartHistogramLegendView*)_legendView;
}

- (CGRect)getDrawableFrame
{
    CGRect frame = self.bounds;
    return frame;
}

- (void)adjustContentViewFrame
{
    _histogramContentView.frame = [self getDrawableFrame];
}

- (void)adjustAxisViewFrame
{
    _axisView.frame = [self getDrawableFrame];
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_histogramData.coordinateSystem];
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (void)caculateBarSizeAndFrameForHistogramData:(ISSChartHistogramData*)histogramData
{
    NSArray *barGroups = [histogramData barGroups];
    CGFloat barCountPerGroup = [histogramData barCountOfPerGroup];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat groupWidth = drawableAreaSize.width / [barGroups count];
    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCountPerGroup;
    CGFloat maximumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MAXIMUM_BAR_WIDTH * barCountPerGroup;
    float factor= 0.618;
    
    if (groupWidth < minimumGroupWidth) {
        histogramData.groupSpcaing = DEFAULT_BAR_GROUP_SPACING;
        histogramData.barWidth = DEFAULT_MINIMUM_BAR_WIDTH;
        groupWidth = minimumGroupWidth;
    }
	else if(groupWidth > maximumGroupWidth) {
        histogramData.groupSpcaing = groupWidth - DEFAULT_MAXIMUM_BAR_WIDTH*barCountPerGroup;
        histogramData.barWidth = DEFAULT_MAXIMUM_BAR_WIDTH;
    }
	else {
        histogramData.groupSpcaing = (1.0 - factor) * groupWidth;
		histogramData.barWidth = groupWidth/barCountPerGroup *factor;
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

- (void)caculateBarSizeAndFrameForDrawableAreaSize:(CGSize)drawableAreaSize
{
    NSArray *barGroups = [_histogramData barGroups];
    //    CGFloat barCountPerGroup = [_histogramData getBarCountPerGroup];
    CGFloat groupWidth = drawableAreaSize.width / [barGroups count];
    //    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCountPerGroup;
    {
        _histogramData.groupSpcaing = groupWidth - 8;//(1.0 - factor) * groupWidth;
        _histogramData.barWidth = 8;//groupWidth - (groupWidth*factor)/barCountPerGroup;
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
    return CGRectMake(marginX, marginY, _histogramData.barWidth, barHeight);
}

#pragma  mark - axis methods
- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _histogramData.coordinateSystem;
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
    ISSChartCoordinateSystem *coordinateSystem = _histogramData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueY / yAxis.valueRange - yAxis.minValue / yAxis.valueRange);
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    return marginY;
}

- (CGFloat)getMarginXWithBar:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = barGroup.index * barGroup.width + bar.index * _histogramData.barWidth;
    marginX += self.histogramData.coordinateSystem.leftMargin + _histogramData.groupSpcaing/2;
    return marginX;
}

- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = self.histogramData.coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:self.histogramData.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height, width - 5, height);
    return frame;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    CGFloat marginX = 0;
    NSArray *barGroups = [_histogramData barGroups];
    if (barGroups && [barGroups count]) {
        ISSChartHistogramBarGroup *group = barGroups[index];
        NSInteger barCount = [group.bars count];
        NSInteger barIndex = barCount/2;
        ISSChartHistogramBar *bar = group.bars[barIndex];
        marginX = [self getMarginXWithBar:bar group:group];
        if (barCount % 2) {
            marginX += _histogramData.barWidth/2;
        }
    }
    return marginX;
}

- (CGFloat)getMarginXWithValueX:(CGFloat)valueX
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramData.coordinateSystem;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueX - coordinateSystem.xAxis.baseValue) / coordinateSystem.xAxis.valueRange;
    CGFloat marginY = rate*drawAreaSize.width + coordinateSystem.topMargin;
    return marginY;
}

- (CGRect)hintViewFrame:(ISSChartHintView*)hintView bar:(ISSChartHistogramBar*)bar
{
    CGRect frame = bar.barProperty.frame;
    CGRect hintFrame = hintView.frame;
    hintFrame.origin.x = frame.origin.x + CGRectGetWidth(frame);
    hintFrame.origin.y = frame.origin.y - CGRectGetHeight(hintFrame)/2;
    return hintFrame;
}

- (void)showHintView:(ISSChartHintView*)hintView bar:(ISSChartHistogramBar*)bar
{
    if (hintView && bar) {
        hintView.frame = [self hintViewFrame:hintView bar:bar];
        [self addSubview:hintView];
        [hintView show];
    }
}

- (void)adjustHintViewPosition:(ISSChartHintView*)hintView offset:(CGSize)offset
{
    ISSChartHistogramHintView *histogramHintView = (ISSChartHistogramHintView*)hintView;
	histogramHintView.imageView.transform = CGAffineTransformIdentity;
    if (CGRectGetMaxX(hintView.frame) >= CGRectGetWidth(self.bounds)) {
        histogramHintView.imageView.transform = CGAffineTransformScale(histogramHintView.imageView.transform, -1, 1);
        histogramHintView.right = CGRectGetMinX(hintView.frame) - offset.width;
    }
    else {
    }
}

#pragma mark - public methods
- (UIView*)getFilterView:(UIImage*)image marginY:(CGFloat)marginY top:(BOOL)top
{
    CGRect frame = CGRectMake(0, marginY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    CGFloat lineHeight = 1.0;
    contentView.backgroundColor = [UIColor whiteColor];
    if (!top) {
        CGFloat height = _histogramData.coordinateSystem.bottomMargin;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineHeight, CGRectGetWidth(self.bounds), height)];
        imageView.image = image;
        [contentView addSubview:imageView];
        [imageView release];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), lineHeight)];
        lineView.backgroundColor = [UIColor greenColor];
        [contentView addSubview:lineView];
        [lineView release];
    }
    else {
        CGFloat height = _histogramData.coordinateSystem.topMargin;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - lineHeight - height, CGRectGetWidth(self.bounds), height)];
        imageView.image = image;
        [contentView addSubview:imageView];
        [imageView release];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - lineHeight, CGRectGetWidth(self.bounds), lineHeight)];
        lineView.backgroundColor = [UIColor redColor];
        [contentView addSubview:lineView];
        [lineView release];
    }
    return [contentView autorelease];
}

- (void)filterVisiableAreaByValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
{
    CGFloat minValueMarginY = [self getYAxisMarginYWithValueY:minValue];
    CGFloat maxValueMarginY = [self getYAxisMarginYWithValueY:maxValue];
    CGRect rect = _axisView.bounds;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(rect.size, FALSE, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [_axisView.layer renderInContext:ctx];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat height = _histogramData.coordinateSystem.bottomMargin;
    CGRect frame = CGRectMake(0, scale*(CGRectGetHeight(self.bounds) - height + 1), scale*CGRectGetWidth(self.bounds), scale*height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], frame);
    UIImage *miniFileterImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    _minimumValueFilterView = [[self getFilterView:miniFileterImage marginY:CGRectGetHeight(self.bounds) - height top:FALSE] retain];
    height = _histogramData.coordinateSystem.topMargin;
    _maxmumValueFilterView = [[self getFilterView:nil marginY:height - CGRectGetHeight(self.bounds) top:TRUE] retain];
    
    [self insertSubview:_maxmumValueFilterView belowSubview:_legendView];
    [self insertSubview:_minimumValueFilterView belowSubview:_legendView];
    [UIView animateWithDuration:0.3 animations:^{
        _minimumValueFilterView.top = minValueMarginY;
        _maxmumValueFilterView.bottom = maxValueMarginY;
    }];
}

- (void)selectedBar:(ISSChartHistogramBar*)bar
{
    bar.barProperty.selected = TRUE;
    [_histogramContentView setNeedsDisplayInRect:bar.barProperty.frame];
}

- (void)deselectedBar:(ISSChartHistogramBar*)bar
{
    bar.barProperty.selected = FALSE;
    [_histogramContentView setNeedsDisplayInRect:bar.barProperty.frame];
}

- (void)resetFilter
{
    if (_minimumValueFilterView && _maxmumValueFilterView) {
        [UIView animateWithDuration:0.3 animations:^{
            _minimumValueFilterView.top = CGRectGetHeight(self.bounds);
            _maxmumValueFilterView.top  = -CGRectGetHeight(self.bounds);
            _minimumValueFilterView.alpha = 0.0;
            _maxmumValueFilterView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                if (_minimumValueFilterView) {
                    [_minimumValueFilterView removeFromSuperview];
                }
                RELEASE_SAFELY(_minimumValueFilterView);
                if (_maxmumValueFilterView) {
                    [_maxmumValueFilterView removeFromSuperview];
                }
                RELEASE_SAFELY(_maxmumValueFilterView);
            }
        }];
    }
}

- (ISSChartHistogramBar*)findSelectedBarIndexWithLocatin:(CGPoint)location
{
    ISSChartHistogramBar *selectedBar = nil;
    for (ISSChartHistogramBarGroup *group in [_histogramData barGroups]) {
        NSArray *bars = group.bars;
        for (ISSChartHistogramBar *bar in bars) {
            if ([self isPointOnBar:bar location:location]) {
                selectedBar = bar;
                break;
            }
        }
    }
    return selectedBar;
}

- (ISSChartHistogramBar*)findBarIndexWithLocatin:(CGPoint)location
{
    ISSChartHistogramBar *selectedBar = nil;
    for (ISSChartHistogramBarGroup *group in [_histogramData barGroups]) {
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

- (CGRect)getHintViewFrame:(CGRect)frame location:(CGPoint)location
{
    frame.origin.x = location.x + 15;
    frame.origin.y = location.y - CGRectGetHeight(frame)/2;
    return frame;
}

- (void)showHintLineView:(BOOL)show
{
    CGFloat alpha = 0.0;
    if (show) {
        if (!_hintLineView) {
            ISSChartCoordinateSystem *coordinateSystem = _histogramData.coordinateSystem;
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
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _histogramData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _histogramData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)handleHintViewOnLocation:(CGPoint)location
{
    ISSChartHistogramBar *bar = [self findBarIndexWithLocatin:location];
    if (bar) {
        NSInteger index = bar.groupIndex * [_histogramData barCountOfPerGroup] + bar.index;
        if(NSNotFound == _previousIndex||_previousIndex != index) {
            if (_didSelectedBarBlock) {
                ISSChartHintView *hintView = _didSelectedBarBlock(self, bar, [_histogramData getXAxisItemWithBar:bar]);
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

#pragma mark - gesture recognizer
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
    ISSChartHistogramBar *bar = [self findBarIndexWithLocatin:location];
    if (bar) {
		if (_didTappedOnBarBlock) {
			_didTappedOnBarBlock(self, bar, [_histogramData getXAxisItemWithBar:bar]);
		}
	}
}

- (void)handlePan:(UITapGestureRecognizer*)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
	UIGestureRecognizerState state = gestureRecognizer.state;
	switch (state) {
		case UIGestureRecognizerStateBegan:
			if (_shouldShowHintLine) {
				[self showHintLineView:TRUE];
				[self updateHintLineViewFrame:location];
				[self handleHintViewOnLocation:location];
			}
			break;
		case UIGestureRecognizerStateChanged:
			if (_shouldShowHintLine) {
				[self updateHintLineViewFrame:location];
				[self handleHintViewOnLocation:location];
			}
			break;
		case UIGestureRecognizerStateEnded:case UIGestureRecognizerStateCancelled:
			if (_shouldShowHintLine) {
				[self showHintLineView:FALSE];
				_previousIndex = NSNotFound;
				[self recycleAllHintViews];
			}
			break;
		default:
			break;
	}
}
@end