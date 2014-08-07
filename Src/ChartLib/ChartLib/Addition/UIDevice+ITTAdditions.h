//
//  UIDevice+ITTAdditions.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD_DEVICE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

@interface UIDevice (ITTAdditions)

+ (UIInterfaceOrientation)currentOrientation;

- (BOOL) hasRetinaDisplay;
- (BOOL) is4InchScreen;
- (BOOL) isIpadDevice;

- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSString *) getMacAddress;
- (NSString *) platformString;

@end
