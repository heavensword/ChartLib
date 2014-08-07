//
//  ISSChartSymbolGenerator.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-8.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "Manager.h"

@interface ISSChartSymbolGenerator : Manager

- (UIImage *)arrrowImage:(ISSChartArrowDirection)direction size:(CGSize)size colors:(UIColor *)colors, ... NS_REQUIRES_NIL_TERMINATION;
- (UIImage *)rectangImageSize:(CGSize)size colors:(UIColor *)colors, ... NS_REQUIRES_NIL_TERMINATION;

@end
