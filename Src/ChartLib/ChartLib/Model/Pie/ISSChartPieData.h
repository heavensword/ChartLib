//
//  ISSChartLineData.h
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseData.h"

@class ISSChartPieSection;

@interface ISSChartPieData : ISSChartBaseData

@property (nonatomic, assign) BOOL displayFullHintMessage;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat sectionSpacing;
@property (nonatomic, assign) CGFloat offsetStartDegree;
@property (nonatomic, assign) ISSChartFillStyle pieStyle;
@property (nonatomic, retain) NSArray *sections;

- (void)adjustRadius:(CGFloat)radius innerRadius:(CGFloat)innerRadius;
- (ISSChartPieSection*)findSelectedPieSectionWithLocation:(CGPoint)location;

@end
