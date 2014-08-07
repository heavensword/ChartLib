//
//  ISSChartLineProperty.h
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartLineProperty : ISSChartBaseModelObject

@property (nonatomic, assign) ISSChartLinePointJoinStype pointStyle;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineJoin;
@property (nonatomic, assign) CGFloat lineCap;
@property (nonatomic, assign) CGFloat joinLineWidth;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;

@property (nonatomic, retain) NSArray *points;

@end
