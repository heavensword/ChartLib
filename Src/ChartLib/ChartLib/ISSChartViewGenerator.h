//
//  ISSChartViewGenerator.h
//  ChartLib
//
//  Created by Sword on 13-12-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "Manager.h"

@interface ISSChartViewGenerator : Manager

- (id)thumbnailChartViewWithChartName:(NSString*)chartName frame:(CGRect)frame;

@end
