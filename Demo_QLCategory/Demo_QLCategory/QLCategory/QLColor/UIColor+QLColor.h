//
//  UIColor+QLColor.h
//  Demo_QLCategory
//
//  Created by Shrek on 15/1/30.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Color Related */
#define QLColorWithRGB(redValue, greenValue, blueValue) ([UIColor colorWithRed:((redValue)/255.0) green:((greenValue)/255.0) blue:((blueValue)/255.0) alpha:1])
#define QLColorRandom QLColorWithRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define QLColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (QLColor)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorFromPoint:(CGPoint)point InView:(__kindof UIView *)view;
+ (NSString *)hexFromUIColor: (UIColor*) color;

@end
