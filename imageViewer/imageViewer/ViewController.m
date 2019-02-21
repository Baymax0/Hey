//
//  ViewController.m
//  imageViewer
//
//  Created by Baymax on 17/9/19.
//  Copyright © 2017年 Baymax. All rights reserved.
//

#import "ViewController.h"
#import "YLSwipeLockView.h"

#define PWD @"047"

@interface ViewController ()<YLSwipeLockViewDelegate>{
    //解锁密码
    NSString *savedPassword;
}
@property (nonatomic, strong) YLSwipeLockView *lockView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initPWD];

    self.hideNav = YES;

}

-(void)initPWD{
    //解锁密码
    savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
    if (!savedPassword) {
        savedPassword = PWD;
    }

    //手势解锁
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"手势解锁";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.frame = CGRectMake(20, 80, kMainScreenWidth - 40, 28);
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.maskBlurView addSubview:_titleLabel];

    _lockView = [[YLSwipeLockView alloc] initWithFrame:CGRectMake(30, 190, kMainScreenWidth - 60, kMainScreenWidth - 60)];
    self.lockView.delegate = self;
    [self.maskBlurView addSubview:_lockView];

    [self showMaskBlurView];
}

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password{
    if ([savedPassword isEqualToString:password]) {
        [self dismiss];
        return YLSwipeLockViewStateNormal;
    }else{
        _titleLabel.text = @"密码错误";

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _titleLabel.text = @"手势解锁";
        });

        return YLSwipeLockViewStateWarning;
    }
}

//解锁成功
-(void)dismiss{
    [self hideMaskBlurView];
    [_lockView removeFromSuperview];
//    [self performSegueWithIdentifier:@"show" sender:nil];
}

@end
