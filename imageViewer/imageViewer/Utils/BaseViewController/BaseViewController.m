//
//  BaseViewController.m
//  qyshow
//
//  Created by 李志伟 on 16/12/7.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import "BaseViewController.h"

static BaseViewController* CURRENT_FIRST_VC;

@interface BaseViewController (){

}

@end

@implementation BaseViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    _hideNav = NO;//默认显示导航栏
    _tintColor = KWhite;
    _barTintColor = KBlue;
    self.stateStyle = UIStatusBarStyleLightContent;//状态栏
    _hideNavBottonLine = NO;//默认显示导航栏横线
    _canSlideBack = YES;

    //导航栏不透明
    self.navigationController.navigationBar.translucent = NO;

    //隐藏tabbar
    NSArray *arr = self.navigationController.childViewControllers;
    if (arr&&arr.count>1) {
        self.hidesBottomBarWhenPushed = YES;
        _tintColor = KBlack;
        _barTintColor = KWhite;
    }
    _appearTimes = 0;
    self.cacheKey = NSStringFromClass([self class]);

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CURRENT_FIRST_VC = self;
    self.appearTimes++;

    self.navigationController.interactivePopGestureRecognizer.enabled = _canSlideBack;


    [self.navigationController setNavigationBarHidden:_hideNav animated:animated];

    if (_hideNav == NO) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:_tintColor forKey:NSForegroundColorAttributeName];
        self.navigationController.navigationBar.titleTextAttributes = dict;

        [self.navigationController.navigationBar setTintColor:_tintColor];
        self.navigationController.navigationBar.barTintColor = _barTintColor;
    }
    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    if (!self.navigationItem.rightBarButtonItem&&_rightBarBtnTitle) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_rightBarBtnTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnAction)];
        self.navigationItem.rightBarButtonItem.tintColor = _tintColor;
    }
    if (!self.navigationItem.rightBarButtonItem&&_rightBarBtnImage) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:_rightBarBtnImage] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnAction)];
        self.navigationItem.rightBarButtonItem = btn;
    }

    if (_hideNavBottonLine) {
        //隐藏横线
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        for (UIView *view in backgroundView.subviews) {
            if (CGRectGetHeight([view frame]) <= 1) {
                view.hidden = YES;
            }
        }
    }else{
        //隐藏横线
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        for (UIView *view in backgroundView.subviews) {
            if (CGRectGetHeight([view frame]) <= 1) {
                view.hidden = NO;
            }
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (_hideNav == NO) {
        if (CGColorEqualToColor( _barTintColor.CGColor, KWhite.CGColor)) {
            return UIStatusBarStyleDefault;
        }else{
            return _stateStyle;
        }
    }else{
        return _stateStyle;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closeKeybord];
}

-(UIImageView *)navBottonLineView{
    if (!_navBottonLineView) {
        _navBottonLineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    }
    return _navBottonLineView;
}

//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)setStateStyle:(UIStatusBarStyle)stateStyle{
    _stateStyle = stateStyle;
    [self setNeedsStatusBarAppearanceUpdate];
//    [[UIApplication sharedApplication] setStatusBarStyle:_stateStyle animated:YES];
}

//返回按钮
-(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text color:(UIColor*)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (!image && !text) {//使用默认的
        image = @"back-template";
        if (!color) {
            color = KBlue;
        }
        btn.tintColor = color;
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        btn.tintColor = color;
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }
    // 设置图片
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    if (color) {
        btn.tintColor = color;
    }

    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    // 设置尺寸
    CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}]; //文本尺寸
    CGSize imageSize = [UIImage imageNamed:image].size;   //图片尺寸
    btn.frame = CGRectMake(0,0,imageSize.width+titleSize.width+10,imageSize.height);
//    [btn addTarget:self action:@selector(leftBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(UIView *)maskBlurView{
    if (!_maskBlurView) {
        _maskBlurView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _maskBlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_maskBlurView addTarget:self action:@selector(maskViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBlurView;
}

-(void)showMaskBlurView{
    [[Utils keyWindow] addSubview:self.maskBlurView];
    self.maskBlurView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBlurView.alpha = 1;
    }];
}

-(void)hideMaskBlurView{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBlurView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskBlurView removeFromSuperview];
    }];
}

-(void)maskViewAction{

}


-(void)popViewController{
    self.dismissType = BMVCDismissType_pop;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pushViewController:(BaseViewController*)vc animated:(BOOL)animated{
    self.dismissType = BMVCDismissType_push;
    CURRENT_FIRST_VC = vc;
    [self.navigationController pushViewController:vc animated:animated];
}

-(void)rightBarBtnAction{

}

-(void)leftBarBtnAction{

}


-(void)closeKeybord{
    [self.view endEditing:YES];
}

-(void)dealloc{
    [self VCDelloc];
}

-(void)VCDelloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(BaseViewController*)currentVC{
    return CURRENT_FIRST_VC;
}

@end
