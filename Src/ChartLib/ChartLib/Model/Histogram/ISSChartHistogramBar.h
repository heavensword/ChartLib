//
//  ISSBar.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@class ISSChartHistogramBarProperty;

@interface ISSChartHistogramBar : ISSChartBaseModelObject

@property (nonatomic, assign) CGFloat valueY ;
@property (nonatomic, assign) CGFloat originValueY;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger groupIndex;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) ISSChartHistogramBarProperty *barProperty;

@end
