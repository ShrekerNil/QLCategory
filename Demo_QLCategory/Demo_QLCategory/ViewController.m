//
//  ViewController.m
//  Demo_QLCategory
//
//  Created by Shrek on 15/1/30.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+QLColor.h"
#import "UIImage+QLImage.h"
#import "UIDevice+QLDevice.h"
#import "NSDate+QLDate.h"
#import "NSString+QLString.h"

// 调试打印
/** QLDEBUG Print | M:method, L:line, C:content*/
#ifndef QLLog
#ifdef DEBUG
#define QLLog(FORMAT, ...) fprintf(stderr,"M:%s|L:%d|C->%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define QLLog(FORMAT, ...)
#endif
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:QLColorWithRGB(250, 100, 200)];
    
    //[self testForDate];
    
    //[self testForQLColor];
    //[self testForTransparentBorder];
    
    //[UIDevice hasJailbroken];
    
    [self testForString];
}

- (void)testForString {
    NSString *strPrice = @"44523.25";
    strPrice = [NSString formattedPriceFromString:strPrice];
    QLLog(@"%@", strPrice);
}

- (void)testForDate {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [formatter dateFromString:@"2015-02-20"];
    QLLog(@"%@", date);
    QLLog(@"Days:%zi", [NSDate daysInMonthFromDate:date]);
    QLLog(@"Weeks:%zi", [NSDate weeksInMonthFromDate:date]);
}

- (void)testForTransparentBorder {
    UIImageView *imageViewO = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    UIImage *imageO = [UIImage imageNamed:@"1"];
    UIImage *imgWithBotder = [imageO transparentBorderImage:10];
    [imageViewO setImage:imgWithBotder];
                                                                           
    [self.view addSubview:imageViewO];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 260, 200, 200)];
    [imageView setImage:imageO];
    [self.view addSubview:imageView];
}

- (void)testForQLColor {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    
    [label setNumberOfLines:0];
    [label setText:@"我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色我的颜色"];
    
    [label setTextColor:QLColorFromHex(0xDC143C)];
    
    QLLog(@"%s~%@", __FUNCTION__, [UIColor hexFromUIColor:QLColorWithRGB(220, 20, 60)]);
    
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIColor *color = [UIColor colorFromPoint:[[touches anyObject] locationInView:self.view] InView:self.view];
    NSString *strHex = [UIColor hexFromUIColor:color];
    QLLog(@"%@", strHex);
}

@end
