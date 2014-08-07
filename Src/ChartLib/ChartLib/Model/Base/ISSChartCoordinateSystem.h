//
//  ISSChartCoordinateSystem.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@class ISSChartAxis;

@interface ISSChartCoordinateSystem : ISSChartBaseModelObject
{
@protected
    ISSChartAxis *_xAxis;
    ISSChartAxis *_yAxis;
    CGFloat      _leftMargin;
    CGFloat      _topMargin;
    CGFloat      _rightMargin;
    CGFloat      _bottomMargin;
}

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat bottomMargin;

@property (nonatomic, retain) ISSChartAxis *xAxis;
@property (nonatomic, retain) ISSChartAxis *yAxis;
@property (nonatomic, retain) ISSChartAxis *viceYAxis;

@end
