//
//  Utils.h
//  general
//
//  Created by 李志伟 on 17/3/29.
//  Copyright © 2017年 baymax0. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Utils : NSObject
#pragma mark ------- setting 带缓存 -------

+(NSInteger)rowNumIndex;

+(void)setRowNumIndex:(NSInteger)index;


#pragma mark ------- File -------
//是否是文件夹
+ (BOOL)isDirectory:(NSString *)filePath;

+ (BOOL)isVideoFile:(NSString *)filePath;

#pragma mark ------- RGB十六进制颜色 -------
+ (UIColor *)getColor:(NSString *)hexColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

#pragma mark ----------  工具方法 ----------
+(UIWindow*)keyWindow;


@end
