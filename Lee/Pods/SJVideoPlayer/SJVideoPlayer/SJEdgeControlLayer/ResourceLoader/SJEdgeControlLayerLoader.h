//
//  SJEdgeControlLayerLoader.h
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2017/11/29.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSString *const SJVideoPlayer_ReplayText;
UIKIT_EXTERN NSString *const SJVideoPlayer_PreviewText;
UIKIT_EXTERN NSString *const SJVideoPlayer_PlayFailedText;
UIKIT_EXTERN NSString *const SJVideoPlayer_PlayFailedButtonText;
UIKIT_EXTERN NSString *const SJVideoPlayer_NotReachablePrompt;
UIKIT_EXTERN NSString *const SJVideoPlayer_ReachableViaWWANPrompt;
UIKIT_EXTERN NSString *const SJVideoPlayer_NotReachableText;
UIKIT_EXTERN NSString *const SJVideoPlayer_NotReachableButtonText;

@interface SJEdgeControlLayerLoader : NSObject

+ (nullable UIImage *)imageNamed:(NSString *)name;

+ (nullable NSString *)localizedStringForKey:(NSString *)key;

@end
NS_ASSUME_NONNULL_END
