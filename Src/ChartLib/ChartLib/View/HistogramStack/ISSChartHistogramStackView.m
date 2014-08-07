//
//  ISSChartHistogramStackView.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackView.h"
#import "ISSChartHistogramStackAxisView.h"
#import "ISSChartHistogramStackLegendView.h"
#import "ISSChartHintView.h"
#import "ISSChartLineContentView.h"
#import "ISSChartHistogramStackContentView.h"

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



#import "ISSChartHistogramStackData.h"
#import "ISSChartHistogramStackView.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartHistogramStackHintView.h"

@interface ISSChartHistogramStackView()
{
    ISSChartHistogramStackLegendView     *_legendView;
    ISSChartHistogramStackContentView    *_histogramStackContentView;
    ISSChartLineContentView              *_lineContentView;

    UIView                     *_hintLineView;
    NSInteger                  _previousIndex;    
}
@end

@implementation ISSChartHistogramStackView

+ (void)load
{
    [[ISSChatGallery sharedInstance] registerChart:self];
}

- (void)dealloc
{
    Block_release(_didSelectedAreaPointBlock);
    [_lineContentView release];
    [_legendView release];
    [_histogramStackData release];
    [_histogramStackContentView release];
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

- (id)initWithFrame:(CGRect)frame histogramStackData:(ISSChartHistogramStackData*)histogramStackData
{
    self = [super initWithFrame:frame];
    if (self) {
        _drawableAreaSize = self.bounds.size;
        ITTDINFO(@"_drawableAreaSize:%@",NSStringFromCGRect(self.bounds));
        _histogramStackContentView = [[ISSChartHistogramStackContentView alloc] initWithFrame:self.bounds];
        _histogramStackContentView.alpha = 0.0;
        
        _lineContentView = [[ISSChartLineContentView alloc] initWithFrame:self.bounds];
        _lineContentView.alpha = 0;
        
        _axisView = [[ISSChartHistogramStackAxisView alloc] initWithFrame:self.bounds];
        _axisView.coordinateSystem = histogramStackData.coordinateSystem;
        _axisView.containerView = self;
        
        _legendView = [[ISSChartHistogramStackLegendView alloc] initWithFrame:CGRectZero];
        
        self.histogramStackData = histogramStackData;
        [self addSubview:_axisView];
        [self addSubview:_histogramStackContentView];
        [self addSubview:_lineContentView];
        [self addSubview:_legendView];
    }
    return self;
}

-(void)setHistogramStackData:(ISSChartHistogramStackData *)histogramStackData
{
    RELEASE_SAFELY(_histogramStackData);
    _histogramStackData = [histogramStackData retain];
    
    BOOL shouldAdjust = FALSE;
    if (_histogramStackData.legendTextArray && [_histogramStackData.legendTextArray count]) {
        shouldAdjust = TRUE;
    }
    [self caculateDrawableAreaSize];
    [self caculateBarSizeAndFrame];
    [self caculateGraduationWidthAndSpacing];
//    [self caculatePointPosition];
    if (shouldAdjust) {
        _legendView.frame = [self getLegendFrame:_histogramStackData.coordinateSystem legendPosition:_histogramStackData.legendPosition];
        [self adjustContentViewFrame];
        [self adjustAxisViewFrame];
    }
    _axisView.coordinateSystem = _histogramStackData.coordinateSystem;
    _histogramStackContentView.barGroups = [_histogramStackData getBarGroupArray];
//    _lineContentView.lines = _histogramStackData.lines;
    _legendView.direction = [_histogramStackData getLegendDirection];
    _legendView.chartData = _histogramStackData;
}

- (void)dataUpdateAnimation:(NSTimer*)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    CGFloat iteration = [userInfo[KEY_ITERTATION] floatValue];
    CGFloat duration = [userInfo[KEY_DURATION] floatValue];
    CGFloat progress = iteration/(duration * kISSChartAnimationFPS);
    BOOL final = FALSE;
    iteration++;
    
    ISSChartHistogramStackData *originHistogramStackData = userInfo[KEY_ORIGIN_VALUE];
    ISSChartHistogramStackData *newHistogramStackData = userInfo[KEY_NEW_VALUE];
    
    if (iteration >= floor(duration*kISSChartAnimationFPS)) {
        final = TRUE;
        progress = 1.0;
    }
    userInfo[KEY_ITERTATION] = @(iteration);
    ISSChartHistogramStackData *currentHistogramStackData = [newHistogramStackData copy];
    NSInteger count = 0;
    NSInteger groupCount = [[originHistogramStackData getBarGroupArray] count];
    for (NSInteger group = 0; group < groupCount; group++) {
        ISSChartHistogramBarGroup *oldBarGroup = [originHistogramStackData getBarGroupArray][group];
        ISSChartHistogramBarGroup *newBarGroup = [newHistogramStackData getBarGroupArray][group];
        ISSChartHistogramBarGroup *currentBarGroup = [currentHistogramStackData getBarGroupArray][group];
        count = [oldBarGroup.bars count];
        for (NSInteger i = 0; i < count; i++) {
            ISSChartHistogramBar *oldBar = [oldBarGroup.bars objectAtIndex:i];
            ISSChartHistogramBar *newBar = [newBarGroup.bars objectAtIndex:i];
            ISSChartHistogramBar *currentBar = [currentBarGroup.bars objectAtIndex:i];
            CGFloat offSetValueY = newBar.valueY - oldBar.valueY;
            CGFloat valueY = oldBar.valueY + offSetValueY * progress;
            currentBar.valueY = valueY;
        }
    }
    /*
    CGFloat oldValue;
    CGFloat newValue;
    CGFloat currentValue;
    CGFloat offSetValue;

    NSInteger lineCount = [newHistogramStackData.lines count];
    for (NSInteger i = 0; i < lineCount; i++) {
        ISSChartLine *oldLine = originHistogramStackData.lines[i];
        ISSChartLine *newLine = newHistogramStackData.lines[i];
        ISSChartLine *currentLine = currentHistogramStackData.lines[i];
        count = [oldLine.values count];
        NSMutableArray *currentValues = [[NSMutableArray alloc] initWithCapacity:count];
        for (NSInteger j = 0; j < count; j++) {
            oldValue = [oldLine.values[j] floatValue];
            newValue = [newLine.values[j] floatValue];
            offSetValue = newValue - oldValue;
            currentValue = oldValue + offSetValue * progress;
            [currentValues addObject:@(currentValue)];
        }
        currentLine.values = currentValues;
        [currentValues release];
    }
     */
    self.histogramStackData = currentHistogramStackData;
    [currentHistogramStackData release];
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

#pragma mark - private methods
- (ISSChartHistogramBar*)findSelectedBarIndexWithLocatin:(CGPoint)location
{
    ISSChartHistogramBar *selectedBar = nil;
    for (ISSChartHistogramBarGroup *group in [_histogramStackData getBarGroupArray]) {
        NSArray *bars = group.bars;
        for (ISSChartHistogramBar *bar in bars) {
            if (CGRectContainsPoint(bar.barProperty.frame, location)) {
                selectedBar = bar;
                break;
            }
        }
    }
    return selectedBar;
}

#pragma mark - private methods
- (void)caculateGraduationWidthAndSpacing
{
    NSInteger count = [_histogramStackData.coordinateSystem.xAxis.axisItems count];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat gridWidth = drawableAreaSize.width / count;
    CGFloat minimumGridWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH;
    CGFloat spacing;
    CGFloat factor = 0.618;
    if (gridWidth < minimumGridWidth) {
        spacing = DEFAULT_BAR_GROUP_SPACING;
        gridWidth = minimumGridWidth;
    }
    else {
        spacing = (1.0 - factor) * gridWidth;
    }
    _histogramStackData.graduationWidth = gridWidth;
    _histogramStackData.graduationSpacing = spacing;
}

//---
/*
- (void)caculatePointPosition
{
    NSInteger index;
    CGFloat marginX;
    CGFloat marginY;
    NSValue *pointValue;
    NSMutableArray *points;
    for (ISSChartLine *line in _histogramStackData.lines) {
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

- (void)adjustContentViewFrame
{
    _histogramStackContentView.frame = [self getDrawableFrame];
    _lineContentView.frame = [self getDrawableFrame];
}

- (void)adjustAxisViewFrame
{
    _axisView.frame = [self getDrawableFrame];
}

- (void)caculateDrawableAreaSize
{
    [self caculateDrawableAreaSize:_histogramStackData.coordinateSystem];
}

- (CGSize)getDrawableAreaSize
{
    return _drawableAreaSize;
}

- (CGFloat)getHeightWithValue:(CGFloat)valueY
{
    CGSize drawAreaSize = [self getDrawableAreaSize];
    ISSChartAxis *yAxis = _histogramStackData.coordinateSystem.yAxis;
    CGFloat rate =  (valueY - yAxis.baseValue)/yAxis.valueRange;
    CGFloat height = drawAreaSize.height * rate;
    return height;
}

- (CGFloat)getMarginXWithBar:(ISSChartHistogramBar*)bar group:(ISSChartHistogramBarGroup*)barGroup
{
    CGFloat marginX = barGroup.index * barGroup.width ;
    marginX += _histogramStackData.coordinateSystem.leftMargin + _histogramStackData.groupSpcaing/2;
    return marginX;
}

- (CGFloat)getMarginXWithValueX:(CGFloat)valueX
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramStackData.coordinateSystem;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    CGFloat rate =  (valueX - coordinateSystem.xAxis.baseValue) / coordinateSystem.xAxis.valueRange;
    CGFloat marginX = rate*drawAreaSize.width + coordinateSystem.topMargin;
    return marginX;
}


- (CGFloat)getMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramStackData.coordinateSystem;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGFloat rate =  (valueY - yAxis.baseValue) / yAxis.valueRange;
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;

    
    return marginY;
}


- (CGFloat)getViceYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramStackData.coordinateSystem;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    ISSChartAxis *viceYAxis = coordinateSystem.viceYAxis; 
    CGFloat rate =  valueY / viceYAxis.valueRange;
    CGFloat marginY = coordinateSystem.topMargin + (1 - rate)*drawAreaSize.height;
    return marginY;
}

- (void)caculateBarSizeAndFrame
{
    NSArray *barGroups = [_histogramStackData getBarGroupArray];
    CGFloat barCountPerGroup = [_histogramStackData  getBarCountPerGroup];
    CGSize drawableAreaSize = [self getDrawableAreaSize];
    CGFloat groupWidth = drawableAreaSize.width / [barGroups count];
    CGFloat minimumGroupWidth = DEFAULT_BAR_GROUP_SPACING + DEFAULT_MINIMUM_BAR_WIDTH * barCountPerGroup;
    CGFloat factor = 0.618;
    if (groupWidth < minimumGroupWidth) {
        _histogramStackData.groupSpcaing = DEFAULT_BAR_GROUP_SPACING;
        _histogramStackData.barWidth = minimumGroupWidth;
        groupWidth = minimumGroupWidth;
    }else {
        _histogramStackData.groupSpcaing = (1.0 - factor) * groupWidth;
        _histogramStackData.barWidth = (groupWidth*factor);
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
    return CGRectMake(marginX, marginY, _histogramStackData.barWidth, barHeight);
}

#pragma  mark - axis methods
- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    CGFloat width = _histogramStackData.coordinateSystem.leftMargin;
    CGFloat height = [label heightWithFont:_histogramStackData.coordinateSystem.yAxis.axisProperty.labelFont withLineWidth:width];
    CGRect frame = CGRectMake(0, marginY - height/2, width - 5, height);
    return frame;
}


- (CGRect)getViceYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramStackData.coordinateSystem;
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
    UIFont *font = _histogramStackData.coordinateSystem.xAxis.axisProperty.labelFont;
    CGFloat width = [label widthWithFont:font withLineHeight:textHeight];
    textHeight = [label heightWithFont:font withLineWidth:width];
    CGFloat radian = degreesToRadian(_histogramStackData.coordinateSystem.xAxis.rotateAngle);
    CGFloat offsetHeight = 0;
    if (radian && radian != M_PI) {
        if (radian > M_PI) {
            radian = 2*M_PI - radian;
        }
        offsetHeight = fabsf((width * fabs(sin(radian)) - textHeight)/2);
        textHeight = width * fabs(sin(radian));
    }
    CGFloat marginY = [self getDrawableAreaSize].height + _histogramStackData.coordinateSystem.topMargin + offsetHeight;
//    NSInteger count = [_histogramStackData.coordinateSystem.xAxis.axisItems count];
//    CGSize drawableAreaSize = [self getDrawableAreaSize];
//    CGFloat gridWidth = drawableAreaSize.width / count;
    CGRect frame = CGRectMake(marginX , marginY, width, textHeight);
    return frame;
}

- (CGFloat)getXAxisMarginXWithIndex:(NSInteger)index
{
    ISSChartHistogramBarGroup *group = [_histogramStackData getBarGroupArray][index];
    NSInteger barCount = [group.bars count];
    NSInteger barIndex = barCount/2;
    ISSChartHistogramBar *bar = group.bars[barIndex];
    CGFloat marginX = [self getMarginXWithBar:bar group:group];
//    if (barCount % 2) {
        marginX += _histogramStackData.barWidth/2;
//    }
    return marginX;
}

- (CGFloat)getYAxisMarginYWithValueY:(CGFloat)valueY
{
    ISSChartCoordinateSystem *coordinateSystem = _histogramStackData.coordinateSystem;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    ITTDINFO(@"drawAreaSize:%@",NSStringFromCGSize(drawAreaSize));
    CGFloat rate =  (valueY - yAxis.baseValue)/ yAxis.valueRange;
    ITTDINFO(@"yAxis.valueRange:%f drawAreaSize.height:%f",yAxis.valueRange,drawAreaSize.height);
    CGFloat marginY = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;

    return marginY;
}

- (void)showHintView:(ISSChartHintView*)hintView bar:(ISSChartHistogramBar*)bar
{
    if (hintView && bar) {
        CGRect frame = bar.barProperty.frame;
        CGRect hintFrame = hintView.frame;
        hintFrame.origin.x = frame.origin.x + CGRectGetWidth(frame);
        hintFrame.origin.y = frame.origin.y - CGRectGetHeight(hintFrame);
        hintView.frame = hintFrame;
        [self addSubview:hintView];
        [hintView show];
    }
}

#pragma mark - public methods

- (void)displayFirstShowAnimation
{
    if (_isFirstDisplay) {
        self.userInteractionEnabled = FALSE;
        
        CGRect originFrame = _histogramStackContentView.frame;
        CGRect currentFrame = originFrame;
        currentFrame.size.height = 2*_histogramStackData.coordinateSystem.bottomMargin;
        currentFrame.origin.y = CGRectGetMaxY(originFrame) - 2*_histogramStackData.coordinateSystem.bottomMargin;
        _histogramStackContentView.frame = currentFrame;
        
        CGRect lineOriginFrame = _lineContentView.frame;
        currentFrame = lineOriginFrame;
        currentFrame.size.width = _histogramStackData.coordinateSystem.leftMargin;
        _lineContentView.frame = currentFrame;
        
        ITTDINFO(@"currentFrame:%@",NSStringFromCGRect(currentFrame));
        _histogramStackContentView.alpha = 1.0;
        _lineContentView.alpha = 1.0;
        
        [UIView animateWithDuration:kISSChartFirstAnimationDuration animations:^{
            _histogramStackContentView.frame = originFrame;
            _lineContentView.frame = lineOriginFrame;
        } completion:^(BOOL finished){
            if (finished) {
                self.userInteractionEnabled = TRUE;
                _isFirstDisplay = FALSE;
            }
        }];
    }
}

- (void)animationWithData:(id)chartData
{
    if (chartData) {
        NSAssert([chartData isKindOfClass:[ISSChartHistogramLineData class]], @"chart data is not pie date format!");
        [self animationWithNewHistogramStack:chartData completion:NULL];
    }
}

- (void)animationWithNewHistogramStack:(ISSChartHistogramStackData*)histogramStackData completion:(void (^)(BOOL))completion
{
    if (histogramStackData && _histogramStackData != histogramStackData) {
        
        if ([[_histogramStackData getBarGroupArray] count] != [[histogramStackData getBarGroupArray] count]) {
            self.histogramStackData = histogramStackData;
            _histogramStackContentView.alpha = 0.0;
            _lineContentView.alpha = 0.0;
            _isFirstDisplay = TRUE;
            [self displayFirstShowAnimation];
        }
        else {
            CGFloat interval = 1.0/kISSChartAnimationFPS;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[KEY_ITERTATION] = @(0);
            userInfo[KEY_DURATION] = @(kISSChartAnimationDuration);
            userInfo[KEY_ORIGIN_VALUE] = _histogramStackData
;
            userInfo[KEY_NEW_VALUE] = histogramStackData;
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

- (float)getColumnWidth
{
    return  _drawableAreaSize.width / self.histogramStackData.coordinateSystem.xAxis.axisItems.count;
}


- (NSInteger)findValueIndexAtLocation:(CGPoint)location
{
    NSInteger found = NSNotFound;
    ISSChartCoordinateSystem *coordinateSystem =  _histogramStackData.coordinateSystem;
    found = (location.x - coordinateSystem.leftMargin)/[self getColumnWidth];
    ITTDINFO(@"index:%d",found);
    return found;
}

- (ISSChartHistogramBarGroup*)findTouchAreaWithLocation:(CGPoint)location
{
    NSInteger index = [self findValueIndexAtLocation:location];
    ISSChartHistogramBarGroup *group = [_histogramStackData getBarGroupArray][index];
    return group;        
}


- (CGPoint)findTopPointLocationWithApproximateLocation:(CGPoint)location
{
    ISSChartCoordinateSystem *coordinateSystem =  _histogramStackData.coordinateSystem;
    float maxValueY = 0;
    ISSChartHistogramBarGroup *group = [self findTouchAreaWithLocation:location];
    for (ISSChartHistogramBar *bar in group.bars){
        if (maxValueY<bar.valueY) {
            maxValueY = bar.valueY;
        }
    }
    NSInteger index = [self findValueIndexAtLocation:location];
    CGPoint point = CGPointZero;
    point.x = coordinateSystem.leftMargin + index * [self getColumnWidth] + [self getColumnWidth]/2;
    ISSChartAxis *yAxis = coordinateSystem.yAxis;    
    CGFloat rate =  (maxValueY - yAxis.baseValue)/ yAxis.valueRange;
    CGSize drawAreaSize = [self getDrawableAreaSize];
    point.y = drawAreaSize.height + coordinateSystem.topMargin - rate*drawAreaSize.height;
    
    return point;
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
            ISSChartCoordinateSystem *coordinateSystem = _histogramStackData.coordinateSystem;
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
    if (center.x - CGRectGetWidth(_hintLineView.bounds) >= _histogramStackData.coordinateSystem.leftMargin &&
        center.x + CGRectGetWidth(_hintLineView.bounds) <= CGRectGetWidth(self.bounds) - _histogramStackData.coordinateSystem.rightMargin) {
        _hintLineView.center = center;
    }
}

- (void)handleHintViewOnLocation:(CGPoint)location
{

    ISSChartHistogramBarGroup *group = [self findTouchAreaWithLocation:location];
    if (group) {
        NSInteger index = [self findValueIndexAtLocation:location];
        
        ITTDINFO(@"_previousIndex %d index %d", _previousIndex, index);
        if (NSNotFound != index) {
            location = [self findTopPointLocationWithApproximateLocation:location];

            ISSChartHintView *hintView;
            
            if (_didSelectedAreaPointBlock) {
                
                NSInteger legendArrayIndex = 0;
                //create popView hint data array
                NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
                
                
                ISSChartHistogramBarGroup *group = [_histogramStackData getBarGroupArray][index];
                ITTAssert([group isKindOfClass:[ISSChartHistogramBarGroup class]],@"group type must be ISSChartHistogramBarGroup");
                for (int i=0; i<group.bars.count; i++) {
                    ISSChartHistogramBar *bar = group.bars[i];
                    
                    ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
                    
                    hintProperty.text = [NSString stringWithFormat:@"%.2f %@",bar.originValueY,_histogramStackData.legendTextArray[i]];
                    hintProperty.textColor = bar.barProperty.fillColor;
                    [hintDatas addObject:hintProperty];
                    [hintProperty release];
                    legendArrayIndex++;
                    
                }
                
                
                hintView = _didSelectedAreaPointBlock(self, index, hintDatas);
                [hintDatas release];
                
                if (hintView) {
                    if(NSNotFound == _previousIndex||_previousIndex != index) {
                        _previousIndex = index;
                        [self recycleAllHintViews];
                        if (hintView) {
                            [(ISSChartHistogramStackHintView *)hintView showInView:self location:location];
                        }
                        
                        
                    }
                }
                
            }
        }
    }

}



#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[touches anyObject] locationInView:self];
    [self showHintLineView:TRUE];
    [self updateHintLineViewFrame:location];
    [self handleHintViewOnLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint location = [[touches anyObject] locationInView:self];
    [self updateHintLineViewFrame:location];
    [self handleHintViewOnLocation:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self showHintLineView:FALSE];
    _previousIndex = NSNotFound;
    [self recycleAllHintViews];
}

@end

