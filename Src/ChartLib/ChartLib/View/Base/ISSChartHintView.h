//
//  ISSChartBarHintView.h
//  ChartLib
//
//  Created by Sword Zhou on 6/4/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSChartHintView : UIView

@property (nonatomic, retain) NSString *reuseIdentifier;

- (void)show;

- (void)adjust;

+ (id)loadFromNib;

@end

