//
//  ISSChartHistogramOverlapViewController.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramOverlapLineViewController.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartDataGenerator.h"
#import "ISSChartHistogramOverlapLineData.h"
#import "ISSChartHistogramOverlapLineView.h"
#import "ISSChartHistogramOverlapLineHintView.h"
#import "ISSChartHistogramBarGroup.h"
#import "ISSChartHistogramBar.h"
#import "ISSChartHistogramBarProperty.h"
#import "ISSChartHintTextProperty.h"
#import "ISSChartLineProperty.h"
#import "ISSChartLine.h"

@interface ISSChartHistogramOverlapLineViewController ()
{
    BOOL                        _changed;
    ISSChartHistogramOverlapLineView   *_histogramChartOverlapLineView;
}

@property (retain, nonatomic) IBOutlet UIButton *changeDataButton;

@end

@implementation ISSChartHistogramOverlapLineViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
	[_changeDataButton release];
    [_histogramChartOverlapLineView release];
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
	__block typeof(self) weakSelf = self;
    ISSChartHistogramOverlapLineData *histogramOverlapData = [[ISSChartDataGenerator sharedInstance] histogramOverlapLineDataFromParser];
    _histogramChartOverlapLineView = [[ISSChartHistogramOverlapLineView alloc] initWithFrame:self.view.bounds histogramOverlapLineData:histogramOverlapData];
    _histogramChartOverlapLineView.didSelectedBarsBlock =  ^ISSChartHintView *(ISSChartHistogramOverlapLineView *histogramOverlapLineView, NSInteger groupIndex) {
        return [weakSelf getHintView:histogramOverlapLineView groupIndex:groupIndex];
    };
    //here need to optimization
    [self.view addSubview:_histogramChartOverlapLineView];
    [self.view bringSubviewToFront:self.changeDataButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_histogramChartOverlapLineView displayFirstShowAnimation];
}

#pragma mark - private methods
- (IBAction)onChangeDataButtonTouched:(id)sender
{
	__block typeof(self) weakSelf = self;
	weakSelf.changeDataButton.userInteractionEnabled = FALSE;
	[_histogramChartOverlapLineView animationWithData:[[ISSChartDataGenerator sharedInstance] histogramOverlapLineDataFromParser] completion:^(BOOL completion) {
		if (completion) {
			ITTDINFO(@"completion!");
			weakSelf.changeDataButton.userInteractionEnabled = TRUE;
		}
	}];
}

- (ISSChartHintView*)getHintView:(ISSChartHistogramOverlapLineView *)histogramOverlapLineView groupIndex:(NSInteger)groupIndex
{
    NSString *identifier = @"ISSChartHistorgrameOverlapLineHintView";
    ISSChartHistogramOverlapLineHintView *hintView = (ISSChartHistogramOverlapLineHintView *)[histogramOverlapLineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramOverlapLineHintView loadFromNib];
    }	
	NSInteger legendArrayIndex = 0;
	ISSChartHistogramOverlapLineData *histogramOverlapLineData = histogramOverlapLineView.histogramOverlapLineData;
	//create popView hint data array
	NSMutableArray *hintDatas = [[NSMutableArray alloc] init];
	ISSChartHistogramBarGroup *group = [histogramOverlapLineData barGroups][groupIndex];
	for (NSInteger i = 0; i < [histogramOverlapLineData barCountOfPerGroup]; i++) {
		ISSChartHistogramBar *bar = group.bars[i];
		ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
		hintProperty.text = [NSString stringWithFormat:@"%.2f %@",bar.valueY, histogramOverlapLineData.legendTextArray[i]];
		hintProperty.textColor = bar.barProperty.fillColor;
		[hintDatas addObject:hintProperty];
		[hintProperty release];
		legendArrayIndex++;
	}
	
	for (ISSChartLine *line in histogramOverlapLineData.lines) {
		ISSChartHintTextProperty *hintProperty = [[ISSChartHintTextProperty alloc] init];
		hintProperty.text =[NSString stringWithFormat:@"%.2f %@",[line.values[groupIndex] floatValue], histogramOverlapLineData.legendTextArray[histogramOverlapLineData.legendTextArray.count - 1]];
		hintProperty.textColor = [[line lineProperty] strokeColor];
		[hintDatas addObject:hintProperty];
		
		[hintProperty release];
	}
	hintView.hintsArray = hintDatas;
	[hintDatas release];
    return hintView;
}


@end
