//
//  ViewController.m
//  ChartLib
//
//  Created by Sword Zhou on 5/24/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "GalleryViewController.h"
#import "ISSChatGallery.h"
#import "ISSChartHistogramViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    ISSHistogramView *histogramView = [[ISSHistogramView alloc] initWithFrame:self.view.bounds];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (UIViewController*)chartDetailViewController:(NSString*)chartName
{
    NSString *className = [chartName stringByAppendingString:@"Controller"];
    Class class = NSClassFromString(className);
    UIViewController *viewController = [[class alloc] initWithNibName:className bundle:nil];
    NSString *assertMessage = [NSString stringWithFormat:@"could not load NIB in bundle with nibname %@", chartName];
    NSAssert((viewController != nil), assertMessage);
    return [viewController autorelease];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ISSChatGallery sharedInstance] numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ChartViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[ISSChatGallery sharedInstance] chartNameAtRow:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    NSString *chartName = [[ISSChatGallery sharedInstance] chartNameAtRow:indexPath.row];
    UIViewController *chartViewController = [self chartDetailViewController:chartName];
    [self.navigationController pushViewController:chartViewController animated:TRUE];
}
@end