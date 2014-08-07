//
//  ISSChartGraduationInterval.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@class ISSChartGraduation;

@interface ISSChartGraduationInterval : ISSChartBaseModelObject

@property (nonatomic, retain) NSArray *colors;
@property (nonatomic, retain) ISSChartGraduation *startGraduation;
@property (nonatomic, retain) ISSChartGraduation *endGraduation;

- (CFArrayRef)cgcolors;

@end
