//
//  ISSChartHistogramOverlapData.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@interface ISSChartHistogramOverlapData : ISSChartBaseData
{
}

@property (nonatomic, assign) CGFloat graduationWidth;
@property (nonatomic, assign) CGFloat graduationSpacing;
@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat groupSpcaing;

- (void)setBarDataValues:(NSArray *)barDataArrays;
- (void)adjustDataToZeroState;
- (void)setBarFillColors:(NSArray *)barFillColors;
- (void)setBarStrokColors:(NSArray *)barStrokColors;

- (NSInteger)barCountOfPerGroup;
- (NSArray*)barGroups;

@end



