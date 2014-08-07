//
//  ISSChartTitle.h
//  ChartLib
//
//  Created by Sword on 13-12-4.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartTitle : ISSChartBaseModelObject

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain, readonly) UIFont *font;
@end
