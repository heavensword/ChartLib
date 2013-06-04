//
//  ISSChartLegend.m
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLegend.h"

@implementation ISSChartLegend

- (id)init
{
    self = [super init];
    if (self) {
        _color = [[UIColor darkGrayColor] retain];
        _textColor = [[UIColor darkGrayColor] retain];
        _font = [[UIFont systemFontOfSize:10] retain];
    }
    return self;
}

- (void)dealloc
{
    [_font release];
    [_name release];
    [_color release];
    [_textColor release];    
    [super dealloc];
}

@end
