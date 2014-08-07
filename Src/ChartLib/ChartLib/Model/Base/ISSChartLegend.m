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
        _spacing = 4;
        _legnedSize = CGSizeZero;
        _fillColor = [[UIColor darkGrayColor] retain];
        _textColor = [[UIColor darkGrayColor] retain];
        _font = [[UIFont systemFontOfSize:14] retain];
        _size = CGSizeMake(DEFAULT_LEGEND_UNIT_HEIGHT/2, DEFAULT_LEGEND_UNIT_HEIGHT/2);
    }
    return self;
}

- (CGSize)legnedSize
{
    if (CGSizeEqualToSize(_legnedSize, CGSizeZero)) {
        CGFloat height = _size.height;
        CGFloat textHeight = [_name heightWithFont:_font withLineWidth:CGFLOAT_MAX];
        if (height < textHeight) {
            height = textHeight;
        }
        CGFloat textWidth = [_name widthWithFont:_font withLineHeight:CGFLOAT_MAX];
        _textSize = CGSizeMake(textWidth, textHeight);
        _legnedSize.width = _size.width + _spacing + textWidth;
        _legnedSize.height = height + _spacing;
    }
    return _legnedSize;
}

- (void)dealloc
{
    [_parent release];
    [_font release];
    [_name release];
    [_fillColor release];
    [_textColor release];    
    [super dealloc];
}

@end
