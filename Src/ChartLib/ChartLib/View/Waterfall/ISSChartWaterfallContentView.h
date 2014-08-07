//
//  ISSChartWaterfallContentView.h
//  ChartLib
//
//  Created by  Chen Haifeng on 13-7-9.
//  Copyright (c) 2013年 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSChartWaterfallContentView : UIView

@property (nonatomic, assign) id containerView;
@property (nonatomic, retain) NSArray *symbolDatas;

- (void)showDisplayAnimation:(void (^)(void))completion;
@end
