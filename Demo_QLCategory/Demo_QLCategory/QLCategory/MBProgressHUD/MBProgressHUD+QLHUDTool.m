//
//  MBProgressHUD+QLHUDQLHUDTool.h
//  CommonInfo
//
//  No Need To Import Frameworks. Just Use Me!
//
//  Created by QinglongYan on 11/25/13.
//  Copyright (c) 2014 QinglongYan. All rights reserved.
//  自定义HUD


#import "MBProgressHUD+QLHUDTool.h"

@implementation MBProgressHUD (QLHUDTool)

#pragma mark 显示一个有自定义短暂提示文字的HUD
/**
 * @brief 显示一个有自定义短暂提示文字的HUD,在停止的时候需要暂停networkActivityIndicator
 */
+ (void)showHUDWithTextString:(NSString *)strText InView:(UIView *)diaplayView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:diaplayView animated:YES];
	hud.labelText = strText;
    hud.dimBackground = YES;
}

#pragma mark 显示一个有自定义短暂提示文字和图片的HUD
/**
 * @brief 显示一个有自定义短暂提示文字和图片的HUD
 */
+ (void)showHUDWithTextString:(NSString *)strText customImg:(NSString *)strImgName inView:(UIView *)view Delay:(NSTimeInterval)interval ProgressHUDMode:(MBProgressHUDMode)mode {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = mode;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strImgName]];
    hud.labelText = strText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:interval];
    hud.dimBackground = YES; // HUD工作中默认情况下是不允许用户与界面进行交互的
}
+ (void)showHUDSuccessWithTextString:(NSString *)strText inView:(UIView *)view Delay:(NSTimeInterval)interval {
    [self showHUDWithTextString:strText customImg:kImageSuccess inView:view Delay:interval ProgressHUDMode:MBProgressHUDModeCustomView];
}
+ (void)showHUDErrorWithTextString:(NSString *)strText inView:(UIView *)view Delay:(NSTimeInterval)interval {
    [self showHUDWithTextString:strText customImg:kImageError inView:view Delay:interval ProgressHUDMode:MBProgressHUDModeCustomView];
}
+ (void)showHUDMessageWithTextString:(NSString *)strText inView:(UIView *)view Delay:(NSTimeInterval)interval {
    [self showHUDWithTextString:strText customImg:kImageMessage inView:view Delay:interval ProgressHUDMode:MBProgressHUDModeCustomView];
}

#pragma mark 显示一个有自定义短暂提示文字和图片的HUD,并且有一个回调的block,block执行完成后自动停止动画
/**
 * @brief 显示一个有自定义短暂提示文字和图片的HUD,并且有一个回调的block,block执行完成后自动停止动画
 */
+ (void)showHUDWithTextString:(NSString *)strText InView:(UIView *)diaplayView ExcutingBlock:(void(^)())completeBlock
{
	// No need to retain (just a local variable)
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:diaplayView animated:YES];
	hud.labelText = strText;
	hud.dimBackground = YES; // HUD工作中默认情况下是不允许用户与界面进行交互的
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		
		dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
            [MBProgressHUD hideHUDForView:diaplayView animated:YES]; // 延迟的时间后自动隐藏
		});
	});
}

@end
