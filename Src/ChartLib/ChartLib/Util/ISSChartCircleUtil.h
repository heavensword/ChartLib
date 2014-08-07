//
//  CircleUtil.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSChartCircleUtil : NSObject

+ (PointPosition)pointPosition:(CGFloat)radian;
+ (CGPoint)pointOnCircleWithRadian:(CGFloat)radian radius:(CGFloat)radius center:(CGPoint)center;

@end
