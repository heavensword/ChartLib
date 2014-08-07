//
//  ISSChartGraduationProperty.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartGraduationProperty : ISSChartBaseModelObject

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineLength;
@property (nonatomic, assign) CGFloat degree;
@property (nonatomic, assign) CGPoint pointOnOuterCircle;
@property (nonatomic, assign) CGPoint pointOnInnerCircle;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *textColor;

@end
