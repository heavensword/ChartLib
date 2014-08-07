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

- (NSInteger)numberOfLinesWithFont:(UIFont*)font withLineWidth:(CGFloat)lineWidth;

- (CGFloat)heightWithFont:(UIFont*)font withLineWidth:(CGFloat)lineWidth;
- (CGFloat)widthWithFont:(UIFont*)font withLineHeight:(CGFloat)lineHeight;
- (NSString *)md5;

@end

