//
//  NavigationViewController.m
//  qyshow
//
//  Created by 李志伟 on 16/12/9.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import "NavigationViewController.h"
#import "BaseViewController.h"
#import "Utils.h"
@interface NavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *img = [Utils imageWithColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBackgroundImage:img forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:img];
    self.interactivePopGestureRecognizer.delegate = self;
}

// 重写这个方法目的：能够拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        /* 设置返回按钮 */
        viewController.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"back-blue" text:@"  " color:nil];
    }
    [super pushViewController:viewController animated:animated];
}

//返回按钮事件
- (void)back{
    BaseViewController *vc = self.childViewControllers.lastObject;
    [vc popViewController];
}

//返回按钮
-(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text color:(UIColor*)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    if (color) {
        btn.tintColor = color;
    }

    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    // 设置尺寸
    CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}]; //文本尺寸
    CGSize imageSize = [UIImage imageNamed:image].size;   //图片尺寸
    btn.frame = CGRectMake(0,0,imageSize.width+titleSize.width+10,44);

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

//侧滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

//状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
