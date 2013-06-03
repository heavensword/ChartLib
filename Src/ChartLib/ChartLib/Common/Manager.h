//
//  Manager.h
//  BaiHe
//
//  Created by huajian zhou on 12-3-16.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * subclass can override the class to custom your own manager.
 * you can add additional method and property.
 */

@interface Manager : NSObject
{  
}
+ (id)sharedInstance;

/*
 * subclass should override the method to implement data load operation
 */
- (void)loadData;
/*
 * subclass should override the method to clear memory cache operation
 */
- (void)clearMemoryCache;
/*
 * subclass may want to override the method to clear cache data when receive 
 * memory warning notification or the app enter background
 * see default implementation 
 */
- (void)clearCacheData;

@end
