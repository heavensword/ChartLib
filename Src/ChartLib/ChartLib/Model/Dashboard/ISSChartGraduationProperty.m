//
//  ISSChartGraduationProperty.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartGraduationProperty.h"

@implementation ISSChartGraduationProperty

- (id)init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (void)dealloc
{
	[_image release];
	[_label release];
	[_textFont release];
	[_textColor release];
	[_lineColor release];
	[super dealloc];
}

@end
