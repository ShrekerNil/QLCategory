//
//  UIImage+QLImage.m
//  MirePo
//
//  Created by ZhuoJing01 on 14/11/6.
//  Copyright (c) 2014年 ZhuoJing01. All rights reserved.
//

#import "UIImage+QLImage.h"

@implementation UIImage (QLImage)

/**
 *  @brief 根据self,返回一个按照最大比例切割出来的图片
 *
 *  @param ratio 想要的比例(像素的宽/像素的高)
 *
 *  @return 返回一个按照最大比例切割出来的图片
 */
- (UIImage *)cutImageMaxWithRatio:(CGFloat)ratio {
    CGSize sizeImage = self.size;
    CGFloat fWidthRes;
    CGFloat fHeightRes;
    UIImage *image = [[UIImage alloc] init];
    
    if (sizeImage.width > sizeImage.height) {
        fWidthRes = sizeImage.height / ratio;
        CGFloat fXRes = (sizeImage.width - fWidthRes) / 2;
        CGRect rectRes = CGRectMake(fXRes, 0, fWidthRes, sizeImage.height);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, rectRes)];
        return image;
    } else if (sizeImage.width < sizeImage.height) {
        fHeightRes = sizeImage.width * ratio;
        CGFloat fYRes = (sizeImage.height - fHeightRes) / 2;
        CGRect rectRes = CGRectMake(0, fYRes, sizeImage.width, fHeightRes);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, rectRes)];
        return image;
    } else {
        return self;
    }
    return nil;
}

/**
 *  @brief 把传进来的UIScrollView转换成一个图片
 *
 *  @param scrollView  生成图片的对象
 *  @param fWidthFinal 生成对象的宽度
 *
 *  @return 返回生成的指定宽度的图片对象
 */
+ (UIImage *)captureView:(UIScrollView *)scrollView FinalWidth:(CGFloat)fWidthFinal {
    CGSize size = scrollView.contentSize;
    
    CGFloat fWidth = size.width;
    CGFloat fHeight = size.height;
    
    CGFloat radio = fWidthFinal/fWidth;
    if (radio < 1) {
        fHeight = radio*fHeight;
    }
    
    CGSize contextSize = CGSizeMake(fWidthFinal, fHeight);
    
    UIGraphicsBeginImageContext(contextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [scrollView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  @brief 伸缩图片大小
 *
 *  @param size 要伸缩的大小
 *
 *  @return 返回伸缩后的图片对象
 */
- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:(CGRect){CGPointZero, size}];
    UIImage *imgScaled = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgScaled;
}

/**
 *  @brief 根据图片的NSData来判断这个图片对象的格式
 *
 *  @param dataImage 图片对象的二进制数据
 *
 *  @return 返回该图片对象的格式
 */
- (QLImageType)imageTypeWithImageData:(NSData *)dataImage {
    /**
     JPEG(jpg)，文件头：FFD8FF
     
     PNG (png)，文件头：89504E47
     
     GIF (gif)，文件头：47494638
     */
    if (dataImage.length >4) {
        const unsigned char * bytes = [dataImage bytes];
        if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
            return QLImageTypeJpg;
        } else if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
            return QLImageTypePng;
        } else if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x38) {
            return QLImageTypeGif;
        }
    }
    return QLImageTypeNone;
}

/**
 *  @brief 加载图片资源
 *
 *  @param strImgName 要加载的图片名
 *
 *  @return 返回可自动释放内存的图片
 */
