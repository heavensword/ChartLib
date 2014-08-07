//
//  ISSChartPieSectionProperty.h
//  ChartLib
//
//  Created by Sword Zhou on 6/9/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartPieSectionProperty : ISSChartBaseModelObject

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL textRectIntersection;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CGFloat startDegree;  //in radian
@property (nonatomic, assign) CGFloat endDegree;    //in radian
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat strokeWidth;

@property (nonatomic, assign) CGPoint lineOriginPoint;
@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;

@property (nonatomic, assign) CGRect valueRect;
@property (nonatomic, assign) CGRect percentageRect;
@property (nonatomic, assign) CGRect nameRect;

@property (nonatomic, retain) NSString *percentageString;
@property (nonatomic, retain) NSString *nameString;
@property (nonatomic, retain) NSString *valueString;

@property (nonatomic, retain) UIFont *textFont;

@property (nonatomic, retain) NSArray *fillColors;

@property (nonatomic, retain) UIColor *strokeColor;
/*!
 * Fill color of section, the first object of fillcolors
 */
@property (nonatomic, readonly) UIColor *fillColor;
/*!
 * A readonly array of cgcolor from fillcolors, 2 and 3 colors gradient supported
 */
@property (nonatomic, readonly) NSArray *gradientColors;

@end
