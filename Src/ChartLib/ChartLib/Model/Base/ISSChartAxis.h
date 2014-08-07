//
//  ISSAxis.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@class ISSChartAxisItem;
@class ISSChartAxisProperty;

@interface ISSChartAxis : ISSChartBaseModelObject


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *unit;
@property (nonatomic, retain) NSArray *axisItems;
@property (nonatomic, assign) ISSChartAxisType axisType;
@property (nonatomic, assign) CGFloat baseValue;
@property (nonatomic, assign) CGFloat rotateAngle; //unit:degree

//these parameters are cacluted by values
@property (nonatomic, assign, readonly) CGFloat minValue;
@property (nonatomic, assign, readonly) CGFloat maxValue;
@property (nonatomic, assign, readonly) CGFloat valueRange;

@property (nonatomic, retain) ISSChartAxisProperty *axisProperty;

- (void)setAxisItemsWithNames:(NSArray*)names;
- (void)setAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;

@end
