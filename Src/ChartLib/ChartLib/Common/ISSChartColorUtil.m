//
//  ISSChartColorUtil.m
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartColorUtil.h"

@implementation ISSChartColorUtil

+ (UIColor*)colorWithType:(ISSChartColor)type
{
    UIColor *color = nil;
    switch (type) {
        case ISSChartBlackColor:
            color = [UIColor blackColor];
            break;
        case ISSChartDrakGrayColor:
            color = [UIColor darkGrayColor];
            break;
        case ISSChartLightGrayColor:
            color = [UIColor lightGrayColor];
            break;
        case ISSChartWhiteColor:
            color = [UIColor whiteColor];
            break;
        case ISSChartGrayColor:
            color = [UIColor grayColor];
            break;
        case ISSChartRedColor:
            color = [UIColor redColor];
            break;
        case ISSChartGreenColor:
            color = [UIColor greenColor];
            break;
        case ISSChartBlueColor:
            color = [UIColor blueColor];
            break;
        case ISSChartCyanColor:
            color = [UIColor cyanColor];
            break;
        case ISSChartYellowColor:
            color = [UIColor yellowColor];
            break;
        case ISSChartMagentaColor:
            color = [UIColor magentaColor];
            break;
        case ISSChartOrangeColor:
            color = [UIColor orangeColor];
            break;
        case ISSChartPurpleColor:
            color = [UIColor purpleColor];
            break;
        case ISSChartBrownColor:
            color = [UIColor brownColor];
            break;
        default:
            color = [UIColor redColor];
            break;
    }
    return color;
}
@end
