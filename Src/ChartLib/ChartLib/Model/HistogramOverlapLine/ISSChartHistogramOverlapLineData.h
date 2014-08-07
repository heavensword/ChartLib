//
//  ISSChartHistogramOverlapData.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartHistogramLineCoordinateSystem;
@class ISSChartAxis;

@interface ISSChartHistogramOverlapLineData : ISSChartBaseData
{

}

@property (nonatomic, retain) NSArray *lineDataArrays;
@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, retain) NSArray *lineColors;
@property (nonatomic, retain) NSArray *barColors;

@property (nonatomic, assign) CGFloat graduationWidth;
@property (nonatomic, assign) CGFloat graduationSpacing;


@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat groupSpcaing;

- (void)setBarDataValues:(NSArray *)barDataArrays;
- (void)setBarAndLineValues:(NSArray*)barDataArrays lineValues:(NSArray*)lineDataArrays;
- (void)setBarFillColors:(NSArray *)barFillColors;
- (void)setBarStrokColors:(NSArray *)barStrokColors;
- (void)adjustDataToZeroState;
- (NSInteger)barCountOfPerGroup;

- (NSArray*)barGroups;
- (NSArray*)getBarColors;

@end



