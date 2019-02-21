//
//  AlertView.m
//  qyshow
//
//  Created by 李志伟 on 16/12/29.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import "AlertView.h"
#import <objc/runtime.h>
#define kMainScreenWidthAlertView    [UIScreen mainScreen].bounds.size.width
#define KRatioAlertView  (kMainScreenWidthAlertView/414>1?1:kMainScreenWidthAlertView/414)
@implementation AlertView

//删除提醒
+(void)showDeleteAlertIn:(UIViewController*)vc
                   title:(NSString *)title
                 message:(NSString *)message
                   block:(AlertClickBlock)block{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

//输入框
+(void)showInputAlertIn:(UIViewController*)vc
                  title:(NSString*)title
            placeholder:(NSString *)placeholder
                  block:(InputClickBlock)block{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeholder;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputTF = alertController.textFields.firstObject;
        if (block) {
            block(inputTF.text);
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [vc presentViewController:alertController animated:YES completion:nil];
}

//输入框
+(void)showNumberInputAlertIn:(UIViewController*)vc
                  title:(NSString*)title
            placeholder:(NSString *)placeholder
                  block:(InputClickBlock)block{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeholder;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputTF = alertController.textFields.firstObject;
        if (block) {
            block(inputTF.text);
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [vc presentViewController:alertController animated:YES completion:nil];
}

//确认框
+(void)showConfirmAlertIn:(UIViewController*)vc
                    title:(NSString*)title
                   detail:(NSString*)detail
                    block:(AlertClickBlock)block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [vc presentViewController:alertController animated:YES completion:nil];
}

+(void)showConfirmAlertIn:(UIViewController*)vc
                    title:(NSString*)title
                   detail:(NSString*)detail
                    block:(AlertClickBlock)block
                   cancel:(AlertClickBlock)cancel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [vc presentViewController:alertController animated:YES completion:nil];
}

/**
 反馈提交成功提示框
 */
+(void)showContractSuccessAlertIn:(UIViewController*)vc{
    NSString *title = @"提交成功";
    NSString *message = @"\n";

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    //修改title
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(251)/255.0 green:(30)/255.0 blue:(29)/255.0 alpha:1],NSFontAttributeName:[UIFont boldSystemFontOfSize:22*KRatioAlertView]}];
            [alertController setValue:attr forKey:@"attributedTitle"];
        }
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:1],NSFontAttributeName:[UIFont boldSystemFontOfSize:16*KRatioAlertView]}];
            [alertController setValue:attr forKey:@"attributedMessage"];
        }
    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];

    [vc presentViewController:alertController animated:YES completion:nil];
}


+(UIAlertController *)payWaitViewIn:(UIViewController*)vc
                              title:(NSString*)title
                             detail:(NSString*)detail
                              block:(AlertClickBlock)block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"已完成支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [vc presentViewController:alertController animated:YES completion:nil];

    return alertController;
}


@end
