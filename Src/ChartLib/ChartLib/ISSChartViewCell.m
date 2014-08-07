//
//  ISSChartViewCell.m
//  ChartLib
//
//  Created by Sword on 13-12-6.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartViewCell.h"
#import "CustomCellBackground.h"
#import "ISSChartView.h"
#import "ISSChartViewGenerator.h"

@interface ISSChartViewCell()
{
	ISSChartView	*_chartView;
}
@end

@implementation ISSChartViewCell

- (void)dealloc
{
	ITTDINFO(@"ISSChartViewCell dealloc");
	[_chartName release];
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

- (void)awakeFromNib
{
	[super awakeFromNib];
	CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
	self.selectedBackgroundView = backgroundView;
	[backgroundView release];
	self.layer.cornerRadius = 6.0;
	self.layer.borderWidth = 1.0;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.layer.masksToBounds = TRUE;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setChartName:(NSString *)chartName
{
	RELEASE_SAFELY(_chartName);
	_chartName = [chartName retain];
	[self setupChartView];
}

- (void)setupChartView
{
	[_chartView removeFromSuperview];
	[_chartView release];
	_chartView = nil;
	
	if (_chartName && [_chartName length]) {
		ISSChartViewGenerator *chartViewGenerator = [ISSChartViewGenerator sharedInstance];
		_chartView = [[chartViewGenerator thumbnailChartViewWithChartName:_chartName frame:self.bounds] retain];
		_chartView.tapEnable = FALSE;
		_chartView.doubleTapEnable = FALSE;
		_chartView.panEnable = FALSE;
		[self addSubview:_chartView];
		[_chartView displayFirstShowAnimation];
	}
}
@end
