/*
 *  ISSDashing.c
 *  NuAS Amethyst Graphics System
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 *  Modified by Sword on 5/27 2013
 */

#include "ISSDashing.h"

/** Definition of fixed dashing styles. */
const CGFloat kStyleDot[] = {2, 3};
const CGFloat kStyleDash[] = {15, 6};
const CGFloat kStyleDashDot[] = {15, 6, 2, 6};

/** @brief Set the line dashing style.
 
    @param aContext Drawing context.
    @param dashStyle Style of dashing to be used.
 */
void ISSContextSetLineDash(const CGContextRef aContext, const ISSDashingStyle dashStyle)
{    
    switch (dashStyle) {
        case kDashingSolid:
            CGContextSetLineDash(aContext, 0., NULL, 0);
            break;
        case kDashingDotted:
            CGContextSetLineDash(aContext, 0., kStyleDot, 2);
            break;
        case kDashingDashed:
            CGContextSetLineDash(aContext, 0., kStyleDash, 2);
            break;
        case kDashingDashDotted:
            CGContextSetLineDash(aContext, 0., kStyleDot, 4);
            break;
        default:
            CGContextSetLineDash(aContext, 0., NULL, 0);            
            break;
    }
}

