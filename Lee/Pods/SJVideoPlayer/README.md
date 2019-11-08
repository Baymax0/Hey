![readme](https://user-images.githubusercontent.com/37614260/43947531-922a0712-9cb2-11e8-8f8d-4823a21308d3.png)

[![Build Status](https://travis-ci.org/changsanjiang/SJVideoPlayer.svg?branch=master)](https://travis-ci.org/changsanjiang/SJVideoPlayer)
[![Version](https://img.shields.io/cocoapods/v/SJVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/SJVideoPlayer)
[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://github.com/changsanjiang)
[![License](https://img.shields.io/github/license/changsanjiang/SJVideoPlayer.svg)](https://github.com/changsanjiang/SJVideoPlayer/blob/master/LICENSE.md)

## Installation
```ruby
# Player with default control layer.
pod 'SJVideoPlayer'

# The base player, without the control layer, can be used if you need a custom control layer.
pod 'SJBaseVideoPlayer'
```

## 天朝
```ruby
# 如果网络不行安装不了, 可改成以下方式进行安装
pod 'SJBaseVideoPlayer', :git => 'https://gitee.com/changsanjiang/SJBaseVideoPlayer.git'
pod 'SJVideoPlayer', :git => 'https://gitee.com/changsanjiang/SJVideoPlayer.git'
pod 'SJUIKit/AttributesFactory', :git => 'https://gitee.com/changsanjiang/SJUIKit.git'
pod 'SJUIKit/ObserverHelper', :git => 'https://gitee.com/changsanjiang/SJUIKit.git'
pod 'SJUIKit/Queues', :git => 'https://gitee.com/changsanjiang/SJUIKit.git'
$ pod update --no-repo-update   (不要用 pod install 了, 用这个命令安装)
```

## Example

```Objective-C
_player = [SJVideoPlayer player];
_player.view.frame = CGRectMake(0, 0, 200, 200);
[self.view addSubview:_player.view];

// 设置资源进行播放
_player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL];

... 等等, 更多设置, 请查看头文件. 相应功能均为懒加载, 用到时才会创建. 
```

## Author

Email: changsanjiang@gmail.com
QQGroup: 930508201 (iOS 开发)

## Documents

#### [1. 视图层次结构](#1)
* [1.1 UIView](#1.1)
* [1.2 UITableView 中的层次结构](#1.2)
    * [1.2.1 UITableViewCell](#1.2.1)
    * [1.2.2 UITableView.tableHeaderView](#1.2.2)
    * [1.2.3 UITableView.tableFooterView](#1.2.3)
    * [1.2.4 UITableViewHeaderFooterView](#1.2.4)
* [1.3 UICollectionView 中的层次结构](#1.3)
    * [1.3.1 UICollectionViewCell](#1.3.1)
* [1.4  嵌套时的层次结构](#1.4)
    * [1.4.1 UICollectionView 嵌套在 UITableViewCell 中](#1.4.1)
    * [1.4.2 UICollectionView 嵌套在 UITableViewHeaderView 中](#1.4.2)
    * [1.4.3 UICollectionView 嵌套在 UICollectionViewCell 中](#1.4.3)

#### [2. URLAsset](#2)
* [2.1 播放 URL(本地文件或远程资源)](#2.1)
* [2.2 播放 AVAsset 或其子类](#2.2)
* [2.3 从指定的位置开始播放](#2.3)
* [2.4 续播(进入下个页面时, 继续播放)](#2.4)
* [2.5 销毁时的回调. 可在此做一些记录工作, 如播放记录](#2.5)

#### [3. 播放控制](#3)
* [3.1 播放](#3.1)
* [3.2 暂停](#3.2)
* [3.3 刷新 ](#3.3)
* [3.4 重播](#3.4)
* [3.5 停止](#3.5)
* [3.6 静音](#3.6)
* [3.7 调速](#3.7)
* [3.8 报错](#3.8)
* [3.9 跳转](#3.9)
* [3.10 切换清晰度](#3.10)
* [3.11 当前时间](#3.11)
* [3.12 总时长](#3.12)
* [3.13 缓冲时长](#3.13)
* [3.14 是否已播放完毕](#3.14)
* [3.15 是否调用过播放](#3.15)
* [3.16 是否调用过重播](#3.16)
* [3.17 设置新资源时, 是否自动播放](#3.17)
* [3.18 进入后台, 是否暂停播放](#3.18)
* [3.19 进入前台, 是否恢复播放](#3.19)
* [3.20 跳转完成, 是否恢复播放](#3.20)
* [3.21 资源准备状态](#3.21)
* [3.22 播放控制状态](#3.22)
* [3.23 播放等待的原因](#3.23)
* [3.24 监听状态改变🔥](#3.24)
* [3.25 已观看的时长(当前资源)](#3.25)
* [3.26 接入别的视频 SDK, 自己动手撸一个 SJVideoPlayerPlaybackController, 替换作者原始实现](#3.26)

#### [4. 控制层的显示和隐藏](#4)
* [4.1 让控制层显示](#4.1)
* [4.2 让控制层隐藏](#4.2)
* [4.3 控制层是否显示中](#4.3)
* [4.4 是否在暂停时保持控制层显示](#4.4)
* [4.5 监听状态改变🔥](#4.5)
* [4.6 自己动手撸一个 SJControlLayerAppearManager, 替换作者原始实现](#4.6)

#### [5. 设备亮度和音量](#5)
* [5.1 调整设备亮度](#5.1)
* [5.2 调整设备声音](#5.2)
* [5.3 监听状态改变🔥](#5.3)
* [5.4 禁止播放器设置](#5.4)
* [5.5 自己动手撸一个 SJDeviceVolumeAndBrightnessManager, 替换作者原始实现](#5.5)

#### [6. 旋转](#6)
* [6.1 自动旋转](#6.1)
* [6.2 设置自动旋转支持的方向](#6.2)
* [6.3 禁止自动旋转](#6.3)
* [6.4 主动调用旋转](#6.4)
* [6.5 是否全屏](#6.5)
* [6.6 是否正在旋转](#6.6)
* [6.7 当前旋转的方向 ](#6.7)
* [6.8 监听状态改变🔥](#6.8) 
* [6.9 自己动手撸一个 SJRotationManager, 替换作者原始实现](#6.9)

#### [7. 直接全屏而不旋转](#7)
* [7.1 全屏和恢复](#7.1)
* [7.2 监听状态改变🔥](#7.2)
* [7.3 是否是全屏](#7.3)
* [7.4 自己动手撸一个 SJFitOnScreenManager, 替换作者原始实现](#7.4)

#### [8. 镜像翻转](#8)
* [8.1 翻转和恢复](#8.1)
* [8.2 监听状态改变🔥](#8.2)
* [8.3  自己动手撸一个 SJFlipTransitionManager, 替换作者原始实现](#8.3)

#### [9. 网络状态](#9)
* [9.1 当前的网络状态](#9.1)
* [9.2 监听状态改变🔥](#9.2)
* [9.3 自己动手撸一个 SJReachability, 替换作者原始实现](#9.3)

#### [10. 手势](#10)
* [10.1 单击手势](#10.1)
* [10.2 双击手势](#10.2)
* [10.3 移动手势](#10.3)
* [10.4 捏合手势](#10.4)
* [10.5 设置支持的手势](#10.5)
* [10.6 自定义某个手势的处理](#10.6)

#### [11. 占位图](#11)
* [11.1 设置本地占位图](#11.1)
* [11.2 设置网络占位图](#11.2)
* [11.3 是否隐藏占位图 - 播放器准备好显示时](#11.3)

#### [12. 显示提示文本](#12)
* [12.1 显示管理类](#12.1)
* [12.2 配置提示文本](#12.2)

#### [13. 一些固定代码](#13)
* [13.1 - (void)vc_viewDidAppear; ](#13.1)
* [13.2 - (void)vc_viewWillDisappear;](#13.2)
* [13.3 - (void)vc_viewDidDisappear;](#13.3)
* [13.4 - (BOOL)vc_prefersStatusBarHidden;](#13.4)
* [13.5 - (UIStatusBarStyle)vc_preferredStatusBarStyle;](#13.5)
* [13.6 - 临时显示状态栏](#13.6)
* [13.7 - 临时隐藏状态栏](#13.7)

#### [14. 截屏](#14)
* [14.1 当前时间截图](#14.1)
* [14.2 指定时间截图](#14.2)

#### [15. 导出视频或GIF](#15)
* [15.1 导出视频](#15.1)
* [15.2 导出GIF](#15.2)
* [15.3 取消操作](#15.3)

#### [16. 滚动相关](#16)
* [16.1 是否在 UICollectionView 或者 UITableView 中播放](#16.1)
* [16.2 是否已显示](#16.2)
* [16.3 播放器视图将要滚动显示和消失的回调](#16.3)
* [16.4 滚动出去后, 是否暂停](#16.4)
* [16.5 滚动进入时, 是否恢复播放](#16.5)
* [16.6 滚动出去后, 是否隐藏播放器视图](#16.6)

#### [17. 自动播放 - 在 UICollectionView 或者 UITableView 中](#17)
* [17.1 开启](#17.1)
* [17.2 配置](#17.2)
* [17.3 关闭](#17.3)
* [17.4 主动调用播放下一个资源](#17.4)

#### [18. 对控制层上的Item的操作](#18)
* [18.1 添加](#18.1)
* [18.2 删除](#18.2)
* [18.3 调整位置](#18.3)

#### [19. 对控制层上的Item的一些补充](#19)
* [19.1 设置与前后item的间距](#19.1)
* [19.2 设置隐藏](#19.2)
* [19.3 填充剩余空间](#19.3)

#### [20. SJEdgeControlLayer 的补充](#20)
* [20.1 是否竖屏时隐藏返回按钮](#20.1)
* [20.2 是否禁止网络状态变化提示](#20.2)
* [20.3 是否使返回按钮常驻](#20.3)
* [20.4 是否隐藏底部进度条](#20.4)
* [20.5 是否在loadingView上显示网速](#20.5)
* [20.6 自定义loadingView](#20.6)
* [20.7 调整边距](#20.7)
* [20.8 取消控制层上下视图的阴影](#20.8)

___


## 以下为详细介绍: 


<h2 id="1.1">1.1 UIView</h3>  

```Objective-C
_player = [SJVideoPlayer player];
_player.view.frame = ...;
[self.view addSubview:_player.view];

// 设置资源进行播放
SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL];
_player.URLAsset = asset;
```

<p>

在普通视图中播放时, 不需要指定视图层次, 直接创建资源进行播放即可.  

</p>

___

<h2 id="1.2">1.2 UITableView 中的层次结构</h3>

<p>

由于 UITableView 及 UICollectionView 的复用机制, 会导致播放器视图显示在错误的位置上, 为防止出现此种情况, 在创建资源时指定视图层次结构, 使得播放器能够定位具体的父视图, 依此来控制隐藏与显示. 

</p>

___


<h3 id="1.2.1">1.2.1 UITableViewCell</h3>

```Objective-C
--  UITableView
--  UITableViewCell
--  Player.superview
--  Player.view


_player = [SJVideoPlayer player];

UIView *playerSuperview = cell.coverImageView;
SJPlayModel *playModel = [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:playerSuperview.tag atIndexPath:indexPath tableView:self.tableView];

_player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL playModel:playModel];
```

<p>

在 UITableViewCell 中播放时, 需指定 Cell 所处的 indexPath 以及播放器父视图的 tag. 

在滑动时, 管理类将会通过这两个参数控制播放器父视图的显示与隐藏.

</p>

___


<h3 id="1.2.2">1.2.2 UITableView.tableHeaderView</h3>

```Objective-C
--  UITableView
--  UITableView.tableHeaderView 或者 UITableView.tableFooterView  
--  Player.superview
--  Player.view

UIView *playerSuperview = self.tableView.tableHeaderView;
// 也可以设置子视图
// playerSuperview = self.tableView.tableHeaderView.coverImageView;
SJPlayModel *playModel = [SJPlayModel UITableViewHeaderViewPlayModelWithPlayerSuperview:playerSuperview tableView:self.tableView];
```

___


<h3 id="1.2.3">1.2.3 UITableView.tableFooterView</h3>

```Objective-C
--  UITableView
--  UITableView.tableHeaderView 或者 UITableView.tableFooterView  
--  Player.superview
--  Player.view

UIView *playerSuperview = self.tableView.tableFooterView;
// 也可以设置子视图
// playerSuperview = self.tableView.tableFooterView.coverImageView;
SJPlayModel *playModel = [SJPlayModel UITableViewHeaderViewPlayModelWithPlayerSuperview:playerSuperview tableView:self.tableView];
```

___


<h3 id="1.2.4">1.2.4 UITableViewHeaderFooterView</h3>

```Objective-C
--  UITableView
--  UITableViewHeaderFooterView 
--  Player.superview
--  Player.view            

/// isHeader: 当在header中播放时, 传YES, 在footer时, 传NO.
SJPlayModel *playModel = [SJPlayModel UITableViewHeaderFooterViewPlayModelWithPlayerSuperviewTag:sectionHeaderView.coverImageView.tag inSection:section isHeader:YES tableView:self.tableView];
```

___


<h2 id="1.3">1.3 UICollectionView 中的层次结构</h3>

<p>

在 UICollectionView 中播放时, 同 [UITableView](#1.2) 中一样, 需指定视图层次, 使得播放器能够定位具体的父视图, 依此来控制隐藏与显示.

</p>

___


<h3 id="1.3.1">1.3.1 UICollectionViewCell</h3>

```Objective-C
--  UICollectionView
--  UICollectionViewCell
--  Player.superview
--  Player.view

SJPlayModel *playModel = [SJPlayModel UICollectionViewCellPlayModelWithPlayerSuperviewTag:cell.coverImageView.tag atIndexPath:indexPath collectionView:self.collectionView];
```

___


<h2 id="1.4">1.4 嵌套时的视图层次</h3>

<p>

嵌套的情况下, 传递的参数比较多, 不过熟悉了前面的套路, 下面的这些也不成问题.  (会被复用的视图, 传 tag. 如果不会被复用, 则直接传视图)

</p>

___


<h3 id="1.4.1">1.4.1 UICollectionView 嵌套在 UITableViewCell 中</h3>

```Objective-C
--  UITableView
--  UITableViewCell
--  UITableViewCell.UICollectionView
--  UICollectionViewCell
--  Player.superview
--  Player.view

SJPlayModel *playModel = [SJPlayModel UICollectionViewNestedInUITableViewCellPlayModelWithPlayerSuperviewTag:collectionViewCell.coverImageView.tag atIndexPath:collectionViewCellAtIndexPath collectionViewTag:tableViewCell.collectionView.tag collectionViewAtIndexPath:tableViewCellAtIndexPath tableView:self.tableView];
```

___


<h3 id="1.4.2">1.4.2 UICollectionView 嵌套在 UITableViewHeaderView 中</h3>

```Objective-C
--  UITableView
--  UITableView.tableHeaderView 或者 UITableView.tableFooterView  
--  tableHeaderView.UICollectionView
--  UICollectionViewCell
--  Player.superview
--  Player.view

SJPlayModel *playModel = [SJPlayModel UICollectionViewNestedInUITableViewHeaderViewPlayModelWithPlayerSuperviewTag:cell.coverImageView.tag atIndexPath:indexPath collectionView:tableHeaderView.collectionView tableView:self.tableView];
```

___


<h3 id="1.4.3">1.4.3 UICollectionView 嵌套在 UICollectionViewCell 中</h3>

```Objective-C
--  UICollectionView
--  UICollectionViewCell
--  UICollectionViewCell.UICollectionView
--  UICollectionViewCell
--  Player.superview
--  Player.view

SJPlayModel *playModel = [SJPlayModel UICollectionViewNestedInUICollectionViewCellPlayModelWithPlayerSuperviewTag:collectionViewCell.coverImageView.tag atIndexPath:collectionViewCellAtIndexPath collectionViewTag:rootCollectionViewCell.collectionView.tag collectionViewAtIndexPath:collectionViewAtIndexPath rootCollectionView:self.collectionView];
```

___


<h2 id="2">2. URLAsset</h3>

<p>

播放器 播放的资源是通过 SJVideoPlayerURLAsset 创建的. SJVideoPlayerURLAsset 由两部分组成:

视图层次 (第一部分中的SJPlayModel)
资源地址 (可以是本地资源/URL/AVAsset)

默认情况下, 创建了 SJVideoPlayerURLAsset , 赋值给播放器后即可播放.

</p>

___

<h3 id="2.1">2.1 播放 URL(本地文件或远程资源)</h3>

```Objective-C
NSURL *URL = [NSURL URLWithString:@"https://...example.mp4"];
_player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL];
```

<h3 id="2.2">2.2 播放 AVAsset 或其子类</h3>

```Objective-C
_player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithAVAsset:avAsset];
```

<h3 id="2.3">2.3 从指定的位置开始播放</h3>

```Objective-C
NSTimeInterval secs = 20.0;
_player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL specifyStartTime:secs]; // 直接从20秒处开始播放
```

<h3 id="2.4">2.4 续播(进入下个页面时, 继续播放)</h3>

<p>

我们可能需要切换界面时, 希望视频能够在下一个界面无缝的进行播放. 使用如下方法, 传入正在播放的资源, 将新的资源赋值给播放器播放即可. 

</p>

```Objective-C
// otherAsset 即为上一个页面播放的Asset
// 除了需要一个otherAsset, 其他方面同以上的示例一模一样
_player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithOtherAsset:otherAsset]; 
```

<h3 id="2.5">2.5 销毁时的回调. 可在此做一些记录工作, 如播放记录</h3>

```Objective-C
// 每个资源dealloc时的回调
_player.assetDeallocExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
// .....
};
```

当资源销毁时, 播放器将会回调该 block. 

___


<h2 id="3">3. 播放控制</h2>

<p>
播放控制: 对播放进行的操作. 此部分的内容由 "id &lt;SJMediaPlaybackController&gt; playbackController" 提供支持.

大多数对播放进行的操作, 均在协议 SJMediaPlaybackController 进行了声明. 

正常来说实现了此协议的任何对象, 均可赋值给 player.playbackController 来替换原始实现.
</p>

<h3 id="3.1">3.1 播放</h3>

```Objective-C
[_player play];
```

<h3 id="3.2">3.2 暂停</h3>

```Objective-C
[_player pause];
```

<h3 id="3.3">3.3 刷新</h3>

<p>
在播放一个资源时, 可能有一些意外情况导致播放失败(如网络环境差). 

此时当用户点击刷新按钮, 我们需要对当前的资源(Asset)进行刷新. 

SJBaseVideoPlayer提供了直接的方法去刷新, 不需要开发者再重复的去创建新的Asset.
</p>

```Objective-C
[_player refresh];
```

<h3 id="3.4">3.4 重播</h3>

<p>
从头开始重新播放
</p>

```Objective-C
[_player replay];
```

<h3 id="3.5">3.5 停止</h3>

<p>
停止播放, 请注意: 当前资源将会被清空, 如需重播, 请重新设置新资源
</p>

```Objective-C
[_player stop];
```

<h3 id="3.6">3.6 静音</h3>

```Objective-C
_player.muted = YES;
```

<h3 id="3.7">3.7 调速</h3>

```Objective-C
// 默认值为 1.0
_player.rate = 1.0;
```

<h3 id="3.8">3.8 报错</h3>

<p>

当播放发生错误时, 可以通过它来获取错误信息

</p>

```Objective-C
_player.error
```

<h3 id="3.9">3.9 跳转</h3>

```Objective-C
///
/// 是否精确跳转, default value is NO.
///
@property (nonatomic) BOOL accurateSeeking;

///
/// 跳转到指定位置播放
///
- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
```

<h3 id="3.10">3.10 切换清晰度</h3>

```Objective-C
///
/// 切换清晰度
///
- (void)switchVideoDefinition:(SJVideoPlayerURLAsset *)URLAsset;

///
/// 当前清晰度切换的信息
///
@property (nonatomic, strong, readonly) SJVideoDefinitionSwitchingInfo *definitionSwitchingInfo;

/// 以下为设置 SJVideoPlayer.definitionURLAssets, 将会在清晰度切换控制层中显示这些资源项. 

SJVideoPlayerURLAsset *asset1 = [[SJVideoPlayerURLAsset alloc] initWithURL:VideoURL_Level4];
asset1.definition_fullName = @"超清 1080P";
asset1.definition_lastName = @"超清";

SJVideoPlayerURLAsset *asset2 = [[SJVideoPlayerURLAsset alloc] initWithURL:VideoURL_Level3];
asset2.definition_fullName = @"高清 720P";
asset2.definition_lastName = @"AAAAAAA";

SJVideoPlayerURLAsset *asset3 = [[SJVideoPlayerURLAsset alloc] initWithURL:VideoURL_Level2];
asset3.definition_fullName = @"清晰 480P";
asset3.definition_lastName = @"480P";
_player.definitionURLAssets = @[asset1, asset2, asset3];

// 先播放asset1. (asset2 和 asset3 将会在用户选择后进行切换)
_player.URLAsset = asset1;
```

<h3 id="3.11">3.11 当前时间</h3>

```Objective-C
@property (nonatomic, readonly) NSTimeInterval currentTime;                         ///< 当前播放到的时间
```

<h3 id="3.12">3.12 总时长</h3>

```Objective-C
@property (nonatomic, readonly) NSTimeInterval duration;                            ///< 总时长
```

<h3 id="3.13">3.13 缓冲时长</h3>

```Objective-C
@property (nonatomic, readonly) NSTimeInterval playableDuration;                    ///< 缓冲到的时间
```

<h3 id="3.14">3.14 是否已播放完毕</h3>

```Objective-C
@property (nonatomic, readonly) BOOL isPlayedToEndTime;                             ///< 当前资源是否已播放结束
```

<h3 id="3.15">3.15 是否调用过播放</h3>

```Objective-C
@property (nonatomic, readonly) BOOL isPlayed;                                      ///< 是否播放过当前的资源
```
<h3 id="3.16">3.16 是否调用过重播</h3>

```Objective-C
@property (nonatomic, readonly) BOOL isReplayed;                                    ///< 是否重播过当前的资源
```

<h3 id="3.17">3.17 设置新资源时, 是否自动播放</h3>

```Objective-C
@property (nonatomic) BOOL autoplayWhenSetNewAsset;                    ///< 设置新的资源后, 是否自动调用播放. 默认为 YES
```

<h3 id="3.18">3.18 进入后台, 是否暂停播放</h3>

<p>
关于后台播放视频, 引用自: https://juejin.im/post/5a38e1a0f265da4327185a26

当您想在后台播放视频时:

1. 需要设置 videoPlayer.pauseWhenAppDidEnterBackground = NO; (该值默认为YES, 即App进入后台默认暂停).

2. 前往 `TARGETS` -> `Capability` -> enable `Background Modes` -> select this mode `Audio, AirPlay, and Picture in Picture`
</p>

```Objective-C
_player.pauseWhenAppDidEnterBackground = NO; // 默认值为 YES, 即进入后台后 暂停.
```

<h3 id="3.19">3.19 进入前台, 是否恢复播放</h3>

```Objective-C
@property (nonatomic) BOOL resumePlaybackWhenAppDidEnterForeground;    ///< 进入前台时, 是否恢复播放. 默认为 NO
```

<h3 id="3.20">3.20 跳转完成, 是否恢复播放</h3>

```Objective-C
@property (nonatomic) BOOL resumePlaybackWhenPlayerHasFinishedSeeking; ///< 当`seekToTime:`操作完成后, 是否恢复播放. 默认为 YES
```

<h3 id="3.21">3.21 资源准备状态</h3>

<p>

资源准备(或初始化)的状态

当未设置资源时, 此时 player.assetStatus = .unknown
当设置新资源时, 此时 player.assetStatus = .preparing
当准备好播放时, 此时 player.assetStatus = .readyToPlay
当初始化失败时, 此时 player.assetStatus = .failed

</p>

```Objective-C
typedef NS_ENUM(NSInteger, SJAssetStatus) {
///
/// 未知状态
///
SJAssetStatusUnknown,

///
/// 准备中
///
SJAssetStatusPreparing,

///
/// 当前资源可随时进行播放(播放控制请查看`timeControlStatus`)
///
SJAssetStatusReadyToPlay,

///
/// 发生错误
///
SJAssetStatusFailed
};
```

<h3 id="3.22">3.22 播放控制状态</h3>

<p>

暂停或播放的控制状态

当调用了暂停时, 此时 player.timeControlStatus = .paused

当调用了播放时, 此时 将可能处于以下两种状态中的任意一个:
- player.timeControlStatus = .playing
正在播放中.

- player.timeControlStatus = .waitingToPlay
等待播放, 等待的原因请查看 player.reasonForWaitingToPlay

</p>

```Objective-C
typedef NS_ENUM(NSInteger, SJPlaybackTimeControlStatus) {
///
/// 暂停状态(已调用暂停或未执行任何操作的状态)
///
SJPlaybackTimeControlStatusPaused,

///
/// 播放状态(已调用播放), 当前正在缓冲或正在评估能否播放. 可以通过`reasonForWaitingToPlay`来获取原因, UI层可以根据原因来控制loading视图的状态.
///
SJPlaybackTimeControlStatusWaitingToPlay,

///
/// 播放状态(已调用播放), 当前播放器正在播放
///
SJPlaybackTimeControlStatusPlaying
};
```

<h3 id="3.23">3.23 播放等待的原因</h3>

<p>

当调用了播放, 播放器未能播放处于等待状态时的原因

等待原因有以下3种状态:
1.未设置资源, 此时设置资源后, 当`player.assetStatus = .readyToPlay`, 播放器将自动进行播放.
2.可能是由于缓冲不足, 播放器在等待缓存足够时自动恢复播放, 此时可以显示loading视图.
3.可能是正在评估缓冲中, 这个过程会进行的很快, 不需要显示loading视图.

</p>

```Objective-C
///
/// 缓冲中, UI层建议显示loading视图 
///
extern SJWaitingReason const SJWaitingToMinimizeStallsReason;

///
/// 正在评估能否播放, 处于此状态时, 不建议UI层显示loading视图
///
extern SJWaitingReason const SJWaitingWhileEvaluatingBufferingRateReason;

///
/// 未设置资源
///
extern SJWaitingReason const SJWaitingWithNoAssetToPlayReason;
```

<h3 id="3.24">3.24 监听状态改变🔥</h3>

```Objective-C
///
/// 观察者
///
///         可以如下设置block, 来监听某个状态的改变
///         了解更多请前往头文件查看
///         player.playbackObserver.currentTimeDidChangeExeBlock = ...;
///         player.playbackObserver.durationDidChangeExeBlock = ...;
///         player.playbackObserver.timeControlStatusDidChangeExeBlock = ...;
///
@property (nonatomic, strong, readonly) SJPlaybackObservation *playbackObserver;
```

<h3 id="3.25">3.25 已观看的时长(当前资源)</h3>

```Objective-C
@property (nonatomic, readonly) NSTimeInterval durationWatched;                     ///< 已观看的时长(当前资源)
```

<h3 id="3.26">3.26 接入别的视频 SDK, 自己动手撸一个 SJVideoPlayerPlaybackController, 替换作者原始实现</h3>

<p>
某些时候, 我们需要接入第三方的视频SDK, 但是又想使用 SJBaseVideoPlayer 封装的其他的功能. 

这个时候, 我们可以自己动手, 将第三方的SDK封装一下, 实现 SJVideoPlayerPlaybackController 协议, 管理 SJBaseVideoPlayer 中的播放操作.

示例:

- 可以参考 SJAVMediaPlaybackController 中的实现.
- 封装 ijkplayer 的示例:  https://gitee.com/changsanjiang/SJIJKMediaPlaybackController
</p>

```Objective-C
_player.playbackController = Your PlaybackController.
```

___

<h2 id="4">4. 控制层的显示和隐藏</h4>

<p>
控制层的显示和隐藏, 此部分的内容由 "id &lt;SJControlLayerAppearManager&gt; controlLayerAppearManager" 提供支持.

controlLayerAppearManager 内部存在一个定时器, 当控制层显示时, 会开启此定时器. 一定间隔后,  会尝试隐藏控制层.

其他相关操作, 请见以下内容. 
</p>

<h3 id="4.1">4.1 让控制层显示</h3>

<p>
当控制层需要显示时, 可以调用下面方法. 


```Objective-C
[_player controlLayerNeedAppear];
```

此方法将会回调控制层的代理方法:

"- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer;"

代理将会对当前的控制层进行显示处理.
</p>

<h3 id="4.2">4.2 让控制层隐藏</h3>

<p>
当控制层需要隐藏时, 可以调用下面方法. 

```Objective-C
[_player controlLayerNeedDisappear];
```

此方法将会回调控制层的代理方法:

"- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer;"

代理将会对当前的控制层进行隐藏处理.
</p>


<h3 id="4.3">4.3 控制层是否显示中</h3>

```Objective-C
///
/// 控制层的显示状态(是否已显示)
///
@property (nonatomic, getter=isControlLayerAppeared) BOOL controlLayerAppeared;
```

<h3 id="4.4">4.4 是否在暂停时保持控制层显示</h3>

```Objective-C
///
/// 暂停的时候是否保持控制层显示
///
///         default value is NO
///
@property (nonatomic) BOOL pausedToKeepAppearState;
```

<h3 id="4.5">4.5 监听状态改变🔥</h3>

```Objective-C
///
/// 观察者
///
///         当需要监听控制层的显示和隐藏时, 可以设置`player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ...;`
///
@property (nonatomic, strong, readonly) id<SJControlLayerAppearManagerObserver> controlLayerAppearObserver;
```

<h3 id="4.6">4.6 自己动手撸一个 SJControlLayerAppearManager, 替换作者原始实现</h3>

<p>
同样的, 协议 "SJControlLayerAppearManager" 定义了一系列的操作, 只要实现了这些协议方法的对象, 就可以管理控制层的显示和隐藏.
</p>

```Objective-C
_player.controlLayerAppearManager = Your controlLayerAppearManager; 
```

___

<h2 id="5">5. 设备亮度和音量</h2>

<p>
设备亮度和音量的调整, 此部分的内容由 "id &lt;SJDeviceVolumeAndBrightnessManager&gt; deviceVolumeAndBrightnessManager" 提供支持.
</p>

<h3 id="5.1">5.1 调整设备亮度</h2>

```Objective-C
// 0 到 1
_player.deviceVolumeAndBrightnessManager.brightness = 1.0;
```

<h3 id="5.2">5.2 调整设备声音</h2>

```Objective-C
// 0 到 1
_player.deviceVolumeAndBrightnessManager.volume = 1.0;
```

<h3 id="5.3">5.3 监听状态改变🔥</h2>

```Objective-C
///
/// 观察者
///
@property (nonatomic, strong, readonly) id<SJDeviceVolumeAndBrightnessManagerObserver> deviceVolumeAndBrightnessObserver;
```

<h3 id="5.4">5.4 禁止播放器设置</h2>

```Objective-C
_player.disableBrightnessSetting = YES;
_player.disableVolumeSetting = YES;
```

<h3 id="5.5">5.5 自己动手撸一个 SJDeviceVolumeAndBrightnessManager, 替换作者原始实现</h2>

<p>
当需要对设备音量视图进行自定义时, 可以自己动手撸一个 SJDeviceVolumeAndBrightnessManager. 
</p>

```Objective-C
_player.deviceVolumeAndBrightnessManager = Your deviceVolumeAndBrightnessManager;
```

___

<h2 id="6">6. 旋转</h2>

<p>
此部分的内容由 "id &lt;SJRotationManagerProtocol&gt; rotationManager" 提供支持.

对于旋转, 我们开发者肯定需要绝对的控制, 例如: 设置自动旋转所支持方向. 能够主动+自动旋转, 而且还需要能在适当的时候禁止自动旋转. 旋转前后的回调等等... 放心这些功能都有, 我挨个给大家介绍.

另外旋转有两种方式:

- 仅旋转播放器视图 (默认情况下)
- 使 ViewController 也一起旋转

具体请看下面介绍.
</p>

<h3 id ="6.1">6.1 自动旋转</h3>

<p>
先说说何为自动旋转. 其实就是当设备方向变更时, 播放器根据设备方向进行自动旋转.
</p>

<h3 id ="6.2">6.2 设置自动旋转支持的方向</h3>

```Objective-C
/// 设置自动旋转支持的方向
_player.supportedOrientations = SJOrientationMaskLandscapeLeft | SJOrientationMaskLandscapeRight;


/**
自动旋转支持的方向

- SJOrientationMaskPortrait:       竖屏
- SJOrientationMaskLandscapeLeft:  支持全屏, Home键在右侧
- SJOrientationMaskLandscapeRight: 支持全屏, Home键在左侧
- SJOrientationMaskAll:            全部方向
*/
typedef enum : NSUInteger {
SJOrientationMaskPortrait = 1 << SJOrientation_Portrait,
SJOrientationMaskLandscapeLeft = 1 << SJOrientation_LandscapeLeft,
SJOrientationMaskLandscapeRight = 1 << SJOrientation_LandscapeRight,
SJOrientationMaskAll = SJOrientationMaskPortrait | SJOrientationMaskLandscapeLeft | SJOrientationMaskLandscapeRight,
} SJOrientationMask;
```

<h3 id ="6.3">6.3 禁止自动旋转</h3>

<p>
这里有两点需要注意: 

- 合适的时候要记得恢复自动旋转. 
- 禁止自动旋转后, 主动调用旋转, 还是可以旋转的.
</p>

```Objective-C
_player.rotationManager.disabledAutorotation = YES;
```

<h3 id ="6.4">6.4 主动调用旋转</h3>

<p>
主动旋转. 当我们想主动旋转时, 大概分为以下三点:

-   播放器旋转到用户当前的设备方向或恢复小屏.
-   主动旋转到指定方向.
-   主动旋转完成后的回调.

请看以下方法, 分别对应以上三点:
</p>

```Objective-C
- (void)rotate;
- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated;
- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated completion:(void (^ _Nullable)(__kindof SJBaseVideoPlayer *player))block;
```

<h3 id ="6.5">6.5 是否全屏</h3>

```Objective-C
/// 如果为YES, 表示全屏
@property (nonatomic, readonly) BOOL isFullScreen;                              ///< 是否已全屏
```

<h3 id ="6.6">6.6 是否正在旋转</h3>

```Objective-C
/// 如果为YES, 表示正在旋转中
@property (nonatomic, readonly) BOOL isTransitioning;
```

<h3 id ="6.7">6.7 当前旋转的方向</h3>

```Objective-C
_player.rotationManager.currentOrientation
```

<h3 id ="6.8">6.8 监听状态改变🔥</h3>

```Objective-C
///
/// 观察者
///
///         当需要监听旋转时, 可以设置`player.rotationObserver.rotationDidStartExeBlock = ...;`
///         了解更多请前往头文件查看
///
@property (nonatomic, strong, readonly) id<SJRotationManagerObserver> rotationObserver;
```

<h3 id ="6.9">6.9 自己动手撸一个 SJRotationManager, 替换作者原始实现</h3>

当你想替换原始实现时, 可以实现 SJRotationManagerProtocol 中定义的方法.

___

<h2 id="7">7. 直接全屏而不旋转</h2>

<p>
直接全屏, 或者说充满屏幕, 但不旋转.
</p>

<h3 id="7.1">7.1 全屏和恢复</h3>

```Objective-C
_player.fitOnScreen = YES;

[_player setFitOnScreen:NO animated:NO];

[_player setFitOnScreen:YES animated:YES completionHandler:^(__kindof SJBaseVideoPlayer * _Nonnull player) {
/// ...
}];
```

<h3 id="7.2">7.2 监听状态改变🔥</h3>

```Objective-C
@property (nonatomic, copy, nullable) void(^fitOnScreenWillBeginExeBlock)(__kindof SJBaseVideoPlayer *player);
@property (nonatomic, copy, nullable) void(^fitOnScreenDidEndExeBlock)(__kindof SJBaseVideoPlayer *player);;
```

<h3 id="7.3">7.3 是否是全屏</h3>

```Objective-C
/// YES 为充满屏幕 
_player.isFitOnScreen
```

<h3 id="7.4">7.4 自己动手撸一个 SJFitOnScreenManager, 替换作者原始实现</h3>

该部分管理类的协议定义在 SJFitOnScreenManagerProtocol 中, 实现该协议的任何对象, 均可赋值给播放器, 替换原始实现.

___

<h2 id="8">8. 镜像翻转</h2>

<p>
此部分内容由 id&lt;SJFlipTransitionManager&gt; flipTransitionManager 提供支持

目前镜像翻转只写了 水平翻转, 未来可能会加入更多的翻转类型.
</p>

```Objective-C
typedef enum : NSUInteger {
SJViewFlipTransition_Identity,
SJViewFlipTransition_Horizontally, // 水平翻转
} SJViewFlipTransition;
```

<h3 id="8.1">8.1 翻转和恢复</h3>

```Objective-C
/// 当前的翻转类型
_player.flipTransition

/// 翻转相关方法
[_player setFlipTransition:SJViewFlipTransition_Horizontally];
[_player setFlipTransition:SJViewFlipTransition_Horizontally animated:YES];
[_player setFlipTransition:SJViewFlipTransition_Identity animated:YES completionHandler:^(__kindof SJBaseVideoPlayer * _Nonnull player) {
/// ...
}];
```

<h3 id="8.2">8.2 监听状态改变🔥</h3>

```Objective-C
///
/// 观察者
///
///         可以如下设置block, 来监听某个状态的改变
///
///         player.flipTransitionObserver.flipTransitionDidStartExeBlock = ...;
///         player.flipTransitionObserver.flipTransitionDidStopExeBlock = ...;
///
@property (nonatomic, strong, readonly) id<SJFlipTransitionManagerObserver> flipTransitionObserver;
```

<h3 id="8.3">8.3  自己动手撸一个 SJFlipTransitionManager, 替换作者原始实现</h3>

<p>
该部分管理类的协议定义在 SJFlipTransitionManagerProtocol 中, 实现该协议的任何对象, 均可赋值给播放器, 替换原始实现.
</p>

___

<h2 id="9">9. 网络状态</h2>

<p>
此部分内容由 id&lt;SJReachability&gt; reachability 提供支持

默认的 reachability 是个单例, 在App生命周期中, 仅创建一次. 因此每个播放器对象持有的 reachability 都是相同的. 
</p>

<h3 id="9.1">9.1 当前的网络状态</h3>

```Objective-C
@property (nonatomic, readonly) SJNetworkStatus networkStatus;
```

<h3 id="9.1">9.2 监听状态改变🔥</h3>

```Objective-C
///
/// 观察者
///
@property (nonatomic, strong, readonly) id<SJReachabilityObserver> reachabilityObserver;
```

<h3 id="9.1">9.3 自己动手撸一个 SJReachability, 替换作者原始实现</h3>

<p>
该部分管理类的协议定义在 SJNetworkStatus 中, 实现该协议的任何对象, 均可赋值给播放器, 替换原始实现.
</p>

___

<h2 id="10">10. 手势</h2>
<p>
此部分内容由 id&lt;SJPlayerGestureControl&gt; gestureControl 提供支持

播放器默认存在四种手势, 每个手势触发的回调均定义在 SJPlayerGestureControl 中, 当想改变某个手势的处理时, 可以直接修改对应手势触发的 block 即可.

具体请看以下部分.
</p>

<h3 id="10.1">10.1 单击手势</h3>

当用户单击播放器时, 播放器会调用 [显示或隐藏控制层的操作](#4)

以下为默认实现: 

```Objective-C
__weak typeof(self) _self = self;
_gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, CGPoint location) {
__strong typeof(_self) self = _self;
if ( !self ) return ;
/// 让控制层显示或隐藏
[self.controlLayerAppearManager switchAppearState];
};
```

<h3 id="10.2">10.2 双击手势</h3>

<p>
双击会触发暂停或播放的操作
</p>

```Objective-C
__weak typeof(self) _self = self;
_gestureControl.doubleTapHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, CGPoint location) {
__strong typeof(_self) self = _self;
if ( !self ) return ;
if ( [self playStatus_isPlaying] )
[self pause];
else
[self play];
};
```

<h3 id="10.3">10.3 移动手势</h3>

- 垂直滑动时, 默认情况下如果在屏幕左边, 则会触发调整亮度的操作, 并显示亮度提示视图. 如果在屏幕右边, 则会触发调整声音的操作, 并显示系统音量提示视图
- 水平滑动时, 会触发控制层相应的代理方法

```Objective-C
__weak typeof(self) _self = self;
_gestureControl.panHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, SJPanGestureTriggeredPosition position, SJPanGestureMovingDirection direction, SJPanGestureRecognizerState state, CGPoint translate) {
__strong typeof(_self) self = _self;
if ( !self ) return ;
/// ....
};
```

<h3 id="10.4">10.4 捏合手势</h3>

<p>
当用户做放大或收缩触发该手势时, 会设置播放器显示模式`Aspect`或`AspectFill`.
</p>

```Objective-C
__weak typeof(self) _self = self;
_gestureControl.pinchHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, CGFloat scale) {
__strong typeof(_self) self = _self;
if ( !self ) return ;
self.playbackController.videoGravity = scale > 1 ?AVLayerVideoGravityResizeAspectFill:AVLayerVideoGravityResizeAspect;
};
```

<h3 id="10.5">10.5 设置支持的手势</h3>

```Objective-C
_player.gestureControl.supportedGestureTypes = SJPlayerGestureTypeMask_All

typedef enum : NSUInteger {
SJPlayerGestureTypeMask_None,
SJPlayerGestureTypeMask_SingleTap = 1 << 0,
SJPlayerGestureTypeMask_DoubleTap = 1 << 1,
SJPlayerGestureTypeMask_Pan_H = 1 << 2, // 水平方向
SJPlayerGestureTypeMask_Pan_V = 1 << 3, // 垂直方向
SJPlayerGestureTypeMask_Pinch = 1 << 4,
SJPlayerGestureTypeMask_Pan = SJPlayerGestureTypeMask_Pan_H | SJPlayerGestureTypeMask_Pan_V,
SJPlayerGestureTypeMask_All = SJPlayerGestureTypeMask_SingleTap |
SJPlayerGestureTypeMask_DoubleTap |
SJPlayerGestureTypeMask_Pan |
SJPlayerGestureTypeMask_Pinch,
} SJPlayerGestureTypeMask;
```

<h3 id="10.6">10.6 自定义某个手势的处理</h3>

```Objective-C
/// 例如 替换单击手势的处理
__weak typeof(self) _self = self;
_player.gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, CGPoint location) {
__strong typeof(_self) self = _self;
if ( !self ) return ;
/// .....你的处理
};
```

___

<h2 id="11">11. 占位图</h2>

<p>
资源在初始化时, 由于暂时没有画面可以呈现, 会出现短暂的黑屏. 在此期间, 建议大家设置一下占位图.
</p>

<h3 id="11.1">11.1 设置本地占位图</h3>

```Objective-C
_player.presentView.placeholderImageView.image = [UIImage imageNamed:@"..."];
```

<h3 id="11.2">11.2 设置网络占位图</h3>

```Objective-C
[_player.presentView.placeholderImageView sd_setImageWithURL:URL placeholderImage:img];
```

<h3 id="11.3">11.3 是否隐藏占位图 - 播放器准备好显示时</h3>

```Objective-C
/// 播放器准备好显示时, 是否隐藏占位图
/// - 默认为YES
@property (nonatomic) BOOL hiddenPlaceholderImageViewWhenPlayerIsReadyForDisplay;
```

___

<h2 id="12">12. 显示提示文本</h2>

<p>
目前仅支持 NSAttributedString. 
</p>

<h3 id="12.1">12.1 显示管理类</h3>

```Objective-C
///
/// 中心弹出文本提示
///
///         了解更多请前往协议头文件查看
///
@property (nonatomic, strong, null_resettable) id<SJPromptProtocol> prompt;

///
/// 右下角弹出提示
///
///         了解更多请前往协议头文件查看
///
@property (nonatomic, strong, null_resettable) id<SJPopPromptControllerProtocol> popPromptController;
```

<h3 id="12.1">12.2 配置提示文本</h3>

```Objective-C
_player.prompt.backgroundColor = ...;
_player.prompt.contentInset = ...;
```

___

<h2 id="13">13. 一些固定代码</h2>

<p>
接入播放器的 ViewController 中, 会写一些固定的代码, 我将这些固定代码(例如 进入下个页面时, 需要当前页面的播放器暂停), 都封装在了以下方法中. 

```Objective-C
- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];
[_player vc_viewDidAppear];
}
```

在适当的时候直接调用即可, 以下为内部实现:
</p>

<h3 id="13.1">13.1 - (void)vc_viewDidAppear; </h3>

<p>
当 ViewController 的 viewDidAppear 调用时, 恢复播放

实现如下:
</p>

```Objective-C
- (void)vc_viewDidAppear {
if ( !self.isPlayOnScrollView || (self.isPlayOnScrollView && self.isScrollAppeared) ) {
/// 恢复播放
[self play];
}

/// 标识vc已显示 
/// vc_isDisappeared 是自动旋转触发的条件之一, 如果控制器 disappear 了, 就不会触发旋转 
self.vc_isDisappeared = NO;
}
```

<h3 id="13.2">13.2 - (void)vc_viewWillDisappear;</h3>

<p>
当 ViewController 的 viewWillDisappear 调用时, 设置标识为YES

实现如下:
</p>

```Objective-C
- (void)vc_viewWillDisappear {
/// 标识vc已显示 
/// vc_isDisappeared 是自动旋转触发的条件之一, 如果控制器 disappear 了, 就不会触发旋转 
self.vc_isDisappeared = YES;
}
```

<h3 id="13.3">13.3 - (void)vc_viewDidDisappear;</h3>

<p>
当 ViewController 的 viewDidDisappear 调用时, 暂停播放

实现如下:
</p>

```Objective-C
- (void)vc_viewDidDisappear {
[self pause];
}
```

<h3 id="13.4">13.4 - (BOOL)vc_prefersStatusBarHidden;</h3>

<p>
状态栏是否可以隐藏

实现如下: 
</p>

```Objective-C
- (BOOL)vc_prefersStatusBarHidden {
if ( _tmpShowStatusBar ) return NO;         // 临时显示
if ( _tmpHiddenStatusBar ) return YES;      // 临时隐藏
if ( self.lockedScreen ) return YES;        // 锁屏时, 不显示
if ( self.rotationManager.isTransitioning ) { // 旋转时, 不显示
if ( !self.disabledControlLayerAppearManager && self.isControlLayerAppeared ) return NO;
return YES;
}
// 全屏播放时, 使状态栏根据控制层显示或隐藏
if ( self.isFullScreen ) return !self.isControlLayerAppeared;
return NO;
}
```

<h3 id="13.5">13.5 - (UIStatusBarStyle)vc_preferredStatusBarStyle;</h3>

<p>
状态栏显示白色还是黑色

实现如下:
</p>

```Objective-C
- (UIStatusBarStyle)vc_preferredStatusBarStyle {
// 全屏播放时, 使状态栏变成白色
if ( self.isFullScreen || self.fitOnScreen ) return UIStatusBarStyleLightContent;
return UIStatusBarStyleDefault;
}
```

<h3 id="13.6">13.6 - 临时显示状态栏</h3>

<p>
有时候, 可能会希望临时显示状态栏, 例如全屏转回小屏时, 旋转之前, 需要将状态栏显示.
</p>

```Objective-C
[_player needShowStatusBar]; 
```

<h3 id="13.7">13.7 - 临时隐藏状态栏</h3>

<p>
有时候, 可能会希望临时隐藏状态栏, 例如某个播放器控制层不需要显示状态栏.
</p>

```Objective-C
[_player needHiddenStatusBar]; 
```

___

<h2 id="14">14. 截屏</h2>

<h3 id="14.1">14.1 当前时间截图</h3>

```Objective-C
UIImage *img = [_player screenshot];
```

<h3 id="14.1">14.2 指定时间截图</h3>

```Objective-C
- (void)screenshotWithTime:(NSTimeInterval)secs
completion:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, UIImage * __nullable image, NSError *__nullable error))block;

/// 可以通过 _player.playbackController.presentationSize 来获取当前视频宽高
- (void)screenshotWithTime:(NSTimeInterval)secs
size:(CGSize)size
completion:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, UIImage * __nullable image, NSError *__nullable error))block;
```

<h2 id="15">15. 导出视频或GIF</h2>

<h3 id="15.1">15.1 导出视频</h3>

```Objective-C
- (void)exportWithBeginTime:(NSTimeInterval)beginTime
duration:(NSTimeInterval)duration
presetName:(nullable NSString *)presetName
progress:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, float progress))progressBlock
completion:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, NSURL *fileURL, UIImage *thumbnailImage))completion
failure:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, NSError *error))failure;
```

<h3 id="15.2">15.2 导出GIF</h3>

```Objective-C
- (void)generateGIFWithBeginTime:(NSTimeInterval)beginTime
duration:(NSTimeInterval)duration
progress:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, float progress))progressBlock
completion:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, UIImage *imageGIF, UIImage *thumbnailImage, NSURL *filePath))completion
failure:(void(^)(__kindof SJBaseVideoPlayer *videoPlayer, NSError *error))failure;
```

<h3 id="15.3">15.3 取消操作</h3>

```Objective-C
/// 取消导出操作
/// 播放器 dealloc 时, 会调用一次 
- (void)cancelExportOperation;

/// 取消GIF操作
/// 播放器 dealloc 时, 会调用一次 
- (void)cancelGenerateGIFOperation;
```

<h2 id="16">16. 滚动相关</h2>

<p>
此部分的内容由 SJPlayModelPropertiesObserver 提供支持.
</p>


<h3 id="16.1">16.1 是否在 UICollectionView 或者 UITableView 中播放</h3>

```Objective-C
/// 是否是在 UICollectionView 或者 UITableView 中播放
_player.isPlayOnScrollView
```

<h3 id="16.2">16.2 是否已显示</h3>

```Objective-C
///
/// 播放器视图是否显示
///
/// Whether the player is appeared when playing on scrollView. Because scrollview may be scrolled.
///
@property (nonatomic, readonly) BOOL isScrollAppeared;
```

<h3 id="16.3">16.3 播放器视图将要滚动显示和消失的回调</h3>

```Objective-C
@property (nonatomic, copy, nullable) void(^playerViewWillAppearExeBlock)(__kindof SJBaseVideoPlayer *videoPlayer);
@property (nonatomic, copy, nullable) void(^playerViewWillDisappearExeBlock)(__kindof SJBaseVideoPlayer *videoPlayer);
```

<h3 id="16.4">16.4 滚动出去后, 是否暂停</h3>

```Objective-C
///
/// 滚动出去后, 是否暂停. 默认为YES
///
/// - default value is YES.
///
@property (nonatomic) BOOL pauseWhenScrollDisappeared;
```

<h3 id="16.5">16.5 滚动进入时, 是否恢复播放</h3>

```Objective-C
///
/// 滚动进入时, 是否恢复播放. 默认为YES
///
/// - default values is YES.
///
@property (nonatomic) BOOL resumePlaybackWhenScrollAppeared;
```

<h3 id="16.6">16.6 滚动出去后, 是否隐藏播放器视图</h3>

```Objective-C
///
/// 滚动出去后, 是否隐藏播放器视图. 默认为YES
///
/// - default value is YES.
///
@property (nonatomic) BOOL hiddenViewWhenScrollDisappeared;
```

<h2 id="17">17. 自动播放 - 在 UICollectionView 或者 UITableView 中</h2>

<p>
目前支持在 UICollectionViewCell 和 UITableViewCell 中自动播放.

使用之前, 请导入头文件 `#import "UIScrollView+ListViewAutoplaySJAdd.h"`
</p>

<h3 id="17.1">17.1 开启</h3>

```Objective-C
/// 配置列表自动播放
[_tableView sj_enableAutoplayWithConfig:[SJPlayerAutoplayConfig configWithPlayerSuperviewTag:101 autoplayDelegate:self]];


/// Delegate method
- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath {

}
```

<h3 id="17.2">17.2 配置</h3>

```Objective-C
typedef NS_ENUM(NSUInteger, SJAutoplayScrollAnimationType) {
SJAutoplayScrollAnimationTypeNone,
SJAutoplayScrollAnimationTypeTop,
SJAutoplayScrollAnimationTypeMiddle,
};

@interface SJPlayerAutoplayConfig : NSObject
+ (instancetype)configWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
autoplayDelegate:(id<SJPlayerAutoplayDelegate>)autoplayDelegate;

/// 滚动的动画类型
/// default is .Middle;
@property (nonatomic) SJAutoplayScrollAnimationType animationType;

@property (nonatomic, readonly) NSInteger playerSuperviewTag;
@property (nonatomic, weak, nullable, readonly) id<SJPlayerAutoplayDelegate> autoplayDelegate;
@end

@protocol SJPlayerAutoplayDelegate <NSObject>
- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath;
@end
```

<h3 id="17.3">17.3 关闭</h3>

```Objective-C
[_tableView sj_disenableAutoplay];
```

<h3 id="17.4">17.4 主动调用播放下一个资源</h3>

```Objective-C
[_tableView sj_needPlayNextAsset];
```

<h2 id="18">18. 对控制层上面的Item的操作</h2>

<h3 id="18.1">18.1 添加</h3>

```Objective-C
SJEdgeControlButtonItem *item = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"test"] target:self action:@selector(test) tag:SJTestImageItemTag];
[_player.defaultEdgeControlLayer.topAdapter addItem:item];
[_player.defaultEdgeControlLayer.topAdapter reload];
```

<h3 id="18.2">18.2 删除</h3>

```Objective-C
[_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];
[_player.defaultEdgeControlLayer.bottomAdapter reload];
```

<h3 id="18.3">18.3 调整位置</h3>

```Objective-C
[_player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_DurationTime withItemForTag:SJEdgeControlLayerBottomItem_Progress];
[_player.defaultEdgeControlLayer.bottomAdapter reload];
```

<h2 id="19">19. 对控制层上的Item的一些补充</h2>

<h3 id="19.1">19.1 设置与前后item的间距</h3>

```Objective-C
SJEdgeControlButtonItem *titleItem = [_player.defaultEdgeControlLayer.topAdapter itemForTag:SJEdgeControlLayerTopItem_Title];
titleItem.insets = SJEdgeInsetsMake(16, 16);
[_player.defaultEdgeControlLayer.topAdapter reload];
```

<h3 id="19.2">19.2 设置隐藏</h3>

```Objective-C
SJEdgeControlButtonItem *titleItem = [_player.defaultEdgeControlLayer.topAdapter itemForTag:SJEdgeControlLayerTopItem_Title];
titleItem.hidden = YES;
[_player.defaultEdgeControlLayer.topAdapter reload];
```

<h3 id="19.3">19.3 填充剩余空间</h3>

```Objective-C
SJEdgeControlButtonItem *titleItem = [_player.defaultEdgeControlLayer.topAdapter itemForTag:SJEdgeControlLayerTopItem_Title];
titleItem.fill = YES;
[_player.defaultEdgeControlLayer.topAdapter reload];
```

<h2 id="20">20. SJEdgeControlLayer 的补充</h2>

<h3 id="20.1">20.1 是否竖屏时隐藏返回按钮</h3>

```Objective-C
_player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
```

<h3 id="20.2">20.2 是否禁止网络状态变化提示</h3>

```Objective-C
_player.defaultEdgeControlLayer.disabledPromptWhenNetworkStatusChanges = YES;
```

<h3 id="20.3">20.3 是否使返回按钮常驻</h3>

```Objective-C
_player.defaultEdgeControlLayer.showResidentBackButton = YES;
```

<h3 id="20.4">20.4 是否隐藏底部进度条</h3>

```Objective-C
_player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
```

<h3 id="20.5">20.5 是否在loadingView上显示网速</h3>

```Objective-C
_player.defaultEdgeControlLayer.showNetworkSpeedToLoadingView = YES;
```

<h3 id="20.6">20.6 自定义loadingView</h3>

```Objective-C
// 实现协议`SJEdgeControlLayerLoadingViewProtocol`即可, 然后赋值给控制层
_player.defaultEdgeControlLayer.loadingView = Your Loading View;
```

<h3 id="20.7">20.7 调整边距</h3>

```Objective-C
_player.defaultEdgeControlLayer.leftMargin = 16;
_player.defaultEdgeControlLayer.rightMargin = 16;
```

<h3 id="20.8">20.8 取消控制层上下视图的阴影</h3>

```Objective-C
[_player.defaultEdgeControlLayer.topContainerView cleanColors];
[_player.defaultEdgeControlLayer.bottomContainerView cleanColors];
```
