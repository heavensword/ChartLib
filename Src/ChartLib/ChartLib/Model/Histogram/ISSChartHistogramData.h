//
//  ISSHistogram.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartCoordinateSystem;
@class ISSChartHistogramBar;

@interface ISSChartHistogramData : ISSChartBaseData
{
@protected
    ISSChartFillStyle	_histogramStyle;
}

@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat groupSpcaing;
@property (nonatomic, assign) BOOL needDrawSelectedForehead;

- (void)setBarDataArraysWithValues:(NSArray*)values1, ...NS_REQUIRES_NIL_TERMINATION;
- (void)setBarDataValues:(NSArray*)valuesArray;
- (void)adjustDataToZeroState;
- (void)setBarFillColors:(NSArray *)barFillColors;
- (void)setBarStrokColors:(NSArray *)barStrokColors;
- (NSInteger)barCountOfPerGroup;
- (NSArray*)barGroups;

- (ISSChartAxisItem*)getXAxisItemWithBar:(ISSChartHistogramBar*)bar;

@end
