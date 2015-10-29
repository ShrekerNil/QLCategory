//
//  UIDevice+QLDevice.m
//  Demo_QLCategory
//
//  Created by Shrek on 15/7/30.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "UIDevice+QLDevice.h"

@implementation UIDevice (QLDevice)

- (BOOL)hasJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

@end
