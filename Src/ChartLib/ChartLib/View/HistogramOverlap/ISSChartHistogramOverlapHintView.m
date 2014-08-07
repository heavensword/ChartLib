//
//  ISSChartLineHintView.m
//  ChartLib
//
//  Created by Sword Zhou on 6/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapHintView.h"
#import "ISSChartHintTextProperty.h"
#import "UIColor-Expanded.h"

@interface ISSChartHistogramOverlapHintView()

@end

@implementation ISSChartHistogramOverlapHintView

- (void)dealloc
{
    [_hintsArray release];
    [_imageView release];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - setter
-(void)setHintsArray:(NSArray *)hintsArray
{
    RELEASE_SAFELY(_hintsArray);
    _hintsArray = [hintsArray retain];
    if (hintsArray && hintsArray.count < _hintsArray.count) {
        [self removeSubViewsWitchTagIsBigOrEqualTo:(ISSChart_Hint_Tag_Base+_hintsArray.count)];
    }
	[self adjust];
    [self updateSubViewsInfo];
}

- (void)adjust
{
	CGRect frame = self.frame;
	UIFont *font = [UIFont systemFontOfSize:13];
	CGFloat labelWidth = CGRectGetWidth(self.bounds) - DEFAULT_HINT_LABEL_LEFT_MARGIN - 5;
	CGFloat height = DEFAULT_HINT_LABEL_TOP_MARGIN + DEFAULT_HINT_LABEL_BOTTOM_MARGIN;
    for (int i = 0; i < _hintsArray.count; i++) {
        ISSChartHintTextProperty *property = _hintsArray[i];
		height += [property.text heightWithFont:font withLineWidth:labelWidth];
	}
	frame.size.height = height;
	self.frame = frame;
}

#pragma mark - private method
- (void)updateSubViewsInfo
{
    if (!_hintsArray || _hintsArray.count <= 0) {
        return;
    }
	UIFont *font = [UIFont systemFontOfSize:13];
	CGFloat labelWidth = CGRectGetWidth(self.bounds) - DEFAULT_HINT_LABEL_LEFT_MARGIN - 5;
	CGFloat marginY = DEFAULT_HINT_LABEL_TOP_MARGIN;
    for (int i = 0; i < _hintsArray.count; i++) {
        ISSChartHintTextProperty *property = _hintsArray[i];
        UILabel *label = (UILabel *)[self findViewWithTag:ISSChart_Hint_Tag_Base+i];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.tag = ISSChart_Hint_Tag_Base+i;
			label.numberOfLines = 0;
			label.font = font;
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [self addSubview:label];
            [label release];
        }
		CGFloat textHeight = [property.text heightWithFont:font withLineWidth:labelWidth];
		label.frame = CGRectMake(DEFAULT_HINT_LABEL_LEFT_MARGIN, marginY, labelWidth, textHeight);
		marginY += textHeight;
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

#pragma mark - public method

@end
