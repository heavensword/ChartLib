//
//  ISSChartLegendView.h
//  ChartLib
//
//  Created by Sword Zhou on 6/5/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISSChartBaseData;
@class ISSChartLegendUnitView;

@interface ISSChartLegendView : UIScrollView
{
@protected
    CGFloat         _spacing;
	ISSChartType	_chartType;
    ISSChartLegendDirection _direction;
    NSMutableSet    *_legendUnitViewRecyledSet;
    NSMutableSet    *_legendUnitViewSet;
    NSArray         *_legendArray;
	ISSChartBaseData *_chartData;	
}

@property (nonatomic, retain) ISSChartBaseData *chartData;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) ISSChartLegendDirection direction;
@property (nonatomic, assign) ISSChartType chartType;
@property (nonatomic, retain) NSArray *legendArray;

- (void)recyleAllLegendUnitViews;

- (ISSChartLegendUnitView*)dequeueRecyledLegendUnitView;

- (CGRect)getLegendUnitFrame:(NSInteger)index;

@end
