//
//  ISSChartUtil.h
//  ChartLib
//
//  Created by Sword Zhou on 6/6/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISSChartLineProperty;

@interface ISSChartUtil : NSObject

+ (CGPathRef)newPointJoinPath:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius;

+ (CGRect)pointJointRect:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius;

+ (CGPoint)linerGradientStartPoint:(CGRect)frame fillType:(ISSChartFillStyle)fillType;
+ (CGPoint)linerGradientEndPoint:(CGRect)frame fillType:(ISSChartFillStyle)fillType;
+ (void)drawLinerGradient:(CGContextRef)context gradientColors:(NSArray*)gradientColors clippedPath:(CGPathRef)path startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
+ (BOOL)needDrawDradient:(NSInteger)colorsCount;
@end
