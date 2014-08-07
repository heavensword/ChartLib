//
//  ISSLineViewController.m
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartLineViewController.h"
#import "ISSChartLineData.h"
#import "ISSChartCoordinateSystem.h"
#import "ISSChartAxis.h"
#import "ISSChartAxisProperty.h"
#import "ISSChartLineView.h"
#import "ISSChartLineHintView.h"
#import "ISSChartline.h"
#import "ISSChartAxisItem.h"

@interface ISSChartLineViewController ()
{
    BOOL                _changed;
    ISSChartLineView    *_lineView;
}
@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartLineViewController

- (void)dealloc
{
	[_lineView release];
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
    _lineView = [[ISSChartLineView alloc] initWithFrame:self.view.bounds lineData:[[ISSChartDataGenerator sharedInstance] lineDataFromParser]];
	__block typeof(self)weakSelf = self;
    _lineView.didSelectedLinesBlock = ^ISSChartHintView *(ISSChartLineView *lineView, NSArray *lines, NSInteger index, ISSChartAxisItem *xAxisItem) {
		return [weakSelf getHintView:lineView lines:lines index:index xAxisItem:xAxisItem];
    };
    //here need to optimization
    [self.view addSubview:_lineView];
    [self.view bringSubviewToFront:self.changeDataButton];	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_lineView displayFirstShowAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (ISSChartHintView*)getHintView:(ISSChartLineView*)lineView lines:(NSArray*)lines index:(NSInteger)index xAxisItem:(ISSChartAxisItem*)axisItem
{
    NSString *identifier = @"ISSChartLineHintView";
    ISSChartLineHintView *hintView = (ISSChartLineHintView*)[lineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartLineHintView loadFromNib];
    }
	NSMutableString *message = [NSMutableString string];
    NSString *unit = lineView.lineData.coordinateSystem.yAxis.unit;
	for (ISSChartLine *line in lines) {
		CGFloat value = [line.values[index] floatValue];
		[message appendFormat:@"%@:%.2f %@\n", line.name, value, unit];
	}
    hintView.hint = message;
    return hintView;
}

#pragma mark - UIResponder
- (IBAction)onChangeButtonTouched:(id)sender
{
    self.changeDataButton.userInteractionEnabled = FALSE;
	__block typeof(self)weakSelf = self;
	[_lineView animationWithData:[[ISSChartDataGenerator sharedInstance] lineDataFromParser] completion:^(BOOL completion){
		if (completion) {
			ITTDINFO(@"completion!");
            weakSelf.changeDataButton.userInteractionEnabled = TRUE;
		}
	}];
}
@end
