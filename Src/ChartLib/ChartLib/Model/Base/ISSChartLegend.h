//
//  ISSChartLegend.h
//  ChartLib
//
//  Created by Sword Zhou on 6/3/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ISSChartBaseModelObject.h"

@interface ISSChartLegend : ISSChartBaseModelObject
{
@protected
	CGFloat _spacing;
	CGSize  _size;
	CGSize  _textSize;
	CGSize  _legnedSize;
	NSString *_name;
	UIColor  *_fillColor;
	UIColor  *_textColor;
	UIFont	 *_font;
	id	     _parent;
	ISSChartLegendType _type;
}

@property (nonatomic, assign) CGFloat spacing;
/*!
 * 图解小图的大小
 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize textSize;
/*!
 * 图解的大小
 */
@property (nonatomic, assign) CGSize legnedSize;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIColor  *fillColor;
@property (nonatomic, retain) UIColor  *textColor;
@property (nonatomic, retain) UIFont   *font;

@property (nonatomic, retain) id parent;

@property (nonatomic, assign) ISSChartLegendType type;

@end
