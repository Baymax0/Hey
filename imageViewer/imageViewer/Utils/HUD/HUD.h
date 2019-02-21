//
//  HUD.h
//  qyshow
//
//  Created by 李志伟 on 16/12/14.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUD : NSObject

+(NSInteger)hideTime;

#pragma mark - == view内显示 ==
/**
 * 显示文字
 */
+(void)showIn:(UIView*)view title:(NSString*)title;
/**
 * 显示等待
 */
+(void)showWaitIn:(UIView*)view;

/**
 * 显示等待+文字
 */
+(void)showWaitIn:(UIView*)view title:(NSString*)title;
/**
 * 显示打钩
 */
+(void)showSuccessIn:(UIView*)view title:(NSString*)title;
/**
 * 隐藏
 */
+(void)hide:(BOOL)animation;

/**
 * 显示进度
 */
+(void)showProgress;
/**
 * 设置当前进度（0~1）
 */
+(void)setPrograss:(float)progress;


+(void)showWaitWithBlankBGViewIn:(UIView *)view;

#pragma mark - == 在window上显示 ==
/**
 * 显示文字
 */
+(void)showTitle:(NSString*)title;

+(void)showWait;

+(void)showWaitWithTitle:(NSString*)title;

+(void)showSuccessTitle:(NSString*)title;

@end
