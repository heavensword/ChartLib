//
//  ISSChatGallery.m
//  ChartLib
//
//  Created by Sword Zhou on 5/27/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChatGallery.h"

@interface ISSChatGallery()
{
    NSMutableArray  *_chartItems;
}
@end

@implementation ISSChatGallery

@synthesize numberOfRows = _numberOfRows;

- (void)clearCacheData
{
	//Wo don't want to clear cache data, nothing implement
}

- (void)clearMemoryCache
{
	//Wo don't want to clear cache data, nothing implement
}

- (void)dealloc
{
    [_chartItems release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _chartItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerChart:(id)chart
{
    NSString *name = NSStringFromClass([chart class]);
    [_chartItems addObject:name];
}

- (NSInteger)numberOfRows
{
    return [_chartItems count];
}

- (NSString*)chartNameAtRow:(NSInteger)row
{
	if (_chartItems && row < [_chartItems count]) {
		return [_chartItems objectAtIndex:row];
	}
	else {
		return nil;
	}
}
@end
