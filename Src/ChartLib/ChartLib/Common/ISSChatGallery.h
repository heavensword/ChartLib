//
//  ISSChatGallery.h
//  ChartLib
//
//  Created by Sword Zhou on 5/27/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"

@class ISSChartView;

@interface ISSChatGallery : Manager

@property (nonatomic, assign, readonly) NSInteger numberOfRows;

- (void)registerChart:(id)chart;

- (NSString*)chartNameAtRow:(NSInteger)row;

@end
