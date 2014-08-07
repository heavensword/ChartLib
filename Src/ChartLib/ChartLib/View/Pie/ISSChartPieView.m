//
//  ISSChartPieView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartPieView.h"
#import "ISSChatGallery.h"
#import "ISSChartPieContentView.h"
#import "ISSChartPieLegendView.h"
#import "ISSChartPieData.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartPieSection.h"
#import "ISSChartPieSectionProperty.h"

@interface ISSChartPieView()
{
    ISSChartPieContentView *_pieContentView;
    ISSChartPieLegendView  *_legendView;
}

@end

@implementation ISSChartPieView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
	Block_release(_didSelectSection);
    [_legendView release];
    [_pieContentView release];
    [_pieData release];
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

- (id)initWithFrame:(CGRect)frame pieData:(ISSChartPieData*)pieData
{
    self = [super initWithFrame:frame];
    if (self) {
        _pieContentView = [[ISSChartPieContentView alloc] initWithFrame:self.bounds];
        _legendView = [[ISSChartPieLegendView alloc] initWithFrame:CGRectZero];
        _pieContentView.alpha = 0.0;
        _legendView.alpha = 0.0;
        self.pieData = pieData;
        [self addSubview:_pieContentView];
        [self addSubview:_legendView];
    }
    return self;
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_pieData.coordinateSystem];
}

- (CGRect)getDrawableFrame
{
    CGRect frame = self.bounds;
    return frame;
}

- (void)adjustContentViewFrame
{
    _pieContentView.frame = [self getDrawableFrame];
}

- (ISSChartPieData*)getZeroDegreePieData
{
    ISSChartPieData *zeroPieData = [_pieData copy];
    NSArray *sections = zeroPieData.sections;
    for (ISSChartPieSection *pieSection in sections) {
        pieSection.pieSectionProperty.endDegree = pieSection.pieSectionProperty.startDegree;
    }
    return [zeroPieData autorelease];
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
    ISSChartPieData *originPieData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartPieData *destionationPieData = userInfo[KEY_NEW_VALUE];
    ISSChartPieData *currentPieData = [destionationPieData copy];
    ISSChartPieSection  *originPieSection;
    ISSChartPieSection  *destionationPieSection;
    ISSChartPieSection  *currentPieSection;
    
    ISSChartPieSectionProperty *originSectionProperty;
    ISSChartPieSectionProperty *destinationSectionProperty;
    ISSChartPieSectionProperty *currentSectionProperty;
    NSInteger count = [originPieData.sections count];
    CGFloat offsetDegree;
    for (NSInteger i = 0; i < count; i++) {
        originPieSection = originPieData.sections[i];
        destionationPieSection = destionationPieData.sections[i];
        originSectionProperty = originPieSection.pieSectionProperty;
        destinationSectionProperty = destionationPieSection.pieSectionProperty;
        offsetDegree = destinationSectionProperty.endDegree - originSectionProperty.endDegree;
        currentPieSection = currentPieData.sections[i];
        currentSectionProperty = currentPieSection.pieSectionProperty;
        currentSectionProperty.endDegree = originSectionProperty.endDegree + offsetDegree*progress;
    }
    _pieContentView.alpha = 1.0 * progress;
    _legendView.alpha = 1.0 * progress;
    self.pieData = currentPieData;
    [currentPieData release];
    if (final) {
        self.userInteractionEnabled = TRUE;
        self.pieData = destionationPieData;
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

#pragma mark - public methods
- (void)animationWithData:(id)chartData completion:(void (^)(BOOL))completion
{
    [self animationWithPieData:chartData completion:completion];
}

- (void)setPieData:(ISSChartPieData *)pieData
{
    RELEASE_SAFELY(_pieData);
    _pieData = [pieData retain];
    
    BOOL shouldAdjust = FALSE;
    if (_pieData.legendTextArray && [_pieData.legendTextArray count]) {
        shouldAdjust = TRUE;
    }
    [self caculateDrawableAreaSize];
    if (shouldAdjust) {
        _legendView.frame = [self getLegendFrame:_pieData.coordinateSystem legendPosition:_pieData.legendPosition];
        [self adjustContentViewFrame];
    }
	
	[pieData readyData];
    _pieContentView.pieData = _pieData;
    _legendView.direction = [_pieData getLegendDirection];
    _legendView.chartData = _pieData;
}

- (void)displayFirstShowAnimation
{
    if (_isFirstDisplay) {
        _isFirstDisplay = FALSE;
        self.userInteractionEnabled = FALSE;
        ISSChartPieData *zeroPieData = [self getZeroDegreePieData];
        CGFloat interval = 1.0/kISSChartAnimationFPS;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[KEY_ITERTATION] = @(0);
        userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
        userInfo[KEY_ORIGIN_VALUE] = zeroPieData;
        userInfo[KEY_NEW_VALUE] = _pieData;
        self.pieData = zeroPieData;
        [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
    }
}

- (void)animationWithPieData:(ISSChartPieData*)pieData completion:(void (^)(BOOL))completion
{
    NSAssert([pieData isKindOfClass:[ISSChartPieData class]], @"chart data is not pie date format!");
    if (pieData && pieData != _pieData) {
        _isFirstDisplay = TRUE;
        RELEASE_SAFELY(_pieData);
        _pieData = [pieData retain];
        _pieContentView.alpha = 0.0;
        _legendView.alpha = 0.0;
        self.userInteractionEnabled = FALSE;
        ISSChartPieData *zeroPieData = [self getZeroDegreePieData];
        CGFloat interval = 1.0/kISSChartAnimationFPS;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[KEY_ITERTATION] = @(0);
        userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
        userInfo[KEY_ORIGIN_VALUE] = zeroPieData;
        userInfo[KEY_NEW_VALUE] = _pieData;
        if (nil != completion) {
            void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
            userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
        }
        self.pieData = zeroPieData;
        [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                       selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
    }
}

#pragma mark - gesture recognizer
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint location = [gestureRecognizer locationInView:self];
    ISSChartPieSection *pieSection = [_pieData findSelectedPieSectionWithLocation:location];
    if (pieSection) {
		ISSChartLegend *legend = self.pieData.legends[pieSection.pieSectionProperty.index];
		_didSelectSection(self, pieSection, legend);
	}
}
@end
