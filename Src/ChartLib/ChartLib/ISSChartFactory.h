//
//  ISSChartDataFactory.h
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"

@interface ISSChartFactory : ISSChartBaseModelObject

- (id)thumbnailChartData;
- (id)thumbnailChartViewWithFrame:(CGRect)frame chartData:(id)chartData;

@end
