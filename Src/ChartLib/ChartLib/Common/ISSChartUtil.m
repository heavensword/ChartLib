//
//  ISSChartUtil.m
//  ChartLib
//
//  Created by Sword Zhou on 6/6/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartUtil.h"
#import "ISSChartLineProperty.h"

@implementation ISSChartUtil

+ (CGPathRef)newPointJoinPath:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius
{
    CGPathRef path = NULL;
    CGRect rect;
    switch (style) {
        case ISSChartLinePointJoinNone: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            path = CGPathCreateWithEllipseInRect(rect, NULL);
            break;
        }
        case ISSChartLinePointJoinCircle:
        case ISSChartLinePointJoinSolidCircle:{
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            path = CGPathCreateWithEllipseInRect(rect, NULL);
            break;
        }
        case ISSChartLinePointJoinRectangle:
        case ISSChartLinePointJoinSolidRectangle: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            path = CGPathCreateWithRect(rect, NULL);
            break;
        }
        case ISSChartLinePointJoinTriangle:
        case ISSChartLinePointJoinSolidTriangle: {
//             . A
//           .   .
//        B . . . . C
            CGPoint A = CGPointMake(point.x, point.y - radius * cos(degreesToRadian(30.0)));
            CGPoint B = CGPointMake(point.x + radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            CGPoint C = CGPointMake(point.x - radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            CGMutablePathRef mutablePath = CGPathCreateMutable();
            CGPathMoveToPoint(mutablePath, NULL, A.x, A.y);
            CGPathAddLineToPoint(mutablePath, NULL, B.x, B.y);
            CGPathAddLineToPoint(mutablePath, NULL, C.x, C.y);
            CGPathAddLineToPoint(mutablePath, NULL, A.x, A.y);
            path = mutablePath;
            break;
        }
        default:
            break;
    }
    return path;
}

+ (CGRect)pointJointRect:(CGPoint)point style:(ISSChartLinePointJoinStype)style radius:(CGFloat)radius
{
    CGRect rect;
    switch (style) {
        case ISSChartLinePointJoinNone: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            break;
        }
        case ISSChartLinePointJoinCircle:
        case ISSChartLinePointJoinSolidCircle: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            break;
        }
        case ISSChartLinePointJoinRectangle:
        case ISSChartLinePointJoinSolidRectangle: {
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);
            break;
        }
        case ISSChartLinePointJoinTriangle:
        case ISSChartLinePointJoinSolidTriangle: {
            //             . A
            //           .   .
            //        B . . . . C
            CGPoint A = CGPointMake(point.x, point.y - radius * cos(degreesToRadian(30.0)));
            CGPoint B = CGPointMake(point.x + radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            CGPoint C = CGPointMake(point.x - radius*sin(degreesToRadian(60.0)), point.y + radius * cos(degreesToRadian(60.0)));
            rect = CGRectMake(B.x, A.y, C.x - B.x, C.y - A.y);
            break;
        }
        default:
            rect = CGRectMake(point.x - radius, point.y - radius, 2*radius, 2*radius);            
            break;
    }
    return rect;
}

+ (CGPoint)linerGradientStartPoint:(CGRect)frame fillType:(ISSChartFillStyle)fillType
{
    CGPoint startPoint = CGPointZero;
    switch (fillType) {
        case ISSChartHorizontalFillGradient:
            startPoint = CGPointMake(CGRectGetMinX(frame), CGRectGetMidY(frame));
            break;
        case ISSChartVerticalFillGradient:
            startPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
            break;
        default:
            startPoint = CGPointMake(CGRectGetMinX(frame), CGRectGetMidY(frame));
            break;
    }
    return startPoint;
}

+ (CGPoint)linerGradientEndPoint:(CGRect)frame fillType:(ISSChartFillStyle)fillType
{
    CGPoint endPoint = CGPointZero;
    switch (fillType) {
        case ISSChartHorizontalFillGradient:
            endPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));
            break;
        case ISSChartVerticalFillGradient:
            endPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
            break;
        default:
            endPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));            
            break;
    }
    return endPoint;
}

+ (void)drawLinerGradient:(CGContextRef)context gradientColors:(NSArray*)gradientColors
              clippedPath:(CGPathRef)path startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    NSInteger gradientColorCount = [gradientColors count];
    CGFloat *locs = NULL;
    switch (gradientColorCount) {
        case 2:
            locs = malloc(sizeof(CGFloat) * 2);
            locs[0] = 0.0;
            locs[1] = 1.0;
            break;
        case 3:
            locs = malloc(sizeof(CGFloat) * 3);
            locs[0] = 0.0;
            locs[1] = 0.5;
            locs[2] = 1.0;
            break;
        case 4:
            locs = malloc(sizeof(CGFloat) * 4);
            locs[0] = 0.0;
            locs[1] = 0.25;
            locs[2] = 0.5;
            locs[3] = 1.0;
            break;
        default:
            break;
    }
    //save current state
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColors(mySpace, (CFArrayRef)gradientColors, locs);
    CGColorSpaceRelease(mySpace);
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
    CGGradientRelease(gradientRef);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    //restore state
    CGContextRestoreGState(context);
}

+ (BOOL)needDrawDradient:(NSInteger)colorsCount
{
    return colorsCount >= 2 && colorsCount <= 4;
}
@end
