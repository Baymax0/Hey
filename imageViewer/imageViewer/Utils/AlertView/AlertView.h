//
//  AlertView.h
//  qyshow
//
//  Created by 李志伟 on 16/12/29.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//输入框回调
typedef void (^InputClickBlock)(NSString* inputText);
//普通提示框 点击确认后回调
typedef void (^AlertClickBlock)(void);

@interface AlertView : NSObject

/**
 输入框
 */
+(void)showInputAlertIn:(UIViewController*)vc
                  title:(NSString*)title
            placeholder:(NSString *)placeholder
                  block:(InputClickBlock)block;

/**
 数字输入框
 */
+(void)showNumberInputAlertIn:(UIViewController*)vc
                  title:(NSString*)title
            placeholder:(NSString *)placeholder
                  block:(InputClickBlock)block;

/**
 删除提醒
 */
+(void)showDeleteAlertIn:(UIViewController*)vc
                   title:(NSString *)title
                 message:(NSString *)message
                   block:(AlertClickBlock)block;
/**
 确认框
 */
+(void)showConfirmAlertIn:(UIViewController*)vc
                    title:(NSString*)title
                   detail:(NSString*)detail
                    block:(AlertClickBlock)block;

+(void)showConfirmAlertIn:(UIViewController*)vc
                    title:(NSString*)title
                   detail:(NSString*)detail
                    block:(AlertClickBlock)block
                   cancel:(AlertClickBlock)cancel;
/**
 反馈提交成功提示框
 */
+(void)showContractSuccessAlertIn:(UIViewController*)vc;


+(UIAlertController *)payWaitViewIn:(UIViewController*)vc
                              title:(NSString*)title
                             detail:(NSString*)detail
                              block:(AlertClickBlock)block;

@end
