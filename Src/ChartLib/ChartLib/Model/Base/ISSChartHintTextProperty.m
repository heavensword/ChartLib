//
//  ISSChartHintTextProperty.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-17.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHintTextProperty.h"

@implementation ISSChartHintTextProperty

- (void)dealloc
{
    [_textColor release];
    [_text release];
    [super dealloc];
}

@end
