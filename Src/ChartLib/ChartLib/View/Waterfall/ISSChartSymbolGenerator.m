//
//  ISSChartSymbolGenerator.m
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-8.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import "ISSChartSymbolGenerator.h"

@implementation ISSChartSymbolGenerator

-(void)dealloc
{
    [super dealloc];
}

- (UIImage *)arrrowImage:(ISSChartArrowDirection)direction size:(CGSize)size colors:(UIColor *)colors, ...
{
    ITTDINFO(@"size:%@", NSStringFromCGSize(size));
    UIColor *eachObject;
    va_list argumentList;
    NSMutableArray *colorsArray = [[NSMutableArray alloc]init];
    if (colors){
        [colorsArray addObject: (id)colors.CGColor];
        va_start(argumentList, colors);
        while ((eachObject = va_arg(argumentList, id))){
            [colorsArray addObject: (id)eachObject.CGColor];
        }
        va_end(argumentList);
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef     context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGMutablePathRef pathRef = [self arrowPathwithSize:size direction:direction];
    CGContextAddPath(context, pathRef);
    CGContextClip(context);    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat locations[] = {0.0,1.0}; //颜色所在位置

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colorsArray, locations);//构造渐变

    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
    

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);//绘制渐变效果图
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    [colorsArray release];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)rectangImageSize:(CGSize)size colors:(UIColor *)colors, ...
{
    ITTDINFO();
    UIColor *eachObject;
    va_list argumentList;
    NSMutableArray *colorsArray = [[NSMutableArray alloc]init];
    if (colors){
        [colorsArray addObject: (id)colors.CGColor];
        va_start(argumentList, colors);
        while ((eachObject = va_arg(argumentList, id))){
            [colorsArray addObject: (id)eachObject.CGColor];
        }
        va_end(argumentList);
    }
    

    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    ITTDINFO(@"%@",context);
    CGContextSaveGState(context);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGFloat locations[] = {0.0,1.0}; //颜色所在位置

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colorsArray, locations);//构造渐变

    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));


    CGContextAddRect(context, frame);//设置绘图的范围

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);//绘制渐变效果图
    CGContextRestoreGState(context);//恢复状态

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    [colorsArray release];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;


}

-(CGMutablePathRef)arrowPathwithSize:(CGSize)size direction:(ISSChartArrowDirection)direction
{
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    float triangleHeight = 1.0/3 * size.height;
    float tailWidth = 1.0/3 * size.width;    
    CGPoint x1,x21,x22,x23,x24,x31,x32;
    switch (direction) {
        case ISSChartArrowDirectionUp:
            x1 = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
            x21 = CGPointMake(CGRectGetMinX(frame), triangleHeight);
            x22 = CGPointMake((size.width - tailWidth)/2, triangleHeight);
            x23 = CGPointMake((size.width - tailWidth)/2+ tailWidth , triangleHeight);
            x24 = CGPointMake(CGRectGetMaxX(frame), triangleHeight);
            x31 = CGPointMake((size.width - tailWidth)/2, CGRectGetMaxY(frame));
            x32 = CGPointMake((size.width - tailWidth)/2 + tailWidth, CGRectGetMaxY(frame));
            break;
        case ISSChartArrowDirectionDown:
            
            x1 = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
            x21 = CGPointMake(CGRectGetMaxX(frame), size.height - triangleHeight);
            
            x22 = CGPointMake((size.width - tailWidth)/2+ tailWidth, size.height - triangleHeight);
            x23 = CGPointMake( (size.width - tailWidth)/2, size.height - triangleHeight);
            x24 = CGPointMake(CGRectGetMinX(frame), size.height - triangleHeight);
            
            x31 = CGPointMake((size.width - tailWidth)/2 + tailWidth, CGRectGetMinY(frame));
            x32 = CGPointMake((size.width - tailWidth)/2, CGRectGetMinY(frame));

            break;
        case ISSChartArrowDirectionLeft:
            
            break;
        case ISSChartArrowDirectionRight:
            
            break;
            
        default:
            break;
    }    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, x1.x, x1.y);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x24.x, x24.y);
    
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x23.x, x23.y);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x32.x, x32.y);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x31.x, x31.y);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x22.x, x22.y);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x21.x, x21.y);
    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x1.x, x1.y);
    
    CGPathCloseSubpath(pathRef);
    return (CGMutablePathRef)[NSMakeCollectable(pathRef) autorelease];
}


@end
