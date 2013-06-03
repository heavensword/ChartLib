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

- (void)dealloc
{
    [_chartItems release];
    _chartItems = nil;
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
    return [_chartItems objectAtIndex:row];
}
@end
