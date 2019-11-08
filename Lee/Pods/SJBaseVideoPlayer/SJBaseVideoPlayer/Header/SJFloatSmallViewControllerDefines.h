//
//  SJFloatSmallViewControllerDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/6/6.
//

#ifndef SJFloatSmallViewControllerDefines_h
#define SJFloatSmallViewControllerDefines_h
@protocol SJFloatSmallViewControllerObserverProtocol;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJFloatSmallViewControllerProtocol
- (id<SJFloatSmallViewControllerObserverProtocol>)getObserver;

/// 开启小浮窗, 注意: 默认为 不开启
///
/// - default value is NO.
@property (nonatomic, getter=isEnabled) BOOL enabled;

/// 显示小浮窗视图
///
/// - 只有`floatViewShouldAppear`返回YES, 小浮窗才会显示.
- (void)showFloatView;

/// 隐藏小浮窗视图
///
/// - 调用该方法将会立刻隐藏小浮窗视图.
- (void)dismissFloatView;

/// 该block将会在`showFloatView`时被调用
///
/// - 如果返回NO, 将不显示小浮窗.
@property (nonatomic, copy, nullable) BOOL(^floatViewShouldAppear)(id<SJFloatSmallViewControllerProtocol> controller);

/// 该block将会在单击小浮窗视图时被调用
///
@property (nonatomic, copy, nullable) void(^singleTappedOnTheFloatViewExeBlock)(id<SJFloatSmallViewControllerProtocol> controller);

/// 该block将会在双击小浮窗视图时被调用
///
@property (nonatomic, copy, nullable) void(^doubleTappedOnTheFloatViewExeBlock)(id<SJFloatSmallViewControllerProtocol> controller);

/// 小浮窗视图是否已显示
///
/// - default value is NO.
@property (nonatomic, readonly) BOOL isAppeared;

/// 小浮窗视图是否可以移动
///
/// - default value is YES.
@property (nonatomic) BOOL slidable;

/// 是否将小浮窗添加到window中. (注意: 小浮窗默认会添加到播放器同级的控制器视图上)
///
/// - default value is NO.
@property (nonatomic) BOOL addFloatViewToKeyWindow;

@property (nonatomic, strong, readonly) __kindof UIView *floatView; ///< float view

@property (nonatomic) CGFloat safeMargin; ///< default value is 12.

/// 以下属性由播放器维护
///
/// - target 为播放器呈现视图
/// - targetSuperview 为播放器视图
/// 当显示小浮窗时, 可以将target添加到小浮窗中
/// 当隐藏小浮窗时, 可以将target恢复到targetSuperview中
@property (nonatomic, weak, nullable) UIView *target;
@property (nonatomic, weak, nullable) UIView *targetSuperview;
@end


@protocol SJFloatSmallViewControllerObserverProtocol
@property (nonatomic, weak, readonly, nullable) id<SJFloatSmallViewControllerProtocol> controller;

@property (nonatomic, copy, nullable) void(^appearStateDidChangeExeBlock)(id<SJFloatSmallViewControllerProtocol> controller);
@property (nonatomic, copy, nullable) void(^enabledControllerExeBlock)(id<SJFloatSmallViewControllerProtocol> controller);
@end
NS_ASSUME_NONNULL_END

#endif /* SJFloatSmallViewControllerDefines_h */
