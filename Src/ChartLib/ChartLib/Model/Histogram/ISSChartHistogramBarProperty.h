//
//  ISSBarProperty.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//
#import "ISSChartBaseModelObject.h"

@interface ISSChartHistogramBarProperty : ISSChartBaseModelObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL needDrawSelectedForehead;
@property (nonatomic, assign) ISSChartFillStyle fillType;
@property (nonatomic, retain)	UIColor *strokeColor;
@property (nonatomic, retain)	NSArray *fillColors;
@property (nonatomic, readonly) UIColor *fillColor;
@property (nonatomic, readonly) NSArray *gradientColors;

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect backgroundFrame;
@end
