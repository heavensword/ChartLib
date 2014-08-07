//
//  ISSChartHistogramStackViewController.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackViewController.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartDataGenerator.h"
#import "ISSChartHistogramStackData.h"
#import "ISSChartHistogramStackView.h"
#import "ISSChartHistogramStackHintView.h"



@interface ISSChartHistogramStackViewController ()
{
    BOOL                        _changed;
    ISSChartHistogramStackView   *_histogramChartStackView;
}

@property (retain, nonatomic) IBOutlet UILabel *indicatorLabel;

@end

@implementation ISSChartHistogramStackViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [_histogramChartStackView release];
    [_indicatorLabel release];
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
    ISSChartHistogramStackData *histogramStackData = [[ISSChartDataGenerator sharedInstance] histogramStackData];
    _histogramChartStackView = [[ISSChartHistogramStackView alloc] initWithFrame:self.view.bounds histogramStackData:histogramStackData];
    _histogramChartStackView.didSelectedAreaPointBlock=  ^ISSChartHintView *(ISSChartHistogramStackView *lineView, NSInteger lineIndex, NSArray *value) {
        ITTDINFO(@"value %@", value);
        return [self getHintView:lineView lineIndex:lineIndex value:value];
    };
    //here need to optimization
    [self.view addSubview:_histogramChartStackView];
    [self.view bringSubviewToFront:self.indicatorLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_histogramChartStackView displayFirstShowAnimation];
}

#pragma mark - UIResponder
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (2 == touch.tapCount) {
        [_histogramChartStackView animationWithNewHistogramStack:[[ISSChartDataGenerator sharedInstance] histogramStackData] completion:^(BOOL completion) {
            if (completion) {
                ITTDINFO(@"completion!");                
            }
        }];
    }
}



#pragma mark - private methods

- (ISSChartHintView*)getHintView:(ISSChartHistogramStackView *)lineView lineIndex:(NSInteger)lineIndex value:(NSArray *)value
{
    NSString *identifier = @"ISSChartHistorgrameStackLineHintView";
    ISSChartHistogramStackHintView *hintView = (ISSChartHistogramStackHintView *)[lineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramStackHintView loadFromNib];
        
    }
    //    hintView.hint = [NSString stringWithFormat:@"%.2f%%", value];
    hintView.hintsArray = value;
    
    return hintView;
}


@end
