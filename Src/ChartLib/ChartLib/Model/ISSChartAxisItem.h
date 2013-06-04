//
//  ISSChartAxisItem.h
//  ChartLib
//
//  Created by Sword Zhou on 5/30/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartAxisItem : ISSChartBaseModelObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) CGFloat value;

+ (ISSChartAxisItem*)axisItemWithName:(NSString*)name value:(NSNumber*)value;
+ (NSArray*)axisItemsWithNames:(NSArray*)names values:(NSArray*)values;

@end
