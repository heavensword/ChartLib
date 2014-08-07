//
//  CommonFunction.h
//  ChartLib
//
//  Created by Sword Zhou on 6/18/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#ifndef ChartLib_CommonFunction_h
#define ChartLib_CommonFunction_h

#if !defined(TMIN)
#define TMIN(A,B,C)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B);__typeof__(C) __c = (C); __a = __a < __b ? __a : __b; __a < __c ? __a : __c; })
#endif

#if !defined(TMAX)
#define TMAX(A,B,C)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B);__typeof__(C) __c = (C); __a = __a > __b ? __a : __b; __a > __c ? __a : __c; })
#endif

#endif
