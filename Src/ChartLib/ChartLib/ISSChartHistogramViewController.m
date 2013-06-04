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
#import "ISSChartBar.h"
#import "ISSChartHistogramCoordinateSystem.h"
#import "ISSChartHistogramView.h"
#import "ISSChartBar.h"

@interface ISSChartHistogramViewController ()
{
    ISSChartHistogramView *_histogramChartView;
}

@property (retain, nonatomic) IBOutlet UILabel *indicatorLabel;

@end

@implementation ISSChartHistogramViewController

#pragma mark - lifecycle methods
- (void)dealloc
{
    [_histogramChartView release];
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
    _histogramChartView = [[ISSChartHistogramView alloc] initWithFrame:self.view.bounds histogram:[self histogram]];
    _histogramChartView.didSelectedBarBlock = ^(ISSChartHistogramView *histogramChartView , NSInteger index){
        ISSChartBar *bar = [_histogramChartView.histogram.bars objectAtIndex:index];
        self.indicatorLabel.text = [NSString stringWithFormat:@"%@ %.1f", bar.name, bar.valueY];
    };
    //here need to optimization    
    [self.view addSubview:_histogramChartView];
    [self.view bringSubviewToFront:self.indicatorLabel];
}

#pragma mark - UIResponder
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (2 == touch.tapCount) {
        [_histogramChartView animationWithNewHistogram:[self histogram]completion:^(BOOL completion) {
            if (completion) {
                ITTDINFO(@"completion!");
            }
        }];
    }
}

#pragma mark - private methods
- (ISSChartHistogramData*)histogram
{
    ISSChartHistogramData *histogram = [[ISSChartHistogramData alloc] init];
//    histogram.histogramStyle = ISSHistogramGradient;
    histogram.coordinateSystem.xAxis.axisProperty.axisStyle = kDashingNone;
    static BOOL changed = FALSE;
    NSArray *yValues = @[@(0), @(100), @(200), @(300), @(400), @(500)];
    NSArray *yNames = @[@"0", @"100", @"200", @"300", @"400", @"500"];
    NSArray *xValues = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11), @(12)];
    NSArray *xNames = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    [histogram setXAxisItemsWithNames:xNames values:xValues];
    [histogram setYAxisItemsWithNames:yNames values:yValues];
    histogram.legendArray = @[@"流量统计", @"总金额", @"测试名称"];
    histogram.legendPosition = ISSChartLegendPositionRight;
    histogram.coordinateSystem.xAxis.rotateAngle = 30;
//    histogram.coordinateSystem.yAxis.baseValue = 200;
    if (changed) {
        [histogram setBarColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor]]];
        [histogram setBarDataArraysWithValues:@[@"120", @"333", @"30", @"70", @"23", @"90", @"120", @"378", @"80", @"90", @"120", @"378"],@[@"90", @"330", @"310", @"70", @"80", @"340", @"120", @"378", @"430", @"90", @"120", @"378"],@[@"90", @"190", @"310", @"70", @"210", @"90", @"120", @"400", @"80", @"490", @"120", @"378"], nil];
    }
    else {
        [histogram setBarColors:@[[UIColor cyanColor], [UIColor yellowColor], [UIColor blueColor]]];
        [histogram setBarDataArraysWithValues:@[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"], @[@"120", @"378", @"80", @"90", @"120", @"378", @"90", @"190", @"310", @"70", @"80", @"90"],@[@"90",  @"70", @"90", @"120", @"190", @"310",@"378", @"80", @"70", @"90", @"333", @"378"], nil];
    }
    changed = !changed;
    return [histogram autorelease];
}
@end
