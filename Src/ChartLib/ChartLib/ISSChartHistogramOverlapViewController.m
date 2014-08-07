//
//  ISSChartHistogramOverlapViewController.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapViewController.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartDataGenerator.h"
#import "ISSChartHistogramOverlapData.h"
#import "ISSChartHistogramOverlapView.h"
#import "ISSChartHistogramOverlapHintView.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartHintTextProperty.h"

@interface ISSChartHistogramOverlapViewController ()
{
    BOOL                        _changed;
    ISSChartHistogramOverlapView   *_histogramChartOverlapView;
}

@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartHistogramOverlapViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [_histogramChartOverlapView release];
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
    ISSChartHistogramOverlapData *histogramOverlapData = [[ISSChartDataGenerator sharedInstance] histogramOverlapDataFromParser];
    _histogramChartOverlapView = [[ISSChartHistogramOverlapView alloc] initWithFrame:self.view.bounds histogramOverlapData:histogramOverlapData];
	__block typeof(self)weakSelf = self;
    _histogramChartOverlapView.didSelectedBarsBlock =  ^ISSChartHintView *(ISSChartHistogramOverlapView *histogramOverlapView, NSInteger groupIndex) {
        return [weakSelf getHintView:histogramOverlapView groupIndex:groupIndex];
    };
    //here need to optimization
    [self.view addSubview:_histogramChartOverlapView];
    [self.view bringSubviewToFront:self.changeDataButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_histogramChartOverlapView displayFirstShowAnimation];
}

#pragma mark - UIResponder
- (IBAction)onChangeButtontouched:(id)sender
{
	__block typeof(self)weakSelf = self;
	weakSelf.changeDataButton.userInteractionEnabled = FALSE;
	[_histogramChartOverlapView animationWithData:[[ISSChartDataGenerator sharedInstance] histogramOverlapDataFromParser] completion:^(BOOL completion) {
		if (completion) {
			ITTDINFO(@"completion!");
			weakSelf.changeDataButton.userInteractionEnabled = TRUE;
		}
	}];
}

#pragma mark - private methods
- (ISSChartHintView*)getHintView:(ISSChartHistogramOverlapView *)histogramOverlapView groupIndex:(NSInteger)groupIndex
{
    NSString *identifier = @"ISSChartHistorgrameOverlapLineHintView";
    ISSChartHistogramOverlapHintView *hintView = (ISSChartHistogramOverlapHintView *)[histogramOverlapView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramOverlapHintView loadFromNib];        
    }
	NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
	ISSChartHistogramOverlapData *histogramOverlapData = histogramOverlapView.histogramOverlapData;
	ISSChartHistogramBarGroup *group = [histogramOverlapData barGroups][groupIndex];
	for (NSInteger i = 0; i < group.bars.count; i++) {
		ISSChartHistogramBar *bar = group.bars[i];
		ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
		hintProperty.text = [NSString stringWithFormat:@"%.2f %@", bar.valueY, histogramOverlapData.legendTextArray[i]];
		hintProperty.textColor = bar.barProperty.fillColor;
		[hintDatas addObject:hintProperty];
		[hintProperty release];
	}
	hintView.hintsArray = hintDatas;
	[hintDatas release];
    return hintView;
}

@end
