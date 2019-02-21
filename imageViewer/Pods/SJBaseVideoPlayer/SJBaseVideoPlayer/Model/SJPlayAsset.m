//
//  SJPlayAsset.m
//  SJVideoPlayerAssetCarrier
//
//  Created by BlueDancer on 2018/6/28.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "SJPlayAsset.h"
#import <SJObserverHelper/NSObject+SJObserverHelper.h>
#import "NSTimer+SJAssetAdd.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const SJPlayAssetDidCompletedLoadNotification = @"SJPlayAssetDidCompletedLoadNotification";

@protocol SJPlayAssetDelegate<NSObject>

- (void)_assetDidCompletedLoad:(SJPlayAsset *)asset;

@end

@interface SJPlayAsset()
@property (nonatomic, strong, nullable) AVURLAsset *URLAsset;
@property (nonatomic, strong, nullable) AVPlayerItem *playerItem;
@property (nonatomic, strong, nullable) AVPlayer *player;
@property BOOL loadIsCompleted;
@property BOOL isLoading;

@end

@implementation SJPlayAsset

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL specifyStartTime:0];
}

- (instancetype)initWithURL:(NSURL *)URL specifyStartTime:(NSTimeInterval)specifyStartTime {
    NSParameterAssert(URL);
    
    self = [super init];
    if ( !self ) return nil;
    _URL = URL;
    _specifyStartTime = specifyStartTime;
    return self;
}

- (instancetype)initWithOtherAsset:(SJPlayAsset *)other {
    NSParameterAssert(other);
    
    self = [super init];
    if ( !self ) return nil;
    _URL = other.URL;
    _URLAsset = other.URLAsset;
    _playerItem = other.playerItem;
    _player = other.player;
    _isOtherAsset = YES;
    _loadIsCompleted = YES;
    __weak typeof(self) _self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [NSNotificationCenter.defaultCenter postNotificationName:SJPlayAssetDidCompletedLoadNotification object:self];
    });
    return self;
}

- (void)load {
    if ( self.loadIsCompleted ) return;
    if ( self.isLoading ) return;
    
    self.isLoading = YES;
    __weak typeof(self) _self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        AVURLAsset *URLAsset = [AVURLAsset assetWithURL:self.URL];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:URLAsset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        self.URLAsset = URLAsset;
        self.playerItem = playerItem;
        self.player = player;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            self.loadIsCompleted = YES;
            self.isLoading = NO;
            [NSNotificationCenter.defaultCenter postNotificationName:SJPlayAssetDidCompletedLoadNotification object:self];
        });
    });
}

@end


#pragma mark -

@interface SJPlayAssetPropertiesObserver()<SJPlayAssetDelegate>

@property (nonatomic, strong) SJPlayAsset *playerAsset;

@property (nonatomic, strong, nullable) NSTimer *refresheBufferTimer;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval currentTime;
@property (nonatomic) NSTimeInterval bufferLoadedTime;
@property (nonatomic) SJPlayerBufferStatus bufferStatus;
@property (nonatomic) CGSize presentationSize;

@property (nonatomic) AVPlayerItemStatus playerItemStatus;

@end

@implementation SJPlayAssetPropertiesObserver {
    id _noteToken;
    id _currentTimeNoteToken;
    id _playDidToEndNotaToken;
    BOOL _added;
}

- (instancetype)initWithPlayerAsset:(SJPlayAsset *)playerAsset {
    self = [super init];
    if ( !self ) return nil;
    _playerAsset = playerAsset;
    if ( !playerAsset.loadIsCompleted ) {
        __weak typeof(self) _self = self;
        _noteToken = [NSNotificationCenter.defaultCenter addObserverForName:SJPlayAssetDidCompletedLoadNotification object:playerAsset queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            [self _assetDidCompletedLoad:playerAsset];
        }];
        [playerAsset load];
    }
    else {
        __weak typeof(self) _self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            [self _updateBufferLoadedTime];
            [self _updateDuration];
            [self _updateCurrentTime:playerAsset.player.currentTime];
            [self _updatePresentationSize];
            [self _updatePlayerItemStatus];
            [self _assetDidCompletedLoad:playerAsset];
        });
    }
    return self;
}

- (void)dealloc {
    if ( _currentTimeNoteToken ) [_playerAsset.player removeTimeObserver:_currentTimeNoteToken];
    if ( _noteToken ) [NSNotificationCenter.defaultCenter removeObserver:_noteToken];
}

static NSString *kLoadedTimeRanges = @"loadedTimeRanges";
static NSString *kDuration = @"duration";
static NSString *kPlaybackBufferEmpty = @"playbackBufferEmpty";
static NSString *kPresentationSize = @"presentationSize";
static NSString *kPlayerItemStatus = @"status";

