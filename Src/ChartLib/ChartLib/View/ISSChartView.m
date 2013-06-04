//
//  ISSChartView.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartView.h"
#import "ISSDashing.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartHistogramCoordinateSystem.h"

@interface ISSChartView()
{ 
}
@end

@implementation ISSChartView

- (void)dealloc
{
    [_legendView release];
    [_axisView release];
    [_title release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = FALSE;
        _baseXMargin = 0;
        _baseYMargin = 0;
    }
    return self;
}

- (CGFloat)getAxisXMarginXWithIndex:(NSInteger)index
{
    return 0;
}

- (CGFloat)getAxisMarginYWithValueY:(CGFloat)valueY
{
    return 0;
}

- (CGRect)getYLableFrame:(CGFloat)marginY text:(NSString*)label
{
    return CGRectZero;
}

- (CGRect)getXLableFrame:(CGFloat)marginX text:(NSString*)label
{
    return CGRectZero;    
}
@end
