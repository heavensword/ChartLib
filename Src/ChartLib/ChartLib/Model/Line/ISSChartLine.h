//
//  ISSChartLine.h
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@class ISSChartLineProperty;

@interface ISSChartLine : ISSChartBaseModelObject

@property (nonatomic, assign) NSInteger lineIndex;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *values;
@property (nonatomic, retain) ISSChartLineProperty *lineProperty;

- (BOOL)isPointOnLine:(CGPoint)location;

- (NSInteger)findValueIndexOfLineWithLocation:(CGPoint)location;

- (CGPoint)firstPoint;
- (CGPoint)findPointLocationWithApproximateLocation:(CGPoint)location;

@end
