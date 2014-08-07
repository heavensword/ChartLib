//
//  ISSChartAxisView.h
//  ChartLib
//
//  Created by Sword Zhou on 5/31/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISSChartCoordinateSystem;

@interface ISSChartAxisView : UIView
{
@protected
    id                       _containerView;
    ISSChartCoordinateSystem *_coordinateSystem;
}

@property (nonatomic, retain) ISSChartCoordinateSystem *coordinateSystem;

@property (nonatomic, assign) id containerView;

- (id)initWithFrame:(CGRect)frame coordinateSystem:(ISSChartCoordinateSystem*)coordinateSystem;

- (void)drawYAxis: (CGContextRef)context;

- (void)drawXAxis: (CGContextRef)context;

@end
