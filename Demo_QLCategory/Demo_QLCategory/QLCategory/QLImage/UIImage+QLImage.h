//
//  UIImage+QLImage.h
//  MirePo
//
//  Created by ZhuoJing01 on 14/11/6.
//  Copyright (c) 2014年 ZhuoJing01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QLImageTypeNone,
    QLImageTypeJpg,
    QLImageTypePng,
    QLImageTypeBmp,
    QLImageTypeGif
} QLImageType;

@interface UIImage (QLImage)

/**
 *  @brief 根据self,返回一个按照最大比例切割出来的图片(就是根据比例从原图的中间切取最大的图片返回)
 *
 *  @param ratio 想要的比例(像素宽/像素高)
 *
 *  @return 返回一个按照最大比例切割出来的图片
 */
- (UIImage *)cutImageMaxWithRatio:(CGFloat)ratio;

/**
 *  @brief 把传进来的UIScrollView转换成一个图片
 *
 *  @param scrollView  生成图片的对象
 *  @param fWidthFinal 生成对象的宽度(高度会根据scrollView的contentSize自动计算)
 *
 *  @return 返回生成的指定宽度的图片对象
 */
+ (UIImage *)captureView:(UIScrollView *)scrollView FinalWidth:(CGFloat)fWidthFinal;

/**
 *  @brief 伸缩图片大小
 *
 *  @param size 要伸缩的大小
 *
 *  @return 返回伸缩后的图片对象
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 *  @brief 加载图片资源
 *
 *  @param strImgName 要加载的图片名
 *
 *  @return 返回可自动释放内存的图片
 */
+ (UIImage *)imageWithName:(NSString *)strImgName;

/**
 *  @brief 根据图片的NSData来判断这个图片对象的格式
 *
 *  @param dataImage 图片对象的二进制数据
 *
 *  @return 返回该图片对象的格式
 */
- (QLImageType)imageTypeWithImageData:(NSData *)dataImage;

/**
 *  @brief 压缩图片(当图片的宽度>1000或者高度>2000,就会把对应的宽高等比例缩减到原有尺寸的3/5)
 *
 *  @param image 要处理的图片
 *
 *  @return 返回压缩后图片的NSData
 */
+ (NSData *)compressImage:(UIImage *)image;

#pragma mark - NEW
/**
 *  @brief 检查一个图片是否含有颜色通道
 *
 *  @return 返回是否含有颜色通道,如果含有颜色通道返回YES,否则返回NO
 */
- (BOOL)hasAlpha;


/**
 *  @brief 给图片对象添加颜色通道
 *
 *  @return 一个带有颜色通道的UIImage图片对象
 */
- (UIImage *)imageWithAlpha;

/**
 *  @brief 给UIImage对象添加一个透明边框, 如果该UIImage对象没有透明层(alpha layer),将会给该UIImage对象添加一个透明层(透明边框添加在原宽高的外侧)
 *
 *  @param borderSize 透明层的宽度
 *
 *  @return 返回一个带有borderSize宽度的透明边框
 */
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;


@end
