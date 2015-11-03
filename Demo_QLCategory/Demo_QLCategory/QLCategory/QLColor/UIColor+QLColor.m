//
//  UIColor+QLColor.m
//  Demo_QLCategory
//
//  Created by Shrek on 15/1/30.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "UIColor+QLColor.h"

@implementation UIColor (QLColor)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {    
    NSString *strTemp = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([strTemp length] < 6) {
        return [UIColor whiteColor];
    } else if ([strTemp length] != 6) {
        return [UIColor whiteColor];        
    }
    if ([strTemp hasPrefix:@"0X"]) {
        strTemp = [strTemp substringFromIndex:2];
    } else if ([strTemp hasPrefix:@"#"]) {        
        strTemp = [strTemp substringFromIndex:1];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [strTemp substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [strTemp substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [strTemp substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:1.0f];
}

+ (NSString *)hexFromUIColor:(UIColor*)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0), (int)((CGColorGetComponents(color.CGColor))[1]*255.0), (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)colorFromPoint:(CGPoint)point InView:(__kindof UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    CGImageRef imgRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    UIColor* color = nil;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:imgRef];
    if (cgctx == NULL) {
        return nil;
    }
    
    size_t w = CGImageGetWidth(imgRef);
    size_t h = CGImageGetHeight(imgRef);
    CGRect rect = {{0, 0}, {w, h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, imgRef);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char *data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            #ifdef DEBUG
            NSLog(@"%@",[e reason]);
            #endif
        }
        @finally {
        }        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) {
        free(data);
    }
    
    return color;
}

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)imgRef {    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    NSUInteger bitmapByteCount;
    NSUInteger bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(imgRef);
    size_t pixelsHigh = CGImageGetHeight(imgRef);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL) {
        #ifdef DEBUG
        fprintf(stderr, "Error allocating color space\n");
        #endif
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        #ifdef DEBUG
        fprintf (stderr, "Memory not allocated!");
        #endif
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        #ifdef DEBUG
        fprintf (stderr, "Context not created!");
        #endif
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@end
