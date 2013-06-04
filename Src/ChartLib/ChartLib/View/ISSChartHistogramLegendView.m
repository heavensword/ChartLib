//
//  ISSLegend.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLegendView.h"
#import "ISSChartHistogramData.h"
#import "ISSChartLegend.h"
#import "ISSChartLegendUnitView.h"

@interface ISSChartHistogramLegendView()
{
    NSMutableSet    *_legendUnitViewRecyledSet;
    NSMutableSet    *_legendUnitViewSet;
    NSArray         *_legendArray;
}
@end

@implementation ISSChartHistogramLegendView

- (void)dealloc
{
    [_legendUnitViewRecyledSet release];
    [_legendUnitViewSet release];
    [_legendArray release];
    [_histogram release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    NSInteger count = [_legendArray count];
    ISSChartLegendUnitView *unitView;
    for (NSInteger i = 0; i < count; i++) {
        unitView = [[self dequeueRecyledLegendUnitView] retain];
        if (!unitView) {
            unitView = [[ISSChartLegendUnitView alloc] initWithFrame:CGRectZero];
        }
        unitView.frame = [self getLegendUnitFrame:i];
        unitView.legend = _legendArray[i];
        [_legendUnitViewSet addObject:unitView];
        [unitView setNeedsDisplay];
        [self addSubview:unitView];        
        [unitView release];
    }
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
    [self recyleAllLegendUnitViews];
    RELEASE_SAFELY(_histogram);
    _histogram = [histogram retain];
    NSInteger count = [_histogram.legendArray count];
    NSMutableArray *legends = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++) {
        ISSChartLegend *legend = [[ISSChartLegend alloc] init];
        legend.name = _histogram.legendArray[i];
        legend.color = _histogram.barColors[i];
        legend.type = ISSChartLegendHistogram;
        [legends addObject:legend];
        [legend release];
    }
    RELEASE_SAFELY(_legendArray);
    _legendArray = [legends retain];
    [legends release];
    
    _direction = [_histogram getLegendDirection];
    [self setNeedsLayout];
}

#pragma mark - private methods
- (void)setup
{
    _legendUnitViewRecyledSet = [[NSMutableSet alloc] init];
    _legendUnitViewRecyledSet = [[NSMutableSet alloc] init];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)recyleAllLegendUnitViews
{
    [self removeAllSubviews];
    [_legendUnitViewRecyledSet addObjectsFromArray:[_legendUnitViewSet allObjects]];
    [_legendUnitViewSet removeAllObjects];
}

- (CGRect)getLegendUnitFrame:(NSInteger)index
{
    CGRect frame = CGRectZero;
    if(ISSChartLegendDirectionHorizontal == _direction) {
        frame = CGRectMake(index * DEFAULT_LEGEND_UNIT_WIDTH, 0, DEFAULT_LEGEND_UNIT_WIDTH, CGRectGetHeight(self.bounds));
    }
    else if(ISSChartLegendDirectionVertical == _direction) {
        frame = CGRectMake(0, index * DEFAULT_LEGEND_UNIT_HEIGHT, CGRectGetWidth(self.bounds), DEFAULT_LEGEND_UNIT_HEIGHT);
    }
    return frame;
}

- (ISSChartLegendUnitView*)dequeueRecyledLegendUnitView
{
    ISSChartLegendUnitView *unitView = [_legendUnitViewRecyledSet anyObject];
    if (unitView) {
        [[unitView retain] autorelease];
        [_legendUnitViewRecyledSet removeObject:unitView];
    }
    return unitView;
}
@end
