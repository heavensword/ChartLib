//
//  ISSHistogram.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"

typedef enum {
    ISSHistogramStyleNone,
    ISSHistogramPlain,
    ISSHistogramGradient
}ISSHistogramStyle;

@class ISSChartHistogramCoordinateSystem;

@interface ISSChartHistogramData : ITTBaseModelObject

@property (nonatomic, retain) NSArray *bars;
@property (nonatomic, retain) NSArray *barGroups;
@property (nonatomic, retain) NSArray *barDataArrays;
@property (nonatomic, retain) NSArray *legendArray;
@property (nonatomic, retain) NSArray *barColors;

@property (nonatomic, retain) ISSChartHistogramCoordinateSystem *coordinateSystem;

@property (nonatomic, assign) ISSChartLegendPosition legendPosition;
@property (nonatomic, assign) ISSHistogramStyle histogramStyle;

- (ISSChartLegendDirection)getLegendDirection;

- (void)setXAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;
- (void)setYAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;

- (void)setBarDataArraysWithValues:(NSArray*)values1, ...NS_REQUIRES_NIL_TERMINATION;

@end
