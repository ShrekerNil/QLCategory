//
//  UIDevice+QLDevice.h
//  Demo_QLCategory
//
//  Created by Shrek on 15/7/30.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (QLDevice)

/**
 *  @brief  判断设备对象是否已经越狱
 *
 *  @return 返回对象的越狱状态
 */
- (BOOL)hasJailbroken;

@end
