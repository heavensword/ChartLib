//
//  ISSChartPieViewController.m
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartPieViewController.h"
#import "ISSChartPieView.h"
#import "ISSChartPieData.h"
#import "ISSChartPieSection.h"
#import "ISSChartPieSectionProperty.h"
#import "ISSChartColorUtil.h"

@interface ISSChartPieViewController ()
{
    ISSChartPieView *_pieView;
}

@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartPieViewController

- (void)dealloc
{
    [_pieView release];
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
    _pieView = [[ISSChartPieView alloc] initWithFrame:self.view.bounds pieData:[[ISSChartDataGenerator sharedInstance] pieDataFromParser]];
	_pieView.didSelectSection = ^ISSChartHintView *(ISSChartPieView *pieView, ISSChartPieSection *pieSection, ISSChartLegend *legend){
		ITTDINFO(@"didSelectSection section %@ legend %@", pieSection, legend);
		return nil;
	};
    [self.view addSubview:_pieView];
    [self.view bringSubviewToFront:self.changeDataButton];		
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_pieView displayFirstShowAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (IBAction)onChangeButtonTouched:(id)sender
{
	__block typeof(self)weakSelf = self;
	self.changeDataButton.userInteractionEnabled = FALSE;
	[_pieView animationWithPieData:[[ISSChartDataGenerator sharedInstance] pieDataFromParser] completion:^(BOOL completion){
		if (completion) {
			weakSelf.changeDataButton.userInteractionEnabled = TRUE;
			ITTDINFO(@"completion");
		}
	}];
}
@end
