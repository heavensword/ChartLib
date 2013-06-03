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
#import "ISSChartHistogramData.h"
#import "ISSChartBar.h"
#import "ISSChartBarProperty.h"
#import "ISSChartBarGroup.h"
#import "NSString+ITTAdditions.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartHistogramCoordinateSystem.h"
#import "ISSChatGallery.h"

@interface ISSChartHistogramView()
{
    CGFloat             _barWidth;
    CGFloat             _spacing;
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
    Block_release(_didSelectedBarBlock);
    [_histogram release];
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
        _histogramContentView = [[ISSChartHistogramContentView alloc] initWithFrame:self.bounds];
        _histogramContentView.histogram = histogram;
        
        _axisView = [[ISSChartHistogramAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = histogram.coordinateSystem;
        _axisView.histogramView = self;
        
        self.histogram = histogram;
        [self addSubview:_axisView];        
        [self addSubview:_histogramContentView];
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

- (void)setHistogram:(ISSChartHistogramData *)histogram
{
    [_histogram release];
    _histogram = nil;
    _histogram = [histogram retain];
    
    [self caculateBarSizeAndFrame];
    _histogramContentView.histogram = _histogram;
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
    NSInteger count = [currentHistogram.bars count];
    for (NSInteger i = 0; i < count; i++) {
        ISSChartBar *oldBar = [originHistogram.bars objectAtIndex:i];
        ISSChartBar *newBar = [newHistogram.bars objectAtIndex:i];
        ISSChartBar *currentBar = [currentHistogram.bars objectAtIndex:i];
        
        CGFloat offsetValueX= newBar.valueX - oldBar.valueX;
        CGFloat offSetValueY = newBar.valueY - oldBar.valueY;
        CGFloat valueX = oldBar.valueX + offsetValueX * progress;
        CGFloat valueY = oldBar.valueY + offSetValueY * progress;
        currentBar.valueX = valueX;
        currentBar.valueY = valueY;
    }
    self.histogram = currentHistogram;
    [currentHistogram release];
    if (final) {
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

- (void)animationWithNewHistogram:(ISSChartHistogramData*)historgram completion:(void (^)(BOOL))completion
{
    if (historgram && [historgram.bars count]) {
        NSAssert((self.histogram != historgram), @"the same histogram!");
        NSAssert(([self.histogram.bars count] == [historgram.bars count]), @"the number of bars isn't equal!");
        
        CGFloat interval = 1.0/kISSChartAnimationFPS;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[KEY_ITERTATION] = @(0);
        userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
        userInfo[KEY_ORIGIN_VALUE] = self.histogram;
        userInfo[KEY_NEW_VALUE] = historgram;
        if (completion != nil) {
            void (^completionHandlerCopy)(BOOL) = Block_copy(completion);
            userInfo[KEY_COMPLETION_BLOCK] = completionHandlerCopy;
        }
        [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                       selector:@selector(dataUpdateAnimation:) userInfo:userInfo repeats:TRUE];
    }
}

#pragma mark - private methods
- (NSInteger)findSelectedBarIndexWithLocatin:(CGPoint)location
{
    NSInteger found = NSNotFound;
    NSInteger index = 0;
    for (ISSChartBar *bar in _histogram.bars) {
        ISSChartBarProperty *property = bar.barProperty;
        if (CGRectContainsPoint(property.frame, location)) {
            found = index;
            break;
        }
        index++;
    }
    return found;
}

#pragma mark - private methods

- (CGSize)axisDrawAreaSize
{
    CGSize size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * self.histogram.coordinateSystem.xAxis.axisProperty.padding, CGRectGetHeight(self.bounds) -  2 * self.histogram.coordinateSystem.yAxis.axisProperty.padding);
    return size;
}

- (CGRect)getDrawAreaFrame
{
    CGSize drawAreaSize = [self axisDrawAreaSize];
    ISSChartCoordinateSystem *coordinateSystem = self.histogram.coordinateSystem;
    CGFloat marginX = coordinateSystem.xAxis.axisProperty.padding;
    CGFloat marginY = coordinateSystem.yAxis.axisProperty.padding;
    return CGRectMake(marginX, marginY, drawAreaSize.width, drawAreaSize.height);
}

- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    CGSize drawAreaSize = [self axisDrawAreaSize];
    ISSChartAxis *yAxis = self.histogram.coordinateSystem.yAxis;
    CGFloat rate =  (valueY - yAxis.baseValue)/yAxis.valueRange;
    CGFloat height = drawAreaSize.height * rate;
    return height;
}

- (CGFloat)getMarginXWithBar:(ISSChartBar*)bar group:(ISSChartBarGroup*)barGroup
{
    CGFloat marginX = barGroup.index * barGroup.width + bar.barProperty.index * _barWidth;
    marginX += self.histogram.coordinateSystem.xAxis.axisProperty.padding + _spacing/2;
    return marginX;
}

- (CGFloat)getMarginXWithValueX:(CGFloat)valueX
{
    CGSize drawAreaSize = [self axisDrawAreaSize];
    CGFloat rate =  (valueX - self.histogram.coordinateSystem.xAxis.baseValue)/self.histogram.coordinateSystem.xAxis.valueRange;
    CGFloat marginY = rate*drawAreaSize.width + self.histogram.coordinateSystem.xAxis.axisProperty.padding;
    return marginY;
}

- (CGFloat)getMarginYWithValueY:(CGFloat)valueY
{
    CGSize drawAreaSize = [self axisDrawAreaSize];
    ISSChartAxis *yAxis = self.histogram.coordinateSystem.yAxis;
    CGFloat rate =  valueY / yAxis.valueRange;    
    CGFloat marginY = drawAreaSize.height + yAxis.axisProperty.padding - rate*drawAreaSize.height;
    return marginY;
}

- (void)caculateBarSizeAndFrame
{
    ISSChartBarGroup *barGroup = _histogram.barGroups[0];
    CGFloat barCount = [barGroup.bars count];
    CGRect drawAreaFrame = [self getDrawAreaFrame];
    CGFloat groupWidth = drawAreaFrame.size.width / [self.histogram.barGroups count];
    CGFloat minimumGroupWidth = DEFAULT_BAR_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCount;
    CGFloat factor = 0.618;
    if (groupWidth < minimumGroupWidth) {
        _spacing = DEFAULT_BAR_SPACING;
        _barWidth = DEFAULT_MINIMUM_BAR_WIDTH;
        groupWidth = minimumGroupWidth;
    }
    else {
        _spacing = (1.0 - factor) * groupWidth;
        _barWidth = (groupWidth*factor)/barCount;
    }
    for (ISSChartBarGroup *group in _histogram.barGroups) {
        group.width = groupWidth;
        for (ISSChartBar *bar in group.bars) {
            ISSChartBarProperty *property = bar.barProperty;
            property.frame = [self getBarFrame:bar group:group];
        }
    }
}

- (CGRect)getBarFrame:(ISSChartBar*)bar group:(ISSChartBarGroup*)barGroup
{
    CGFloat marginX = [self getMarginXWithBar:bar group:barGroup];
    CGFloat marginY = [self getMarginYWithValueY:bar.valueY];
    CGFloat barHeight = [self getHeightWithValue:bar.valueY];
    return CGRectMake(marginX, marginY, _barWidth, barHeight);
}

#pragma  mark - axis methods
- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = self.histogram.coordinateSystem.xAxis.axisProperty.padding;
    CGFloat height = [label heightWithFont:self.histogram.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height/2, width - 5, height);
    return frame;
}

- (CGRect)getXLableFrame:(CGFloat)marginX text:(NSString*)label
{
    ISSChartAxis *yAxis = self.histogram.coordinateSystem.yAxis;
    CGFloat height = yAxis.axisProperty.padding;
    CGFloat marginY = CGRectGetHeight(self.bounds) - height/1.25;
    CGFloat width = [label widthWithFont:self.histogram.coordinateSystem.xAxis.axisProperty.labelFont withLineHeight:height];
    CGRect frame = CGRectMake(marginX - width/2, marginY, width, height);
    return frame;
}

- (CGFloat)getAxisXMarginXWithIndex:(NSInteger)index
{
    ISSChartBarGroup *group = _histogram.barGroups[index];
    NSInteger barCount = [group.bars count];
    NSInteger barIndex = barCount/2;
    ISSChartBar *bar = group.bars[barIndex];
    CGFloat marginX = [self getMarginXWithBar:bar group:group];
    if (barCount % 2) {
        marginX += _barWidth/2;
    }
    return marginX;
}

- (CGFloat)getAxisMarginYWithValueY:(CGFloat)valueY
{
    CGSize drawAreaSize = [self axisDrawAreaSize];
    CGFloat rate =  (valueY )/self.histogram.coordinateSystem.yAxis.valueRange;
    //    CGFloat marginY = drawAreaSize.height + 2*self.coordinateSystem.yAxisData.axisProperty.padding - (rate*drawAreaSize.height + self.coordinateSystem.yAxisData.axisProperty.padding + _baseYMargin);
    CGFloat marginY = drawAreaSize.height + self.histogram.coordinateSystem.yAxis.axisProperty.padding - rate*drawAreaSize.height;
    return marginY;
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[touches anyObject] locationInView:self];
    NSInteger index = [self findSelectedBarIndexWithLocatin:location];
    if (NSNotFound != index) {
        if (_didSelectedBarBlock) {
            _didSelectedBarBlock(self, index);            
        }
    }
}
@end
