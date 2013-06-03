//
//  NSString+ITTAdditions.m
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSString+ITTAdditions.h"
#import "UIFont+ITTAdditions.h"


@implementation NSString (ITTAdditions)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth
{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:UILineBreakModeTailTruncation];
	NSInteger lines = size.height / [font ittLineHeight];
	return lines;
}

- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth
{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:UILineBreakModeTailTruncation];
	return size.height;
	
}

- (CGFloat)widthWithFont:(UIFont*)font
            withLineHeight:(NSInteger)lineHeight
{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(CGFLOAT_MAX, lineHeight)
                       lineBreakMode:UILineBreakModeTailTruncation];
	return size.width;
	
}

- (NSString *)md5
{
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}

- (BOOL)isStartWithString:(NSString*)start
{
    BOOL result = FALSE;
    NSRange found = [self rangeOfString:start options:NSCaseInsensitiveSearch];
    if (found.location == 0)
    {
        result = TRUE;
    }
    return result;
}

- (BOOL)isEndWithString:(NSString*)end
{
    NSInteger endLen = [end length];
    NSInteger len = [self length];
    BOOL result = TRUE;
    if (endLen <= len) {
        NSInteger index = len - 1;
        for (NSInteger i = endLen - 1; i >= 0; i--) {
            if ([end characterAtIndex:i] != [self characterAtIndex:index]) {
                result = FALSE;
                break;
            }
            index--;
        }
    }
    else {
        result = FALSE;
    }
    return result;
}
@end

