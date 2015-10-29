//
//  NSDateFormatter+QLDateFormatter.h
//  EnjoyFishing
//
//  Created by Shrek on 15/1/25.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (QLDateFormatter)

+ (instancetype)dateFormatter;

/**
 *  @brief 自定义时间Format的NSDateFormatter对象
 *
 *  @param dateFormat 自定义时间格式
 *
 *  @return 返回自定义时间Format的NSDateFormatter对象
 */
+ (instancetype)dateFormatterWithFormat:(NSString *)strFormat;

/**
 *  @brief 返回默认格式的NSDateFormatter对象
 *
 *  @return 返回默认格式(yyyy-MM-dd HH:mm:ss)的NSDateFormatter对象
 */
+ (instancetype)defaultDateFormatter;

@end
