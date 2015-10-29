//
//  UIBarButtonItem+QLBarButtonItem.h
//  SinaNMB
//
//  Created by Shrek on 12/25/13.
//  Copyright (c) 2013 Shrek. All rights reserved.
//  返回一个UIBarButtonItem对象

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (QLBarButtonItem)

+ (UIBarButtonItem *)barButtonItemWithBackgroungImgName:(NSString *)strImgName Target:(id)target Action:(SEL)selector;

+ (UIBarButtonItem *)barButtonItemWithBackgroungImgName:(NSString *)strImgName Title:(NSString *)strTitle Size:(CGSize)size Target:(id)target Action:(SEL)selector;

@end
