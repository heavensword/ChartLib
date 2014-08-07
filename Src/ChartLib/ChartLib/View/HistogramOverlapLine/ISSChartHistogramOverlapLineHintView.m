//
//  ISSChartLineHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapLineHintView.h"
#import "ISSChartHintTextProperty.h"


@interface ISSChartHistogramOverlapLineHintView()
{
}

@end

@implementation ISSChartHistogramOverlapLineHintView

- (void)dealloc
{
    [_hintsArray release];
    [_backgroundImageView release];
    [_hint release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - setter
- (void)adjust
{
    CGRect frame = self.frame;
    frame.size.height = _hintsArray.count * DEFAULT_HINT_LABEL_HEIGHT + DEFAULT_HINT_LABEL_TOP_MARGIN+ DEFAULT_HINT_LABEL_BOTTOM_MARGIN;
    frame.size.width = [self getFrameWidth];
    [self setFrame:frame];
}

-(void)setHintsArray:(NSArray *)hintsArray
{
    if (hintsArray && hintsArray.count < _hintsArray.count) {
        [self removeSubViewsWitchTagIsBigOrEqualTo:(ISSChart_Hint_Tag_Base+_hintsArray.count)];
    }
    RELEASE_SAFELY(_hintsArray);
    _hintsArray = [hintsArray retain];
	[self adjust];
    [self updateSubViewsInfo];
}

#pragma mark - private method
- (void)updateSubViewsInfo
{
    if (!_hintsArray || _hintsArray.count <= 0) {
        return;
    }
    for (NSInteger i = 0; i < _hintsArray.count; i++) {
        ISSChartHintTextProperty *property = _hintsArray[i];
        UILabel *label = (UILabel *)[self findViewWithTag:ISSChart_Hint_Tag_Base+i];
        if (!label) {
            float width = [self getFrameWidth];
            label = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_HINT_LABEL_LEFT_MARGIN, DEFAULT_HINT_LABEL_TOP_MARGIN+DEFAULT_HINT_LABEL_HEIGHT *i, width, DEFAULT_HINT_LABEL_HEIGHT)];
            label.tag = ISSChart_Hint_Tag_Base + i;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [self addSubview:label];
            [label release];
        }
        [label setText:property.text];
        [label setTextColor:property.textColor];
    }
}

#pragma mark - helper
- (UIView *)findViewWithTag:(NSInteger)tag
{
    for (UIView *subView in self.subviews){
        if (subView.tag == tag) {
            return subView;
        }
    }
    return nil;
}

- (void)removeSubViewsWitchTagIsBigOrEqualTo:(NSInteger)tag
{
    for (UIView *subView in self.subviews){
        if (subView.tag >= tag) {
            [subView removeFromSuperview];
        }
    }
}

- (float)getFrameWidth
{
    float width = 100;
    UIFont *font = [UIFont systemFontOfSize:17];
    for (ISSChartHintTextProperty *property in _hintsArray){
        CGSize size = [property.text sizeWithFont:font constrainedToSize:CGSizeMake(300, 100)];
        if (width < size.width) {
            width = size.width;
        }
    }
    width += DEFAULT_HINT_LABEL_LEFT_MARGIN * 2;
    return width;
}

@end
