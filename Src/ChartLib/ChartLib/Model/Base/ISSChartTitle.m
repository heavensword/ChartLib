//
//  ISSChartTitle.m
//  ChartLib
//
//  Created by Sword on 13-12-4.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartTitle.h"

@interface ISSChartTitle()<NSCopying>

@end

@implementation ISSChartTitle

- (void)dealloc
{
	[_text release];
	[_font release];
	[_textColor release];
	[super dealloc];
}

- (id)initWithTitle:(ISSChartTitle*)chartTitle
{
	self = [super init];
	if (self) {
		_fontSize = chartTitle.fontSize;
		_text = [chartTitle.text copy];
		_font = [chartTitle.font retain];
		_textColor = [chartTitle.textColor retain];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	ISSChartTitle *chartTitle = [[ISSChartTitle alloc] initWithTitle:self];
	return chartTitle;
}


- (void)setFontSize:(CGFloat)fontSize
{
	_fontSize = fontSize;
	RELEASE_SAFELY(_font);
	_font = [[UIFont systemFontOfSize:_fontSize] retain];
}
@end
