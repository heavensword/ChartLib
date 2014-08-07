//
//  ISSChartAxisItem.h
//  ChartLib
//
//  Created by Sword Zhou on 5/30/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

/*!
 * axis graduation item
 */
@interface ISSChartAxisItem : ISSChartBaseModelObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat rotationAngle; //unit:degree
@property (nonatomic, assign) CGRect textRect;

+ (ISSChartAxisItem*)axisItemWithName:(NSString*)name value:(NSNumber*)value;
+ (ISSChartAxisItem*)axisItemWithName:(NSString*)name;
+ (NSArray*)axisItemsWithNames:(NSArray*)names;
+ (NSArray*)axisItemsWithNames:(NSArray*)names values:(NSArray*)values;

@end
