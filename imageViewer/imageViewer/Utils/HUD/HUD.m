//
//  HUD.m
//  qyshow
//
//  Created by 李志伟 on 16/12/14.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import "HUD.h"
#import "MBProgressHUD.h"
#define HIDETIME 1.0

static MBProgressHUD *hud;
@implementation HUD

+(MBProgressHUD*)HUDInView:(UIView*)view{
    if (hud) {
        [hud removeFromSuperview];
        hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.opaque = YES;//半透明
    hud.contentColor = KWhite;
    hud.bezelView.color = KBlack;
    return hud;
}

+(NSInteger)hideTime{
    return HIDETIME;
}

+(void)hide:(BOOL)animation{
    if (hud) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:animation];
        });
    }
}

+(void)showIn:(UIView*)view title:(NSString*)title{
    if (!title) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self HUDInView:view];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        [hud hideAnimated:YES afterDelay:HIDETIME];
    });
}

+(void)showWaitIn:(UIView*)view{
    if (!view) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self HUDInView:view];
    });
}

+(void)showWaitIn:(UIView*)view title:(NSString*)title{
    if (!title) {
        return;
    }
    if (!view) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self HUDInView:view];
        hud.label.text = title;
    });
}



+(void)showSuccessIn:(UIView*)view title:(NSString*)title{
    if (!title) {
        return;
    }
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self HUDInView:view];
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tintColor = [UIColor whiteColor];
        hud.customView =  imageView;
        hud.label.text = title;
        [hud hideAnimated:YES afterDelay:HIDETIME];
    });
}

//显示进度
+(void)showProgress{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self HUDInView:window];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    return hud;
}

//设置进度
+(void)setPrograss:(float)progress{
    if (hud&&(hud.mode==MBProgressHUDModeAnnularDeterminate||hud.mode==MBProgressHUDModeDeterminateHorizontalBar||hud.mode==MBProgressHUDModeDeterminate)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    }
}


+(void)showWaitWithBlankBGViewIn:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hud) {
            [hud removeFromSuperview];
            hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
        }else{
            hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        }
        hud.opaque = YES;//半透明
        hud.label.text = @"正在初始化";
        hud.contentColor = KWhite;
        hud.bezelView.color = KBlack;
        hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    });
}


#pragma mark - == 在window上显示(view 替换为 window) ==

/**
 * 显示文字
 */
+(void)showTitle:(NSString*)title{
    if (!title) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [HUD showIn:window title:title];
}

+(void)showWait{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showWaitIn:window];
}

+(void)showWaitWithTitle:(NSString*)title{
    if (!title) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showWaitIn:window title:title];
}

+(void)showSuccessTitle:(NSString*)title{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showSuccessIn:window title:title];
}

@end


