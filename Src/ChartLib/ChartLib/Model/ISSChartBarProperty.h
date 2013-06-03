//
//  ISSBarProperty.h
//  ChartLib
//
//  Created by Sword Zhou on 5/28/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSComponentProperty.h"

@interface ISSChartBarProperty : ISSComponentProperty

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *gradientStartColor;
@property (nonatomic, retain) UIColor *gradientEndColor;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGRect frame;

@end
