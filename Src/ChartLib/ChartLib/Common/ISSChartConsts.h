//
//  ISSChartConsts.h
//  ChartLib
//
//  Created by Sword Zhou on 5/27/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#ifndef ChartLib_Consts_h
#define ChartLib_Consts_h

#define DEFAULT_PADDING_AXIS_X      60.0
#define DEFAULT_PADDING_AXIS_Y      100.0
#define DEFAULT_PADDING_AXIS        30.0
#define DEFAULT_LINE_WIDTH          2.0
#define DEFAULT_LINE_LENGTH         6.0
#define DEFAULT_LINE_JOIN_WIDTH     2.0
#define DEFAULT_SECTION_SPACING     4.0
#define DEFAULT_PIE_INNER_RADIUS    70.0
#define DEFAULT_PIE_RADIUS          100.0
#define DEFAULT_AXIS_LINE_WIDTH     1.0
#define DEFAULT_RADIUS              10.0
#define DEFAULT_STROKE_WIDTH_BAR    1.0
#define DEFAULT_MINIMUM_BAR_SPACING 4.0
#define DEFAULT_MINIMUM_BAR_WIDTH   8.0
#define DEFAULT_BAR_GROUP_SPACING   1.0
#define DEFAULT_MINIMUM_BAR_WIDTH   8.0
#define DEFAULT_MAXIMUM_BAR_WIDTH   100.0
#define DEFAULT_LEGEND_UNIT_WIDTH   100
#define DEFAULT_LEGEND_UNIT_HEIGHT  40
#define DEFAULT_ARROW_HEIGHT        10

#define KEY_PIE_SECTION             @"KEY_PIE_SECTION"
#define KEY_ORIGIN_VALUE            @"KEY_ORIGIN_VALUE"
#define KEY_NEW_VALUE               @"KEY_NEW_VALUE"
#define KEY_VIEW                    @"KEY_VIEW"
#define KEY_CURRENT_VALUE           @"KEY_CURRENT_VALUE"
#define KEY_ITERTATION              @"KEY_ITERTATION"
#define KEY_DURATION                @"KEY_DURATION"
#define KEY_DATA                    @"KEY_DATA"
#define KEY_COMPLETION_BLOCK        @"KEY_COMPLETION_BLOCK"
#define KEY_BAR                     @"KEY_BAR"


#define kISSChartAnimationDuration                 0.3
#define kISSChartFirstAnimationDuration            1.0
#define kISSChartAnimationFPS                      60.0

#define NUMBER_OF_COLOR_IN_CHARTLIB 14

#define ISSChart_Hint_Tag_Base 1000
#define DEFAULT_HINT_LABEL_TOP_MARGIN 3
#define DEFAULT_HINT_LABEL_LEFT_MARGIN 10
#define DEFAULT_HINT_LABEL_BOTTOM_MARGIN 6
#define DEFAULT_HINT_LABEL_HEIGHT 30

typedef enum {
    ISSChartCyanColor = 0,
    ISSChartMagentaColor,
    ISSChartGreenColor,
    ISSChartRedColor,
    ISSChartBlueColor,
    ISSChartYellowColor,
    ISSChartOrangeColor,
    ISSChartPurpleColor,
    ISSChartDrakGrayColor,
    ISSChartLightGrayColor,
    ISSChartGrayColor,
    ISSChartBrownColor,
    ISSChartBlackColor,
    ISSChartWhiteColor, //14
}ISSChartColor;

typedef enum {
    ISSChartLegendDirectionNone,
    ISSChartLegendDirectionHorizontal,
    ISSChartLegendDirectionVertical,
}ISSChartLegendDirection;

typedef enum {
    ISSChartLegendPositionNone,
    ISSChartLegendPositionRight,
    ISSChartLegendPositionBottom,
    ISSChartLegendPositionTop,
    ISSChartLegendPositionLeft,
}ISSChartLegendPosition;

typedef enum {
    ISSChartLinePointJoinNone = -1, 		        //-1
    ISSChartLinePointJoinCircle,					//0
    ISSChartLinePointJoinRectangle,					//1
    ISSChartLinePointJoinSolidRectangle,			//2
    ISSChartLinePointJoinTriangle,					//3
    ISSChartLinePointJoinSolidTriangle,			    //4
    ISSChartLinePointJoinSolidCircle			    //5
}ISSChartLinePointJoinStype;

typedef enum ISSChartAxisType {
    ISSChartAxisTypeNone,
    ISSChartAxisTypeValue,
    ISSChartAxisTypePercentage
}ISSChartAxisType;

typedef enum {
    ISSChartTypeNone,								//0
    ISSChartTypePie,								//1
    ISSChartTypeLine,								//2
    ISSChartTypeHistogram,							//3
    ISSChartTypeHistogramLine,					    //4
    ISSChartTypeWaterfall,						    //5
    ISSChartTypeHistogramOverlap,				    //6
    ISSChartTypeHistogramOverlapLine,				//7
    ISSChartTypeDashboard,						    //8
    ISSChartTypeStack,								//9
    ISSChartTypeStackLine,						    //10
}ISSChartType;

typedef enum {
    ISSChartLegendNone,
    ISSChartLegendHistogram,
    ISSChartLegendLine,
    ISSChartLegendPie,
    ISSChartLegendDashBoard,
}
ISSChartLegendType;

typedef enum {
    ISSChartFillNone,
    ISSChartFillPlain,
    ISSChartHorizontalFillGradient,
    ISSChartVerticalFillGradient,
}ISSChartFillStyle;

typedef enum {
    PointPositionNone,				//0
    PointPositionRightTop,			//1
	PointPositionRightBottom,		//2
    PointPositionLeftBottom,		//3
    PointPositionLeftTop,		    //4
    PointPositionTop,			    //5
    PointPositionRight,			    //6
    PointPositionLeft,			    //7
    PointPositionBottom			    //8
}PointPosition;

typedef enum {
    ISSChartArrowDirectionLeft = 0,
    ISSChartArrowDirectionRight,
    ISSChartArrowDirectionUp,
    ISSChartArrowDirectionDown,
}ISSChartArrowDirection;

typedef enum {
    ISSChartSymbolNone,
    ISSChartSymbolRectangle = 0,
    ISSChartSymbolArrowUp,
    ISSChartSymbolArrowDown,
}ISSChartSymbolType;

#endif
