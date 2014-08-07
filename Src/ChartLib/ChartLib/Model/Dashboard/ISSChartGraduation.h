//
//  ISSChartGraduation.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartAxisItem.h"

@class ISSChartGraduationProperty;

@interface ISSChartGraduation : ISSChartAxisItem

@property (nonatomic, retain) ISSChartGraduationProperty *graduationProperty;

@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, retain) UIColor *textColor;

@end
