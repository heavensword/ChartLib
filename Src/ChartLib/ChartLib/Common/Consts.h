//
//  Consts.h
//  ChartLib
//
//  Created by Sword Zhou on 5/27/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#ifndef ChartLib_Consts_h
#define ChartLib_Consts_h

#define DEFAULT_PADDING_AXIS_X      60.0
#define DEFAULT_PADDING_AXIS_Y      35.0
#define DEFAULT_PADDING_AXIS        30.0
#define DEFAULT_STROKE_WIDTH_AXIS   1.0
#define DEFAULT_STROKE_WIDTH_BAR    1.0
#define DEFAULT_MINIMUM_BAR_SPACING 4.0
#define DEFAULT_MINIMUM_BAR_WIDTH   10.0
#define DEFAULT_BAR_SPACING         8.0

#define KEY_ORIGIN_VALUE            @"KEY_ORIGIN_VALUE"
#define KEY_NEW_VALUE               @"KEY_NEW_VALUE"
#define KEY_ITERTATION              @"KEY_ITERTATION"
#define KEY_DURATION                @"KEY_DURATION"
#define KEY_COMPLETION_BLOCK        @"KEY_COMPLETION_BLOCK"

#define NUMBER_OF_COLOR_IN_CHARTLIB 14

typedef enum {
    ISSChartCyanColor = 0,
    ISSChartMagentaColor,
    ISSChartGreenColor,
    ISSChartWhiteColor,    
    ISSChartDrakGrayColor,
    ISSChartLightGrayColor,
    ISSChartGrayColor,
    ISSChartRedColor,
    ISSChartBlueColor,
    ISSChartYellowColor,
    ISSChartOrangeColor,
    ISSChartPurpleColor,
    ISSChartBrownColor,
    ISSChartBlackColor,    
}ISSChartColor;

#endif
