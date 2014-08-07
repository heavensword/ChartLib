//
//  ChatDetailViewController.m
//  ChartLib
//
//  Created by Sword Zhou on 5/27/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramViewController.h"
#import "ISSChartHistogramContentView.h"
#import "ISSChartHistogramAxisView.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSDashing.h"
#import "ISSChartHistogramData.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramView.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHintView.h"
#import "ISSChartHistogramHintView.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxisItem.h"

@interface ISSChartHistogramViewController ()
{
    BOOL                  _filter;
    BOOL                  _changed;
    ISSChartHistogramView *_histogramChartView;
}


@property (retain, nonatomic) IBOutlet UIButton *captureButton;
@property (retain, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartHistogramViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [_histogramChartView release];
    [_indicatorLabel release];
    [_captureButton release];
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
    self.view.multipleTouchEnabled = TRUE;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	__block typeof(self)weakSelf = self;
    _histogramChartView = [[ISSChartHistogramView alloc] initWithFrame:self.view.bounds histogram:[[ISSChartDataGenerator sharedInstance] histogramDataFromParser]];
    _histogramChartView.didSelectedBarBlock = ^ISSChartHintView *(ISSChartHistogramView *histogramChartView, ISSChartHistogramBar *bar, ISSChartAxisItem *axisItem) {
        return [weakSelf getHintView:histogramChartView bar:bar xAxisItem:axisItem];
    };
    //here need to optimization
    [self.view addSubview:_histogramChartView];
    [self.view bringSubviewToFront:self.indicatorLabel];
    [self.view bringSubviewToFront:self.captureButton];
    [self.view bringSubviewToFront:self.changeDataButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_histogramChartView displayFirstShowAnimation];
}

- (void)viewDidUnload
{
    [self setCaptureButton:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
	return TRUE;
}

// Notifies when rotation begins, reaches halfway point and ends.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	ITTDINFO(@"willRotateToInterfaceOrientation");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	ITTDINFO(@"didRotateFromInterfaceOrientation");
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	ITTDINFO(@"willAnimateRotationToInterfaceOrientation");
}

#pragma mark - UIResponder
- (IBAction)onAnimatedButtonTouched:(id)sender
{
	__block typeof(self)weakSelf = self;
	self.changeDataButton.userInteractionEnabled = FALSE;
	[_histogramChartView animationWithData:[[ISSChartDataGenerator sharedInstance] histogramDataFromParser] completion:^(BOOL completion) {
		if (completion) {
			weakSelf.changeDataButton.userInteractionEnabled = TRUE;
			ITTDINFO(@"completion!");
		}
	}];	
}

#pragma mark - private methods
- (IBAction)capture:(id)sender
{
    _filter = !_filter;
    if (_filter) {
        [_histogramChartView filterVisiableAreaByValue:120 maxValue:390];
    }
    else {
        [_histogramChartView resetFilter];
    }
}

- (ISSChartHintView*)getHintView:(ISSChartHistogramView*)histogramView bar:(ISSChartHistogramBar*)bar xAxisItem:(ISSChartAxisItem*)axisItem
{
    NSString *identifier = @"ISSChartHistogramHintView";
    ISSChartHistogramHintView *hintView = (ISSChartHistogramHintView*)[histogramView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramHintView loadFromNib];
    }
    NSString *unit = histogramView.histogramData.coordinateSystem.yAxis.unit;
	NSString *xunit = histogramView.histogramData.coordinateSystem.xAxis.unit;
    NSString *message = [NSString stringWithFormat:@"%@: %@\n %.2f 单位:%@", xunit, axisItem.name, bar.valueY, unit];
//    NSString *message = [NSString stringWithFormat:@"%.2f", bar.valueY];
    hintView.hint = message;
    return hintView;

}
@end
