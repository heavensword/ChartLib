//
//  ISSChartWaterfallViewController.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-8.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartWaterfallViewController.h"
#import "ISSChartWaterfallView.h"
#import "ISSChartDataGenerator.h"
#import "ISSChartWaterfallData.h"
#import "ISSChartWaterfallSymbolData.h"
#import "ISSChartWaterfallHintView.h"

@interface ISSChartWaterfallViewController ()
{
    ISSChartWaterfallView *_waterfallView;
}

@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartWaterfallViewController

- (void)dealloc
{
    [_waterfallView release];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    ISSChartWaterfallData *waterfallData = [[ISSChartDataGenerator sharedInstance] waterfallData];
    _waterfallView = [[ISSChartWaterfallView alloc] initWithFrame:self.view.bounds waterfallData:waterfallData];
	__block typeof(self)weakSelf = self;
    _waterfallView.didTappedOnSymbolBlock =  ^(ISSChartWaterfallView *waterfallView, ISSChartWaterfallSymbolData *symbolData, ISSChartAxisItem *axisItem) {
        ITTDINFO(@"didTappedOnSymbolBlock");
    };
    _waterfallView.didSelectedSymbolBlock = ^ISSChartHintView *(ISSChartWaterfallView *waterfallView, ISSChartWaterfallSymbolData *symbolData, ISSChartAxisItem *axisItem) {
        return [weakSelf getHintView:waterfallView symbolData:symbolData];
    };
    [self.view addSubview:_waterfallView];
    [self.view bringSubviewToFront:self.changeDataButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_waterfallView displayFirstShowAnimation];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - private methods
- (IBAction)onChangeDataBtnTouched:(id)sender
{
    self.changeDataButton.userInteractionEnabled = FALSE;
    __block typeof (self) weakSelf = self;
    [_waterfallView animationWithData:[[ISSChartDataGenerator sharedInstance] waterfallData] completion:^(BOOL finished){
        if (finished) {
            weakSelf.changeDataButton.userInteractionEnabled = TRUE;
        }
    }];
}

- (ISSChartWaterfallHintView *)getHintView:(ISSChartWaterfallView *)lineView symbolData:(ISSChartWaterfallSymbolData*)symbolData
{
    NSString *identifier = @"ISSChartWaterfallHintView";
    ISSChartWaterfallHintView *hintView = (ISSChartWaterfallHintView *)[lineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartWaterfallHintView loadFromNib];
    }
    hintView.hint = [NSString stringWithFormat:@"%.2f", symbolData.value];
    return hintView;
}
@end
