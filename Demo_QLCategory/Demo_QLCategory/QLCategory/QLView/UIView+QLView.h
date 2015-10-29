//
//  UIView+QLView.h
//  Demo_QLCategory
//
//  Created by Shrek on 28/02/2015.
//  Copyright (c) 2015 Shrek. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kLineViewTagBorder 150
#define kLineViewTagTop 151
#define kLineViewTagLeft 152
#define kLineViewTagBottom 153
#define kLineViewTagRight 154

@interface UIView (QLView)

#pragma mark - DrawBorderLine
+ (void)viewByDrawingLineOnBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view;
+ (void)viewByDrawingLineOnLeftBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view;
+ (void)viewByDrawingLineOnRightBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view;
+ (void)viewByDrawingLineOnTopBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view;
+ (void)viewByDrawingLineOnBottomBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view;

@end
