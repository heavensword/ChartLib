//
//  ISSAxis.h
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"

@class ISSChartAxisItem;
@class ISSChartAxisProperty;

@interface ISSChartAxis : ITTBaseModelObject

@property (nonatomic, retain) NSArray *axisItems;
@property (nonatomic, assign) CGFloat baseValue;
@property (nonatomic, assign) CGFloat rotateAngle; //unit:degree

//these parameters are cacluted by values
@property (nonatomic, assign, readonly) CGFloat minValue;
@property (nonatomic, assign, readonly) CGFloat maxValue;
@property (nonatomic, assign, readonly) CGFloat valueRange;

@property (nonatomic, retain) ISSChartAxisProperty *axisProperty;

- (void)setAxisItemsWithNames:(NSArray*)names values:(NSArray*)values;

- (NSArray*)values;
- (NSArray*)names;

@end
