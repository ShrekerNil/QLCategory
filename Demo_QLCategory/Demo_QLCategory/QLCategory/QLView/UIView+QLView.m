//
//  UIView+QLView.m
//  Demo_QLCategory
//
//  Created by Shrek on 28/02/2015.
//  Copyright (c) 2015 Shrek. All rights reserved.
//

#import "UIView+QLView.h"

@implementation UIView (QLView)

#pragma mark - DrawBorderLine
+ (void)viewByDrawingLineOnBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view
{
    [self viewByDrawingLineOnTopBorderWithLineWidth:thickNess Color:color InView:view];
    [self viewByDrawingLineOnRightBorderWithLineWidth:thickNess Color:color InView:view];
    [self viewByDrawingLineOnBottomBorderWithLineWidth:thickNess Color:color InView:view];
    [self viewByDrawingLineOnLeftBorderWithLineWidth:thickNess Color:color InView:view];
}

+ (void)viewByDrawingLineOnLeftBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view
{
    CGRect rectView = view.frame;
    UIView *ViewLineVerticalLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thickNess, rectView.size.height)];
    [ViewLineVerticalLeft setBackgroundColor:color];
    [ViewLineVerticalLeft setTag:kLineViewTagLeft];
    [view addSubview:ViewLineVerticalLeft];
}

+ (void)viewByDrawingLineOnRightBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view
{
    CGRect rectView = view.frame;
    UIView *ViewLineVerticalRight = [[UIView alloc] initWithFrame:CGRectMake(rectView.size.width-thickNess, 0, thickNess, rectView.size.height)];
    [ViewLineVerticalRight setBackgroundColor:color];
    [ViewLineVerticalRight setTag:kLineViewTagRight];
    [view addSubview:ViewLineVerticalRight];
}
+ (void)viewByDrawingLineOnTopBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view
{
    CGRect rectView = view.frame;
    UIView *ViewLineHorizontalTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rectView.size.width, thickNess)];
    [ViewLineHorizontalTop setBackgroundColor:color];
    [ViewLineHorizontalTop setTag:kLineViewTagTop];
    [view addSubview:ViewLineHorizontalTop];
}
+ (void)viewByDrawingLineOnBottomBorderWithLineWidth:(CGFloat)thickNess Color:(UIColor *)color InView:(UIView *)view
{
    CGRect rectView = view.frame;
    UIView *ViewLineHorizontalBottom = [[UIView alloc] initWithFrame:CGRectMake(0, rectView.size.height-thickNess, rectView.size.width, thickNess)];
    [ViewLineHorizontalBottom setBackgroundColor:color];
    [ViewLineHorizontalBottom setTag:kLineViewTagBottom];
    [view addSubview:ViewLineHorizontalBottom];
}

@end
