//
//  VideoPlayVC.m
//  imageViewer
//
//  Created by lzw on 2018/8/17.
//  Copyright © 2018 Baymax. All rights reserved.
//

#import "VideoPlayVC.h"
#import "SJVideoPlayer.h"
#import <SJUIFactory/SJUIFactory.h>
#import <Masonry.h>

@interface VideoPlayVC ()
@property (nonatomic, strong) SJVideoPlayer *videoPlayer;
@end

@implementation VideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _videoPlayer = [SJVideoPlayer lightweightPlayer];
    [self.view addSubview:_videoPlayer.view];
    [_videoPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_videoPlayer.view.mas_width).multipliedBy(1);
    }];

    __weak typeof(self) _self = self;
    _videoPlayer.clickedBackEvent = ^(SJVideoPlayer * _Nonnull player) {
        [_self dismissViewControllerAnimated:YES completion:nil];
    };

    // 播放
    self->_videoPlayer.assetURL = _videoURL;

    // supported orientation . 设置旋转支持的方向.
    _videoPlayer.supportedOrientation = SJAutoRotateSupportedOrientation_LandscapeLeft | SJAutoRotateSupportedOrientation_LandscapeRight;

    // 将播放器旋转成横屏.(播放器默认是竖屏的), 带动画
    _videoPlayer.orientation = SJOrientation_LandscapeLeft; // 请注意: 是`SJOrientation_LandscapeLeft` 而不是 `SJAutoRotateSupportedOrientation_LandscapeLeft`

    // 将播放器旋转成横屏.(播放器默认是竖屏的), 不带动画
    //    [_videoPlayer rotate:SJOrientation_LandscapeLeft animated:NO];


    _videoPlayer.controlLayerAppearStateChanged = ^(__kindof SJBaseVideoPlayer * _Nonnull player, BOOL state) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    };

    _videoPlayer.viewWillRotateExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player, BOOL isFullScreen) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_videoPlayer pause];
    /// 还原状态栏的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return _videoPlayer.isFullScreen && !_videoPlayer.controlLayerAppeared;
}

@end
