//
//  ISSBar.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"

@class ISSChartBarProperty;

@interface ISSChartBar : ITTBaseModelObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) CGFloat valueX ;
@property (nonatomic, assign) CGFloat valueY ;

@property (nonatomic, retain) ISSChartBarProperty *barProperty;

@end
