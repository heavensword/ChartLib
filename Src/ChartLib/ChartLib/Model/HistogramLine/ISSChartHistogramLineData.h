//
//  ISSChartHistogramLineData.h
//  ChartLib
//
//  Created by Sword Zhou on 6/29/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartHistogramLineCoordinateSystem;
@class ISSChartAxis;
@class ISSChartHistogramBar;
@class ISSChartLine;

@interface ISSChartHistogramLineData : ISSChartBaseData
{
@protected
    ISSChartFillStyle _histogramStyle;
}

@property (nonatomic, retain) NSArray *lineDataArrays;
@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, retain) NSArray *lineColors;

@property (nonatomic, assign) CGFloat graduationWidth;
@property (nonatomic, assign) CGFloat graduationSpacing;

@property (nonatomic, assign) ISSChartFillStyle histogramStyle;
@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat groupSpcaing;

- (void)setBarAndLineValues:(NSArray*)barDataArrays lineValues:(NSArray*)lineDataArrays;
- (void)setBarDataValues:(NSArray*)valuesArray;
- (void)setBarFillColors:(NSArray *)barFillColors;
- (void)setBarStrokColors:(NSArray *)barStrokColors;
- (void)adjustDataToZeroState;

- (NSInteger)barCountOfPerGroup;
- (NSArray*)barGroups;

- (ISSChartAxisItem*)getXAxisItemWithBar:(ISSChartHistogramBar*)bar;
- (ISSChartLine*)findSelectedLineWithLocation:(CGPoint)location;
- (ISSChartLine*)findSelectedLineWithBar:(ISSChartHistogramBar*)bar;

@end
