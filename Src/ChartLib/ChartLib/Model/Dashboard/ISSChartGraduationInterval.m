//
//  ISSChartGraduationInterval.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartGraduationInterval.h"

@implementation ISSChartGraduationInterval

- (void)dealloc
{
	[_colors release];
	[_startGraduation release];
	[_endGraduation release];
	[super dealloc];
}

- (CFArrayRef)cgcolors
{
	NSMutableArray *cgcolors = [NSMutableArray arrayWithCapacity:[self.colors count]];
	for (UIColor *color in self.colors) {
		[cgcolors addObject:(id)color.CGColor];
	}
	return (CFArrayRef)cgcolors;
}

@end
