/**
 *  @file
 *  ISSDashing.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines basic functions of the NuAS Amethyst Graphics
 *  library. It defines functions and data types for supporting
 *  pre-defined dashing styles in 2D data-related chart curves.
 *
 *  @note: Dash sizes are constant and fixed now! The size is
 *         appropriate for both iPhone and iPad.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 *  Modified by Sword on 5/27 2013
 */

#ifndef __ISSDashing_H__
#define __ISSDashing_H__

#include <CoreGraphics/CoreGraphics.h>

/** Styles of dashing a line can be drawn with. */
typedef enum _ISSDashingStyle {
    kDashingNone,
    kDashingSolid,
    kDashingDotted,
    kDashingDashed,
    kDashingDashDotted
} ISSDashingStyle;

/** Predefined fixed dashing styles (constant length). */
extern const CGFloat kStyleDot[];
extern const CGFloat kStyleDash[];
extern const CGFloat kStyleDashDot[];

void ISSContextSetLineDash(const CGContextRef, const ISSDashingStyle);

#endif /* __ISSDashing_H__ */

