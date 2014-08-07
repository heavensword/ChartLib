//
//  ISSChartLegendView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/5/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLegendView.h"
#import "ISSChartLegendUnitView.h"
#import "ISSChartLegendUnitView.h"
#import "ISSChartLengendUtil.h"
#import "ISSChartLegend.h"
#import "ISSChartBaseData.h"

@implementation ISSChartLegendView

- (void)dealloc
{
	[_chartData release];
    [_legendUnitViewRecyledSet release];
    [_legendUnitViewSet release];
    [_legendArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_chartType = ISSChartTypeNone;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self recyleAllLegendUnitViews];
    NSInteger count = [_legendArray count];
    ISSChartLegendUnitView *unitView;
	ISSChartLegend *legend;
    for (NSInteger i = 0; i < count; i++) {
        unitView = [[self dequeueRecyledLegendUnitView] retain];
		legend = _legendArray[i];
        if (!unitView) {
			unitView = [ISSChartLengendUtil newLegendUnitViewWithChartType:legend.type];
        }
        unitView.frame = [self getLegendUnitFrame:i];
        unitView.legend = legend;
        [_legendUnitViewSet addObject:unitView];
        [unitView setNeedsDisplay];
        [self addSubview:unitView];
        [unitView release];
    }
	[self adjustContentSize];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setup
{
    self.clipsToBounds = TRUE;
    _spacing = 10.0;
    _legendUnitViewRecyledSet = [[NSMutableSet alloc] init];
}

- (void)adjustContentSize
{
	CGSize size = self.contentSize;
    NSInteger count = [_legendArray count];
	CGRect legendUnitFrame = [self getLegendUnitFrame:(count - 1)];
    size.width = legendUnitFrame.size.width + legendUnitFrame.origin.x;
	size.height = legendUnitFrame.size.height + legendUnitFrame.origin.y;
    [self setContentSize:size];
}

- (void)recyleAllLegendUnitViews
{
    [self removeAllSubviews];
    [_legendUnitViewRecyledSet addObjectsFromArray:[_legendUnitViewSet allObjects]];
    [_legendUnitViewSet removeAllObjects];
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

#pragma mark - public methods
- (CGRect)getLegendUnitFrame:(NSInteger)index
{
    ISSChartLegend *legend = _legendArray[index];
    CGSize lengendTotalSize = [_chartData getLegendTotalSize];
    NSInteger count = [_legendArray count];
    CGFloat autoSpacing = (CGRectGetWidth(self.bounds) - lengendTotalSize.width)/count;
    if (autoSpacing < _spacing) {
        autoSpacing = _spacing;
    }
    CGFloat marginX = autoSpacing/2;
    CGFloat marginY = MAX((CGRectGetHeight(self.bounds) - lengendTotalSize.height - (count - 1)*_spacing)/2, 0);
    CGSize legnedSize = legend.legnedSize;
    
    CGRect frame = CGRectZero;
    if(ISSChartLegendDirectionHorizontal == _direction) {
        marginX += index * autoSpacing + [_chartData getLegendTotalSizeBeforeIndex:index].width;
        frame = CGRectMake(marginX, 0, legnedSize.width, CGRectGetHeight(self.bounds));
    }
    else if(ISSChartLegendDirectionVertical == _direction) {
        marginY += index * _spacing +  + [_chartData getLegendTotalSizeBeforeIndex:index].height;
        frame = CGRectMake(0, marginY, CGRectGetWidth(self.bounds), legnedSize.height);
    }
    return frame;
}

- (void)setChartData:(ISSChartBaseData *)chartData
{
    [self recyleAllLegendUnitViews];
    RELEASE_SAFELY(_chartData);
    _chartData = [chartData retain];
	
	self.direction = [_chartData getLegendDirection];
    self.legendArray = _chartData.legends;
    [self setNeedsLayout];
}
@end
