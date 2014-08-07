//
//  ISSChartHistogramStackData.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartHistogramLineCoordinateSystem;
@class ISSChartAxis;

@interface ISSChartHistogramStackLineData : ISSChartBaseData
{

}

@property (nonatomic, retain)ISSChartAxis *viceYAxis;
@property (nonatomic, retain) NSArray *lineDataArrays;
@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, retain) NSArray *lineColors;
@property (nonatomic, retain) NSArray *barColors;

@property (nonatomic, assign) CGFloat graduationWidth;
@property (nonatomic, assign) CGFloat graduationSpacing;

@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat groupSpcaing;

- (void)setBarAndLineValues:(NSArray*)barDataArrays lineValues:(NSArray*)lineDataArrays;

- (NSInteger)getBarCountPerGroup;

- (NSArray*)getBarGroupArray;
- (NSArray*)getBarColors;

@end



