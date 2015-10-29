//
//  MBProgressHUD+QLHUDTool.h
//  CommonInfo
//
//  No Need To Import Frameworks. Just Use Me!
//
//  Created by QinglongYan on 11/25/13.
//  Copyright (c) 2014 QinglongYan. All rights reserved.
//  自定义HUD

#import "MBProgressHUD.h"

#define kImageSuccess @"MBProgressHUD.bundle/success.png"
#define kImageError @"MBProgressHUD.bundle/error.png"
#define kImageMessage @"MBProgressHUD.bundle/message.png"

#define kDelaySuccess 1.0
#define kDelayError 2.0

@interface MBProgressHUD (QLHUDTool)

/**
 * @brief 显示一个有自定义短暂提示文字和图片的HUD
 */
+ (void)showHUDWithTextString:(NSString *)strText InView:(UIView *)diaplayView;

/**
 * @brief 显示一个有自定义短暂提示文字和图片的HUD
 */
+ (void)showHUDWithTextString:(NSString *)strText customImg:(NSString *)strImgName inView:(UIView *)view Delay:(NSTimeInterval)interval ProgressHUDMode:(MBProgressHUDMode)mode;

+ (void)showHUDSuccessWithTextString:(NSString *)strText inView:(UIView *)view Delay:(NSTimeInterval)interval;
+ (void)showHUDErrorWithTextString:(NSString *)strText inView:(UIView *)view Delay:(NSTimeInterval)interval;
+ (void)showHUDMessageWithTextString:(NSString *)strText inView:(UIView *)view Delay:(NSTimeInterval)interval;


+ (void)showHUDWithTextString:(NSString *)strText InView:(UIView *)diaplayView ExcutingBlock:(void(^)())completeBlock;

@end
