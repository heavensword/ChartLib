//
//  ISSChartCircle.m
//  ChartLib
//
//  Created by Sword on 13-11-1.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartCircle.h"

@implementation ISSChartCircle

- (id)init
{
	self = [super init];
	if (self) {
		_image = [[UIImage imageNamed:@"circle"] retain];
	}
	return self;
}

- (void)dealloc
{
	[_image release];
	[super dealloc];
}

@end
