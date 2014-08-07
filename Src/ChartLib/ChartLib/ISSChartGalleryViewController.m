//
//  ISSChartGalleryViewController.m
//  ChartLib
//
//  Created by Sword on 13-12-6.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartGalleryViewController.h"
#import "ISSChatGallery.h"
#import "ISSChartViewCell.h"
#import "UIColor-Expanded.h"

@interface ISSChartGalleryViewController ()

@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *identifier = @"ISSChartViewCell";

@implementation ISSChartGalleryViewController

- (void)dealloc
{
	[_collectionView release];
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
	[self registerCell];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)registerCell
{
	UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
	[self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [[ISSChatGallery sharedInstance] numberOfRows];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	ISSChartViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	if (!cell) {
		ITTDINFO(@"null object");
	}
    NSString *chartName = [[ISSChatGallery sharedInstance] chartNameAtRow:indexPath.row];
	cell.chartName = chartName;
	ITTDINFO(@"cellForItemAtIndexPath %@", chartName);
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView deselectItemAtIndexPath:indexPath animated:TRUE];
    NSString *chartName = [[ISSChatGallery sharedInstance] chartNameAtRow:indexPath.row];
	if (chartName && [chartName length]) {
		UIViewController *chartViewController = [self chartDetailViewController:chartName];
		[self.navigationController pushViewController:chartViewController animated:TRUE];
	}
}

#pragma mark - private methods
- (UIViewController*)chartDetailViewController:(NSString*)chartName
{
    NSString *className = [chartName stringByAppendingString:@"Controller"];
    Class class = NSClassFromString(className);
    UIViewController *viewController = [[class alloc] initWithNibName:className bundle:nil];
    return [viewController autorelease];
}
@end
