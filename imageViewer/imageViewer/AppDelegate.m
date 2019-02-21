//
//  AppDelegate.m
//  imageViewer
//
//  Created by Baymax on 17/9/19.
//  Copyright © 2017年 Baymax. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "YLSwipeLockView.h"

//  0 1 2
//  3 4 5
//  6 7 8

//解锁密码
#define PWD @"036"
//解锁密码
#define PWD2 @"367"

@interface AppDelegate ()<YLSwipeLockViewDelegate>

@property (nonatomic, strong) YLSwipeLockView *lockView;
@property(nonatomic, strong) UIButton * maskBlurView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] ignoreSnapshotOnNextApplicationLaunch];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainVC * rootVC = [[MainVC alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

    [self initPWD];
    [self showPWD];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self showPWD];
}




- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {


}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initPWD{
    self.maskBlurView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.maskBlurView setImage:[UIImage imageNamed:@"手势壁纸"] forState:UIControlStateNormal];
    [self.maskBlurView setImage:[UIImage imageNamed:@"手势壁纸"] forState:UIControlStateHighlighted];

    //手势解锁
    _lockView = [[YLSwipeLockView alloc] initWithFrame:CGRectMake(50, 360, kMainScreenWidth - 100, kMainScreenWidth - 100)];
    self.lockView.delegate = self;
    [self.maskBlurView addSubview:_lockView];
}

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password{
    if ([password isEqualToString:PWD]) {
        //解锁成功
        [self hidePWD];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_SafeLogin object:nil userInfo:nil];
        return YLSwipeLockViewStateNormal;
    }else if ([password isEqualToString:PWD2]) {
        //解锁成功
        [self hidePWD];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_UnSafeLogin object:nil userInfo:nil];
        return YLSwipeLockViewStateNormal;
    }else{
        return YLSwipeLockViewStateWarning;
    }
}
-(void)showPWD{
    if (!_maskBlurView.superview) {
        _maskBlurView.alpha = 0;
        [_window addSubview:_maskBlurView];
        [UIView animateWithDuration:0.2 animations:^{
            _maskBlurView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }else{

    }
}

-(void)hidePWD{
    [UIView animateWithDuration:0.4 animations:^{
        _maskBlurView.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskBlurView removeFromSuperview];

    }];
}



@end
