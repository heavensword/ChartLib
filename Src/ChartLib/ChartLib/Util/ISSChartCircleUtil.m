//
//  CircleUtil.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartCircleUtil.h"

@implementation ISSChartCircleUtil

+ (PointPosition)pointPosition:(CGFloat)radian
{
	if (radian >= 2 * M_PI) {
		NSInteger counter = radian/(2*M_PI);
		radian = radian - counter * 2 * M_PI;
	}
	NSInteger factor = 1.0;
	CGFloat integerRadian = factor * radian;
    PointPosition position = PointPositionNone;
	double condition = M_PI * 10 / 180;
	//right
	if (fabs(radian - 0) <= condition||
		fabs(radian - 2 * M_PI) <= condition) {
		position = PointPositionRight;
	}
	//bottom
	else if(fabs(radian - M_PI / 2) <= condition) {
		position = PointPositionBottom;
	}
	//left
	else if(fabs(radian - M_PI) <= condition){
		position = PointPositionLeft;
	}
	//top
	else if(fabs(radian - 3 * M_PI / 2) <= condition) {
		position = PointPositionTop;
	}
    //right-bottom
    else if (integerRadian < factor * M_PI / 2) {
        position = PointPositionRightBottom;
    }
    //left-bottom
    else if (integerRadian < factor * M_PI) {
        position = PointPositionLeftBottom;
    }
    //left-top
    else if(integerRadian < M_PI * 3 / 2){
        position = PointPositionLeftTop;
    }
    //right-top (integerRadian > factor*M_PI * 3/2 && integerRadian <= factor*2*M_PI)
    else {
        position = PointPositionRightTop;
    }
    return position;
}

//+ (PointPosition)pointPosition:(CGFloat)radian
//{
//	ITTDINFO(@"radian %f 2*M_PI %f", radian, 2*M_PI);
//    PointPosition position = PointPositionNone;
//    //right-bottom
//    if ([self compareValue:radian value2:M_PI/2]) {
//        position = PointPositionRightBottom;
//    }
//    //right-top
//    else if ([self compareValue:radian value2:M_PI*3/2] &&
//			 [self compareValue:radian value2:2*M_PI]) {
//        position = PointPositionRightTop;
//    }
//    //left-bottom
//    else if ([self compareValue:radian value2:M_PI/2] &&
//			 [self compareValue:radian value2:M_PI]) {
//        position = PointPositionLeftBottom;
//    }
//    //left-top middleDegree > M_PI && middleDegree <= M_PI*3/2)
//    else {
//        position = PointPositionLeftTop;
//    }
//    return position;
//}

+ (CGPoint)pointOnCircleWithRadian:(CGFloat)radian radius:(CGFloat)radius center:(CGPoint)center
{
//    PointPosition position = [self pointPosition:radian];
    CGPoint point;
//    switch (position) {
//        case PointPositionRightBottom:
//            point.x = center.x + cos(radian)*radius;
//            point.y = center.y + sin(radian)*radius;
//            break;
//        case PointPositionRightTop:
//            point.x = center.x + cos(radian)*radius;
//            point.y = center.y + sin(radian)*radius;
//            break;
//        case PointPositionLeftBottom:
//            point.x = center.x + cos(radian)*radius;
//            point.y = center.y + sin(radian)*radius;
//            break;
//        case PointPositionLeftTop:
//            point.x = center.x + cos(radian)*radius;
//            point.y = center.y + sin(radian)*radius;
//            break;
//        default:
//            NSAssert(TRUE, @"point position invalid!");
//            break;
//    }
	point.x = center.x + cos(radian)*radius;
	point.y = center.y + sin(radian)*radius;
    return point;
}

@end
