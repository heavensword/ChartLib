//
//  ISSChartLineData.h
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartCoordinateSystem;

@interface ISSChartLineData : ISSChartBaseData

@property (nonatomic, assign) CGFloat graduationWidth;
@property (nonatomic, assign) CGFloat graduationSpacing;

@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, retain) NSArray *lineDataArrays;
@property (nonatomic, retain) NSArray *lineColors;

- (void)setValues:(NSArray*)values;
- (void)setValuesWithValues:(NSArray*)values1, ...NS_REQUIRES_NIL_TERMINATION;

@end
