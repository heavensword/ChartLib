//
//  ISSChartParser.h
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartParser : ISSChartBaseModelObject

/*!
 * Parse the json froamt strong to object, see subclass comments
 * \params jsonString A json format string
 * \returns A subclass instance of ISSChartBaseData is returned
 */
- (id)chartDataWithJson:(NSString*)jsonString;

/*!
 * Convert position string to corresponding ISSChartLegendPosition value
 * \params positionString A json format string
 * \returns Value of ISSChartLegendPosition type
 */
- (ISSChartLegendPosition)legendPositionWithString:(NSString*)positionString;

- (NSArray*)colorsWithArrayOfHexString: (NSArray*)hexStringArray;

- (UIColor*)colorWithHexString:(NSString*)hexString;

- (BOOL)nullOrEmpetyProperty:(NSString*)propertyString;

@end
