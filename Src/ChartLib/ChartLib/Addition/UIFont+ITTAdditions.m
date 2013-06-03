//
//  UIFont+ITTAdditions.m
//
//  Created by Rainbow on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIFont+ITTAdditions.h"


@implementation UIFont (ITTAdditions)

- (CGFloat)ittLineHeight {
    return (self.ascender - self.descender) + 1;
}

@end
