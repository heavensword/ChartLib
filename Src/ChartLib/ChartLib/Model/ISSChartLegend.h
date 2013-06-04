//
//  ISSChartLegend.h
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

typedef enum {
    ISSChartLegendNone,
    ISSChartLegendHistogram,
}
ISSChartLegendType;

@interface ISSChartLegend : ISSChartBaseModelObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIColor  *color;
@property (nonatomic, retain) UIColor  *textColor;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, assign) ISSChartLegendType type;

@end
