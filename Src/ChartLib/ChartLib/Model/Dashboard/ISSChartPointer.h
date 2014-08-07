//
//  ISSChartPointer.h
//  ChartLib
//
//  Created by Sword on 13-11-1.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartPointer : ISSChartBaseModelObject

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGFloat degree;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, retain) NSArray *colors;

@end
