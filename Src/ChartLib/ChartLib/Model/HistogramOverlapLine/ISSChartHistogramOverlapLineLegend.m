//
//  ISSChartHistogramOverlapLineLegend.m
//  ChartLib
//
//  Created by Sword on 13-12-16.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapLineLegend.h"
#import "ISSChartLineProperty.h"

@implementation ISSChartHistogramOverlapLineLegend

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (CGSize)legnedSize
{
    if (CGSizeEqualToSize(_legnedSize, CGSizeZero)) {
		ISSChartLineProperty *lineProperty = _parent;
        CGFloat height = _size.height;
        CGFloat textHeight = [_name heightWithFont:_font withLineWidth:CGFLOAT_MAX];
        if (height < textHeight) {
            height = textHeight;
        }
        CGFloat textWidth = [_name widthWithFont:_font withLineHeight:CGFLOAT_MAX];
        _textSize = CGSizeMake(textWidth, textHeight);
        _legnedSize.width = _size.width + _spacing + textWidth + 4 * lineProperty.radius;
        _legnedSize.height = height + _spacing;
    }
    return _legnedSize;
}
@end
