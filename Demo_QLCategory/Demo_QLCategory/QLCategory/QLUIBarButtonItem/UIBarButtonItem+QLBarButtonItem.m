//
//  UIBarButtonItem+QLBarButtonItem.m
//  SinaNMB
//
//  Created by Shrek on 12/25/13.
//  Copyright (c) 2013 Shrek. All rights reserved.
//

#import "UIBarButtonItem+QLBarButtonItem.h"
#import "NSString+QLString.h"

@implementation UIBarButtonItem (QLBarButtonItem)

+ (UIBarButtonItem *)barButtonItemWithBackgroungImgName:(NSString *)strImgName Target:(id)target Action:(SEL)selector {
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgLeft = [UIImage imageNamed:strImgName];
    [btnItem setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [btnItem setBackgroundImage:[UIImage imageNamed:[strImgName stringByJointString:@"_highlighted"]] forState:UIControlStateHighlighted];
    [btnItem setBounds:(CGRect){CGPointZero, imgLeft.size}];
    [btnItem addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btnItem];
}

+ (UIBarButtonItem *)barButtonItemWithBackgroungImgName:(NSString *)strImgName Title:(NSString *)strTitle Size:(CGSize)size Target:(id)target Action:(SEL)selector {
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem setTitle:strTitle forState:UIControlStateNormal]; // 设置标题
    btnItem.titleLabel.font = [UIFont boldSystemFontOfSize:13]; // 设置字体
    UIImage *imgLeft = [UIImage imageNamed:strImgName];
    UIImage *imgLeftHighLighted = [UIImage imageNamed:[strImgName stringByJointString:@"_highlighted"]];
    imgLeft = [imgLeft stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    imgLeftHighLighted = [imgLeftHighLighted stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [btnItem setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [btnItem setBackgroundImage:imgLeftHighLighted forState:UIControlStateHighlighted];
    [btnItem setBounds:(CGRect){CGPointZero, size}];
    [btnItem addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btnItem];
}

@end
