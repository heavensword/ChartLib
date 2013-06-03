//
//  Manager.m
//  BaiHe
//
//  Created by huajian zhou on 12-3-16.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//
#import <libkern/OSAtomic.h>
#import "Manager.h"

static NSMutableDictionary *_instancesDic = nil;

@implementation Manager

+ (id)sharedInstance
{
    @synchronized(_instancesDic){
        if (!_instancesDic)
        {
            _instancesDic = [[NSMutableDictionary alloc] init];
        }
        NSString *key = NSStringFromClass([self class]);
        id instance = [_instancesDic objectForKey:key];
        if (!instance)
        {
            instance = [[self alloc] init];
            [_instancesDic setObject:instance forKey:key];
            [instance release];
        }
        return instance;
    }
}

- (void)clearCacheData
{
    ITTDINFO(@"%@ clearCacheData", [self class]);    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self clearMemoryCache];
    NSString *key = NSStringFromClass([self class]);    
    [_instancesDic removeObjectForKey:key];
    [pool drain];
}

- (void)clearMemoryCache
{
    ITTDINFO(@"%@ clearMemoryCache", [self class]);        
}

- (void)registerMemoryWarningNotification
{
    #if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];    
    /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
      */  
    #ifdef __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
        {
            // When in background, clean memory in order to have less chance to be killed
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearCacheData)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
    #endif
    #endif
}

- (void)loadData
{
}
/*
 * It overrides the allocWithZone: method to ensure that another instance is not allocated
 * if someone tries to allocate and initialize an instance of your class directly instead of using the
 * class factory method. Instead, it just returns the shared object.
 *
 * on the other hand, If you want a singleton instance (created and controlled by the class factory method) 
 * but also have the ability to create other instances as needed through allocation and initialization, 
 * do not override allocWithZone method
 */
//+ (id)allocWithZone:(NSZone *)zone
//{
//    return [[self sharedInstance] retain];
//}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return NSUIntegerMax;  // denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    ITTDINFO(@"%@ init", [self class]);
    self = [super init];
    if (self) 
    {        
        ITTDINFO(@"Manager init");
        [self registerMemoryWarningNotification];
        [self loadData];        
    }
    return self;
}
@end
