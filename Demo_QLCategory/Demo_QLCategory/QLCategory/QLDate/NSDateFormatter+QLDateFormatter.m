//
//  NSDateFormatter+QLDateFormatter.m
//  EnjoyFishing
//
//  Created by Shrek on 15/1/25.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "NSDateFormatter+QLDateFormatter.h"

@implementation NSDateFormatter (QLDateFormatter)

+ (instancetype)dateFormatter {
    return [[self alloc] init];
}

+ (instancetype)dateFormatterWithFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (instancetype)defaultDateFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
