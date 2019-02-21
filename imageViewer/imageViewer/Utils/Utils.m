//
//  Utils.m
//  general
//
//  Created by 李志伟 on 17/3/29.
//  Copyright © 2017年 baymax0. All rights reserved.
//

#import "Utils.h"

#define KCache_RowNum @"KCache_RowNum"

static Utils * util;

@interface Utils()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end


@implementation Utils
#pragma mark ------- setting 带缓存 -------

+(NSInteger)rowNumIndex{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [defaults objectForKey:KCache_RowNum];
    if (!num) {
        [self setRowNumIndex:0];
        return 0;
    }
    return num.intValue;
}
//设置单行个数
+(void)setRowNumIndex:(NSInteger)index{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(index) forKey:KCache_RowNum];
    [defaults synchronize];
}




#pragma mark ------- File -------
+ (BOOL)isDirectory:(NSString *)filePath{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

+ (BOOL)isVideoFile:(NSString *)filePath{
    if ([filePath containsString:@".mp4"]) {
        return YES;
    }
    if ([filePath containsString:@".mov"]) {
        return YES;
    }
    if ([filePath containsString:@".avi"]) {
        return YES;
    }
    if ([filePath containsString:@".flv"]) {
        return YES;
    }
    if ([filePath containsString:@".mkv"]) {
        return YES;
    }
    if ([filePath containsString:@".rmvb"]) {
        return YES;
    }
    return NO;
}

#pragma mark ------- RGB十六进制颜色 -------
+(UIColor *)getColor:(NSString *)hexColor{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;

    if (hexColor.length>6) {
        hexColor = [hexColor substringFromIndex:hexColor.length-6];
    }

    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}

//[0~i）的随机数
+(int)getRandomInt:(int)i{
    return arc4random() % i;
}


#pragma mark ----------  工具方法 ----------
+(UIWindow*)keyWindow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    return keyWindow;
}

@end
