//
//  ISSChartAxisProperty.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSComponentProperty.h"
#import "ISSDashing.h"

@interface ISSChartAxisProperty : ISSComponentProperty

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) ISSDashingStyle axisStyle;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIFont *labelFont;

@end
