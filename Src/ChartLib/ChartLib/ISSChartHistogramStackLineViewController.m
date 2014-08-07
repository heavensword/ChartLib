//
//  ISSChartHistogramStackViewController.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-11.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartHistogramStackLineViewController.h"
#import "ISSChartHistogramLineView.h"
#import "ISSChartHintView.h"
#import "ISSChartDataGenerator.h"
#import "ISSChartHistogramStackLineData.h"
#import "ISSChartHistogramStackLineView.h"
#import "ISSChartHistogramStackLineHintView.h"



@interface ISSChartHistogramStackLineViewController ()
{
    BOOL                        _changed;
    ISSChartHistogramStackLineView   *_histogramChartStackLineView;
}

@property (retain, nonatomic) IBOutlet UILabel *indicatorLabel;

@end

@implementation ISSChartHistogramStackLineViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [_histogramChartStackLineView release];
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
    ISSChartHistogramStackLineData *histogramStackData = [[ISSChartDataGenerator sharedInstance] histogramStackLineData];
    _histogramChartStackLineView = [[ISSChartHistogramStackLineView alloc] initWithFrame:self.view.bounds histogramStackLineData:histogramStackData];
    _histogramChartStackLineView.didSelectedLinePointBlock=  ^ISSChartHintView *(ISSChartHistogramStackLineView *lineView, NSInteger lineIndex, NSArray *value) {
        ITTDINFO(@"value %@", value);
        return [self getHintView:lineView lineIndex:lineIndex value:value];
    };
    //here need to optimization
    [self.view addSubview:_histogramChartStackLineView];
    [self.view bringSubviewToFront:self.indicatorLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_histogramChartStackLineView displayFirstShowAnimation];
}

#pragma mark - UIResponder
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (2 == touch.tapCount) {
        [_histogramChartStackLineView animationWithNewHistogramStackLine:[[ISSChartDataGenerator sharedInstance] histogramStackLineData] completion:^(BOOL completion) {
            if (completion) {
                ITTDINFO(@"completion!");                
            }
        }];
    }
}



#pragma mark - private methods
- (ISSChartHintView*)getHintView:(ISSChartHistogramStackLineView *)lineView lineIndex:(NSInteger)lineIndex value:(NSArray *)value
{
    NSString *identifier = @"ISSChartHistorgrameStackLineHintView";
    ISSChartHistogramStackLineHintView *hintView = (ISSChartHistogramStackLineHintView *)[lineView dequeueHintViewWithIdentifier:identifier];
    if (!hintView) {
        hintView = [ISSChartHistogramStackLineHintView loadFromNib];
        
    }
//    hintView.hint = [NSString stringWithFormat:@"%.2f%%", value];
    hintView.hintsArray = value;
    
    return hintView;
}


@end
