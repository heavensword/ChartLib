//
//  NSString+ITTAdditions.h
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (ITTAdditions)

- (BOOL)isStartWithString:(NSString*)start;
- (BOOL)isEndWithString:(NSString*)end;

- (NSInteger)numberOfLinesWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;

- (CGFloat)heightWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;
- (CGFloat)widthWithFont:(UIFont*)font withLineHeight:(NSInteger)lineHeight;
- (NSString *)md5;

@end

