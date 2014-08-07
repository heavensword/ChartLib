//
//  ISSChartPieSection.h
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@class ISSChartPieSectionProperty;

@interface ISSChartPieSection : ISSChartBaseModelObject

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, retain) ISSChartPieSectionProperty *pieSectionProperty;

@end