+ (UIImage *)imageWithName:(NSString *)strImgName {
    NSString *strElemment = @"@2x";
    NSString *strSuffix = @".png";
    if ([strImgName rangeOfString:strElemment].length != 0) {
        if ([strImgName hasSuffix:strSuffix]) {
            strImgName = [strImgName stringByReplacingOccurrencesOfString:strSuffix withString:@""];
        }
        strImgName = [NSString stringWithFormat:@"%@%@", strImgName, strElemment];
    }
    if (![strImgName hasSuffix:strSuffix]) {
        strImgName = [NSString stringWithFormat:@"%@%@", strImgName, strSuffix];
    }
    NSString *strImgPath = [[NSBundle mainBundle] pathForResource:strImgName ofType:nil];
    if (strImgPath == nil) {
        strImgName = [strImgName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }
    strImgPath = [[NSBundle mainBundle] pathForResource:strImgName ofType:nil];
    
    return [UIImage imageWithContentsOfFile:strImgPath];
}

/**
 *  @brief 压缩图片(当图片的宽度>1000或者高度>2000,就会把对应的宽高等比例缩减到原有尺寸的3/5)
 *
 *  @param image 要处理的图片
 *
 *  @return 返回压缩后图片的NSData
 */
+ (NSData *)compressImage:(UIImage *)image {
    //QLLog(@"~~~~0.1~~~~%zi", [UIImageJPEGRepresentation(image, 1.0) length]);
    //压缩图片
    if (image.size.width > 1000 || image.size.height > 2000) {
        image = [image scaleToSize:CGSizeMake(image.size.width * 3/5.0, image.size.height*3/5.0)];
    }
    //QLLog(@"~~~~0.2~~~~%zi", [UIImageJPEGRepresentation(image, 1.0) length]);
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    //QLLog(@"~~~~1~~~~%@", @(data.length));
    while (data.length > 1024*1024 * (1/2.0)) {
        UIImage *imgNew = [UIImage imageWithData:data];
        data = UIImageJPEGRepresentation(imgNew, 0.4);
        //QLLog(@"~~~~2~~~~%@", @(data.length));
    }
    
    /** 测试最终的图片
     NSString *strFileName = [NSString stringWithFormat:@"Test_%i.jpeg", arc4random_uniform(100000)];
     NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:strFileName];
     [data writeToFile:strPath atomically:YES];
     */
    
    return data;
}

#pragma mark - NEW
/**
 *  @brief 检查一个图片是否含有颜色通道
 *
 *  @return 返回是否含有颜色通道,如果含有颜色通道返回YES,否则返回NO
 */
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/**
 *  @brief 给图片对象添加颜色通道
 *
 *  @return 一个带有颜色通道的UIImage图片对象
 */
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    CGImageRef imageRef =self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0,0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    return imageWithAlpha;
}

/**
 *  @brief 给UIImage对象添加一个透明边框, 如果该UIImage对象没有透明层(alpha layer),将会给该UIImage对象添加一个透明层(透明边框添加在原宽高的外侧)
 *
 *  @param borderSize 透明层的宽度
 *
 *  @return 返回一个带有borderSize宽度的透明边框
 */
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    UIImage *image = [self imageWithAlpha];
    CGRect newRect = CGRectMake(0,0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation,self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    // Clean up    
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    return transparentBorderImage;
}


#pragma mark -

#pragma mark Private helper methods
// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0,0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize *2, size.height - borderSize * 2));
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    return maskImageRef;
}

@end

//ImageType image_type(const char* path)
//{
//    ifstream inFile(path);
//    uchar png_type[9] = {0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,'/0'};
//    uchar file_head[9];
//    for (int i=0;i<8;++i)
//    {
//        inFile>>file_head[i];
//    }
//    file_head[8] = '/0';
//    switch (file_head[0])
//    {
//        case 0xff:
//            if (file_head[1]==0xd8)
//                return jpg;//jpeg
//        case 0x42:
//            if (file_head[1]==0x4D)
//                return bmp;//bmp
//        case 0x89:
//            if (file_head[1]==png_type[1] && file_head[2]==png_type[2] && file_head[3]==png_type[3] && file_head[4]==png_type[4]&&
//                file_head[5]==png_type[5] && file_head[6]==png_type[6] && file_head[7]==png_type[7])
//                return png;//png
//        default:
//            return nothing;
//    }
//}
