//
//  ISSChartLengendUtil.h
//  ChartLib
//
//  Created by Sword on 13-11-5.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISSChartLegendUnitView;

@interface ISSChartLengendUtil : NSObject

+ (ISSChartLegendUnitView*)newLegendUnitViewWithChartType:(ISSChartLegendType)legendType;

@end
