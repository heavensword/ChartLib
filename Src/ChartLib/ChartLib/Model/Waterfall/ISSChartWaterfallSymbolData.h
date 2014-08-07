//
//  ISSChartWaterfallSymbolData.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-10.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"


@interface ISSChartWaterfallSymbolData : ISSChartBaseModelObject<NSCopying>

@property (nonatomic, assign) ISSChartSymbolType symbolType;

@property (nonatomic, assign) ISSChartFillStyle fillType;
@property (nonatomic, assign) CGFloat startValue;
@property (nonatomic, assign) CGFloat endValue;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGRect  frame;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) NSArray *fillColors;
@property (nonatomic, readonly) UIColor *fillColor;
@property (nonatomic, readonly) NSArray *gradientColors;

@end
