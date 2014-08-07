//
//  ISSChartLineHintView.h
//  ChartLib
//
//  Created by Sword Zhou on 6/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHintView.h"
@class ISSChartHintTextProperty;

@interface ISSChartHistogramStackHintView : ISSChartHintView

@property (nonatomic, retain) NSArray *hintsArray;
@property (nonatomic, retain) NSString *hint;

- (void)showInView:(UIView *)view location:(CGPoint)location;

@end
