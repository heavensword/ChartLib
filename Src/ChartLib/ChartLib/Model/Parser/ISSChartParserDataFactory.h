//
//  ISSChartParserFactory.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "Manager.h"

@class ISSChartParser;

@interface ISSChartParserDataFactory : Manager

/*!
 * create an instance of ISSChartParser according to chartType
 * \params chartType indicate which subclass of ISSChartParser to be created
 * \returns an subclass instance of ISSChartParser
 */
+ (ISSChartParser*)parserWithType:(ISSChartType)chartType;

@end