- (void)_assetDidCompletedLoad:(SJPlayAsset *)asset {
    if ( _added ) return;
    _added = YES;
    [asset.playerItem sj_addObserver:self forKeyPath:kLoadedTimeRanges context:&kLoadedTimeRanges];
    [asset.playerItem sj_addObserver:self forKeyPath:kDuration context:&kDuration];
    [asset.playerItem sj_addObserver:self forKeyPath:kPlaybackBufferEmpty context:&kPlaybackBufferEmpty];
    [asset.playerItem sj_addObserver:self forKeyPath:kPresentationSize context:&kPresentationSize];
    [asset.playerItem sj_addObserver:self forKeyPath:kPlayerItemStatus context:&kPlayerItemStatus];
    __weak typeof(self) _self = self;
    _currentTimeNoteToken = [_playerAsset.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _updateCurrentTime:time];
    }];
    
    _playDidToEndNotaToken =
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerAsset.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.refresheBufferTimer ) {
            [self.refresheBufferTimer invalidate];
            self.refresheBufferTimer = nil;
            [self _updateBufferStatus:SJPlayerBufferStatusFull];
        }
        if ( [self.delegate respondsToSelector:@selector(playDidToEndForObserver:)] ) {
            [self.delegate playDidToEndForObserver:self];
        }
    }];
    
    if ( [self.delegate respondsToSelector:@selector(assetLoadIsCompletedForObserver:)] ) {
        [self.delegate assetLoadIsCompletedForObserver:self];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context {
    
    id value_new = change[NSKeyValueChangeNewKey];
    id value_old = change[NSKeyValueChangeOldKey];
    if ( value_new == value_old ) return;
    
    if ( context == &kLoadedTimeRanges ) {
        [self _updateBufferLoadedTime];
    }
    else if ( context == &kPlayerItemStatus ) {
        [self _updatePlayerItemStatus];
    }
    else if ( context == &kDuration ) {
        [self _updateDuration];
    }
    else if ( context == &kPlaybackBufferEmpty ) {
        if ( !self.playerAsset.playerItem.isPlaybackBufferEmpty ) return;
        [self _pollingPlaybackBuffer];
    }
    else if ( context == &kPresentationSize ) {
        [self _updatePresentationSize];
    }
}

- (void)_updateCurrentTime:(CMTime)cTime {
    NSTimeInterval time = CMTimeGetSeconds(cTime);
    if ( _currentTime == time ) return;
    _currentTime = time;
    if ( [self.delegate respondsToSelector:@selector(observer:currentTimeDidChange:)] ) {
        [self.delegate observer:self currentTimeDidChange:_currentTime];
    }
}

- (void)_updateDuration /* 初始化的时候调用 */ {
    NSTimeInterval time = CMTimeGetSeconds(_playerAsset.playerItem.duration);
    if ( time == _duration ) return;
    _duration = time;
    if ( [self.delegate respondsToSelector:@selector(observer:durationDidChange:)] ) {
        [self.delegate observer:self durationDidChange:_duration];
    }
}

- (void)_updateBufferLoadedTime {
    CMTimeRange range = _playerAsset.playerItem.loadedTimeRanges.firstObject.CMTimeRangeValue;
    NSTimeInterval time = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
    if ( time == _bufferLoadedTime ) return;
    _bufferLoadedTime = time;
    if ( [self.delegate respondsToSelector:@selector(observer:bufferLoadedTimeDidChange:)] ) {
        [self.delegate observer:self bufferLoadedTimeDidChange:_bufferLoadedTime];
    }
}

/// - 轮询缓冲
- (void)_pollingPlaybackBuffer {
    if ( floor(self.currentTime) == floor(self.duration) ) return;
    if ( self.bufferStatus == SJPlayerBufferStatusEmpty ) return;
    [self _updateBufferStatus:SJPlayerBufferStatusEmpty];
    __weak typeof(self) _self = self;
    self.refresheBufferTimer = [NSTimer assetAdd_timerWithTimeInterval:1 block:^(NSTimer *timer) {
        __strong typeof(_self) self = _self;
        if ( !self ) {
            [timer invalidate];
            return ;
        }

        if ( self.duration == 0 ) return;
        NSTimeInterval pre_buffer = [self _maxPreTime];
        if ( pre_buffer == 0 ) return;
        NSTimeInterval currentBufferLoadedTime = self.bufferLoadedTime;
        if ( pre_buffer > currentBufferLoadedTime ) return;
        
        [timer invalidate];
        self.refresheBufferTimer = nil;
        [self _updateBufferStatus:SJPlayerBufferStatusFull];
    } repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.refresheBufferTimer forMode:NSRunLoopCommonModes];
    
    [self.refresheBufferTimer assetAdd_fire];
}

- (NSTimeInterval)_maxPreTime {
    NSTimeInterval max = self.duration;
    if ( max == 0 ) return 0;
    NSTimeInterval pre = self.currentTime + 5;
    return pre < max ? pre : max;
}

- (void)_updateBufferStatus:(SJPlayerBufferStatus)bufferStatus {
    if ( bufferStatus == _bufferStatus ) return;
    _bufferStatus = bufferStatus;
    if ( [self.delegate respondsToSelector:@selector(observer:bufferStatusDidChange:)] ) {
        [self.delegate observer:self bufferStatusDidChange:bufferStatus];
    }
}

- (void)_updatePresentationSize {
    CGSize size = _playerAsset.playerItem.presentationSize;
    if ( CGSizeEqualToSize(_presentationSize, size) ) return;
    _presentationSize = size;
    if ( [self.delegate respondsToSelector:@selector(observer:presentationSizeDidChange:)] ) {
        [self.delegate observer:self presentationSizeDidChange:_presentationSize];
    }
}

- (void)_updatePlayerItemStatus {
    AVPlayerItemStatus status = _playerAsset.playerItem.status;
    if ( _playerItemStatus == status ) return;
    _playerItemStatus = status;
    if ( [self.delegate respondsToSelector:@selector(observer:playerItemStatusDidChange:)] ) {
        [self.delegate observer:self playerItemStatusDidChange:status];
    }
}

@end

NS_ASSUME_NONNULL_END
