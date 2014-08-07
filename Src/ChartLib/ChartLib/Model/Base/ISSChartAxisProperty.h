//
//  ISSChartAxisProperty.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"
#import "ISSDashing.h"

@interface ISSChartAxisProperty : ISSChartBaseModelObject

@property (nonatomic, assign) ISSDashingStyle axisStyle;
@property (nonatomic, assign) ISSChartAxisType axisType;
@property (nonatomic, assign) BOOL needDisplayUnit;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat gridWith;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *gridColor;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *labelFont;

@end
