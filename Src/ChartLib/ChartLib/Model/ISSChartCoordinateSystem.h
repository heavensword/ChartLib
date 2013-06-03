//
//  ISSChartCoordinateSystem.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"

@class ISSChartAxis;

@interface ISSChartCoordinateSystem : ITTBaseModelObject
{
@protected
    ISSChartAxis *_xAxis;
    ISSChartAxis *_yAxis;
    CGPoint      _origin;
    CGSize       _size;
}

@property (nonatomic, retain) ISSChartAxis *xAxis;
@property (nonatomic, retain) ISSChartAxis *yAxis;

@end
