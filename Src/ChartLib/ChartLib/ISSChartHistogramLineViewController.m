//
//  ChatDetailViewController.m
//  ChartLib
//
//  Created by Sword Zhou on 5/27/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramLineViewController.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartHistogramLineHintView.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartLine.h"
#import "ISSChartHistogramLineData.h"
#import "ISSChartAxis.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxisItem.h"

@interface ISSChartHistogramLineViewController ()
{
    BOOL                        _changed;
    ISSChartHistogramLineView   *_histogramChartLineView;
}

@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartHistogramLineViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [_histogramChartLineView release];
	[_changeDataButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	__block typeof(self)weakSelf = self;
    ISSChartHistogramLineData *histogramLineData = [[ISSChartDataGenerator sharedInstance] histogramLineDataFromParser];
    _histogramChartLineView = [[ISSChartHistogramLineView alloc] initWithFrame:self.view.bounds histogramLineData:histogramLineData];
    _histogramChartLineView.didSelectedBarBlock = ^ISSChartHintView *(ISSChartHistogramLineView *histogramLineView, ISSChartHistogramBar *bar, NSArray *lines, NSInteger indexOfValueOnLine, ISSChartAxisItem *xAxisItem) {
        return [weakSelf getHintView:histogramLineView bar:bar lines:lines indexOfValueOnLine:indexOfValueOnLine xAxisItem:xAxisItem];
    };
    //here need to optimization
    [self.view addSubview:_histogramChartLineView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_histogramChartLineView displayFirstShowAnimation];
    [self.view bringSubviewToFront:self.changeDataButton];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - UIResponder
- (IBAction)onChangeDataButtonTouched:(id)sender
{
	self.changeDataButton.userInteractionEnabled = FALSE;	
	__block typeof(self)weakSelf = self;
	[_histogramChartLineView animationWithData:[[ISSChartDataGenerator sharedInstance] histogramLineDataFromParser] completion:^(BOOL completion) {
		if (completion) {
			ITTDINFO(@"completion!");
			weakSelf.changeDataButton.userInteractionEnabled = TRUE;
		}
	}];
}

#pragma mark - private methods
- (ISSChartHintView*)getHintView:(ISSChartHistogramLineView*)histogramLineView bar:(ISSChartHistogramBar*)bar lines:(NSArray *)lines indexOfValueOnLine:(NSInteger)index xAxisItem:(ISSChartAxisItem*)axisItem
{
    NSString *identifier = @"ISSChartHistogramLineHintView";
    ISSChartHistogramLineHintView *hintView = (ISSChartHistogramLineHintView*)[histogramLineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramLineHintView loadFromNib];
    }
    NSString *unit = histogramLineView.histogramLineData.coordinateSystem.yAxis.unit;
    NSString *vunit = histogramLineView.histogramLineData.coordinateSystem.viceYAxis.unit;
    NSMutableString *message = [NSMutableString stringWithFormat:@"时间: %@\n%@ %.2f 单位%@\n", axisItem.name, bar.name, bar.valueY, unit];
	for (ISSChartLine *line in lines) {
		[message appendFormat:@"%@ %.2f 单位%@\n", line.name, [line.values[index] floatValue], vunit];
	}
//    NSString *message = [NSString stringWithFormat:@"%.1f", bar.valueY];
    hintView.hint = message;
    return hintView;
}
@end
