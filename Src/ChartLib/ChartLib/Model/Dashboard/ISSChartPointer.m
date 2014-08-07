//
//  ISSChartPointer.m
//  ChartLib
//
//  Created by Sword on 13-11-1.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartPointer.h"

@implementation ISSChartPointer

- (id)init
{
	self = [super init];
	if (self) {
		_image = [[UIImage imageNamed:@"pointer"] retain];
	}
	return self;
}

- (void)dealloc
{
    [_colors release];
	[_image release];
	[super dealloc];
}

@end
