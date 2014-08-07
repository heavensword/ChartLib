//
//  ISSChartDashboardViewController.m
//  ChartLib
//
//  Created by Sword on 13-10-30.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartDashboardViewController.h"
#import "ISSChartDashboardView.h"
#import "ISSChartDataGenerator.h"
#import "ISSChartDashboardData.h"

@interface ISSChartDashboardViewController ()
{
	ISSChartDashboardData *_dashData;
	ISSChartDashboardView *_dashboardView;
}
@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartDashboardViewController

- (void)dealloc
{
	[_dashData release];
	[_dashboardView release];
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
	_dashData = [[[ISSChartDataGenerator sharedInstance] dashboardDataFromParser] retain];
	_dashboardView = [[ISSChartDashboardView alloc] initWithFrame:self.view.bounds];
	_dashboardView.dashboardData = _dashData;
	[self.view addSubview:_dashboardView];
	[self.view bringSubviewToFront:self.changeDataButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

#pragma mark - private methods
- (IBAction)onChangeDataButtonTouched:(id)sender
{
	ITTDINFO(@"- (IBAction)onChangeValueBtnTouched:(id)sender");
	_dashboardView.dashboardData = [[ISSChartDataGenerator sharedInstance] dashboardDataFromParser];
}


@end
