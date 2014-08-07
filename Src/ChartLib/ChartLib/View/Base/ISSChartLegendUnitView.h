//
//  ISSChartLegendUnitView.h
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISSChartLegend;

@interface ISSChartLegendUnitView : UIView
{
@protected
	ISSChartLegend *_legend;
}

@property (nonatomic, retain) ISSChartLegend *legend;

@end
