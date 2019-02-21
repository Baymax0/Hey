#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SJBaseVideoPlayer+PlayStatus.h"
#import "SJBaseVideoPlayer.h"
#import "UIScrollView+ListViewAutoplaySJAdd.h"
#import "SJControlLayerAppearManagerProtocol.h"
#import "SJDeviceVolumeAndBrightnessManagerProtocol.h"
#import "SJFitOnScreenManagerProtocol.h"
#import "SJFlipTransitionManagerProtocol.h"
#import "SJMediaPlaybackProtocol.h"
#import "SJModalViewControlllerManagerProtocol.h"
#import "SJNetworkStatus.h"
#import "SJPlayerBufferStatus.h"
#import "SJPlayerGestureControlProtocol.h"
#import "SJRotationManagerProtocol.h"
#import "SJVideoPlayerControlLayerProtocol.h"
#import "SJVideoPlayerPreviewInfo.h"
#import "SJVideoPlayerState.h"
#import "SJPlayerAutoplayConfig.h"
#import "SJPlayModel.h"
#import "SJVideoPlayerURLAsset.h"
#import "SJAVMediaPlayAssetSwitcher.h"
#import "SJAVMediaPlaybackController.h"
#import "SJVideoPlayerURLAsset+SJAVMediaPlaybackAdd.h"
#import "SJAVMediaModelProtocol.h"
#import "SJAVMediaPlayAsset+SJAVMediaPlaybackControllerAdd.h"
#import "SJAVMediaPlayAsset.h"
#import "SJAVMediaPlayAssetProtocol.h"
#import "SJAVMediaPresentView.h"
#import "SJDeviceVolumeAndBrightnessManager.h"
#import "SJBorderLineView.h"
#import "SJDeviceBrightnessView.h"
#import "SJDeviceVolumeAndBrightnessManagerResourceLoader.h"
#import "SJPrompt.h"
#import "SJPromptConfig.h"
#import "SJRotationManager.h"
#import "SJVCRotationManager.h"
#import "UINavigationController+SJExtension.h"
#import "UITabBarController+SJExtension.h"
#import "UIViewController+SJExtension.h"
#import "NSTimer+SJAssetAdd.h"
#import "SJControlLayerAppearStateManager.h"
#import "SJFitOnScreenManager.h"
#import "SJFlipTransitionManager.h"
#import "SJIsAppeared.h"
#import "SJModalViewControlllerManager.h"
#import "SJPlayerGestureControl.h"
#import "SJPlayModelPropertiesObserver.h"
#import "SJReachability.h"
#import "SJTimerControl.h"
#import "SJVideoPlayerPresentView.h"
#import "SJVideoPlayerRegistrar.h"
#import "UIView+SJVideoPlayerAdd.h"

FOUNDATION_EXPORT double SJBaseVideoPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char SJBaseVideoPlayerVersionString[];

