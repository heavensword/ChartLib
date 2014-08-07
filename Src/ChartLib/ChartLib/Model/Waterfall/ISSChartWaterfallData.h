//
//  ISSChartWaterfallData.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@interface ISSChartWaterfallData : ISSChartBaseData

@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, retain) NSArray *symbols;

- (void)setStrokeColors:(NSArray*)strokeColors; //an array of colors
- (void)setFillColors:(NSArray*)fillColors;     //an array of color arrays
- (void)setValues:(NSArray *)values; 

- (void)adjustDataToZeroState;

@end
