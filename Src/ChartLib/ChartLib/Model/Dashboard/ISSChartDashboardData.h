//
//  ISSDashboardData.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartPointer;
@class ISSChartCircle;

@interface ISSChartDashboardData : ISSChartBaseData

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, retain) NSString *valueLabel;
@property (nonatomic, assign) CGFloat startAngle; //in raidan
@property (nonatomic, assign) CGFloat endAngle;   //in raidan
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat graduationLineWidth;
@property (nonatomic, assign) CGFloat arcLineWidth;
@property (nonatomic, assign) CGFloat graduationLineLength;
@property (nonatomic, retain) UIColor *graduationLineColor;
@property (nonatomic, retain) UIColor *arcLineColor;
@property (nonatomic, retain) UIColor *valueTextColor;
@property (nonatomic, retain) UIFont *valueTextFont;
@property (nonatomic, assign) NSInteger step;

@property (nonatomic, retain) NSArray *values;
@property (nonatomic, retain) NSArray *graduations;
@property (nonatomic, retain) NSArray *labels;
@property (nonatomic, retain) NSArray *graduationIntervals;

@property (nonatomic, retain) ISSChartPointer *pointer;

@property (nonatomic, retain) NSArray *pointers;

@property (nonatomic, retain) ISSChartCircle *circle;

@end
