//
//  SJFitOnScreenManager.m
//  SJBaseVideoPlayer
//
//  Created by 畅三江 on 2018/12/31.
//

#import "SJFitOnScreenManager.h"

NS_ASSUME_NONNULL_BEGIN
static NSNotificationName const SJFitOnScreenManagerTransitioningValueDidChangeNotification = @"SJFitOnScreenManagerTransitioningValueDidChange";

@interface SJFitOnScreenManagerObserver : NSObject<SJFitOnScreenManagerObserver>
- (instancetype)initWithManager:(id<SJFitOnScreenManager>)manager;
@end

@implementation SJFitOnScreenManagerObserver
@synthesize fitOnScreenWillBeginExeBlock = _fitOnScreenWillBeginExeBlock;
@synthesize fitOnScreenDidEndExeBlock = _fitOnScreenDidEndExeBlock;

- (instancetype)initWithManager:(id<SJFitOnScreenManager>)manager {
    self = [super init];
    if ( !self )
        return nil;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(transitioningValueDidChange:) name:SJFitOnScreenManagerTransitioningValueDidChangeNotification object:manager];
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)transitioningValueDidChange:(NSNotification *)note {
    id<SJFitOnScreenManager> mgr = note.object;
    if ( mgr.isTransitioning ) {
        if ( _fitOnScreenWillBeginExeBlock )
            _fitOnScreenWillBeginExeBlock(mgr);
    }
    else {
        if ( _fitOnScreenDidEndExeBlock )
            _fitOnScreenDidEndExeBlock(mgr);
    }
}
@end


@interface SJFitOnScreenManager ()
@property (nonatomic, getter=isTransitioning) BOOL transitioning;
@property (nonatomic) BOOL innerFitOnScreen;
@property (nonatomic, strong, readonly) UIView *target;
@property (nonatomic, strong, readonly) UIView *superview;
@end

@implementation SJFitOnScreenManager
@synthesize duration = _duration;

- (instancetype)initWithTarget:(__strong UIView *)target targetSuperview:(__strong UIView *)superview {
    self = [super init];
    if ( !self )
        return nil;
    _target = target;
    _superview = superview;
    _duration = 0.4;
    return self;
}

- (id<SJFitOnScreenManagerObserver>)getObserver {
    return [[SJFitOnScreenManagerObserver alloc] initWithManager:self];
}

- (BOOL)isFitOnScreen {
    return _innerFitOnScreen;
}
- (void)setFitOnScreen:(BOOL)fitOnScreen {
    [self setFitOnScreen:fitOnScreen animated:YES];
}
- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated {
    [self setFitOnScreen:fitOnScreen animated:animated completionHandler:nil];
}
- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated completionHandler:(nullable void (^)(id<SJFitOnScreenManager>))completionHandler {
    if ( fitOnScreen == self.isFitOnScreen ) { if ( completionHandler ) completionHandler(self); return; }
    __weak typeof(self) _self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.innerFitOnScreen = fitOnScreen;
        self.transitioning = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if ( !window ) return;
        CGRect origin = [window convertRect:self.superview.bounds fromView:self.superview];
        if ( fitOnScreen ) {
            self.target.frame = origin;
            [window addSubview:self.target];
        }
        
        [UIView animateWithDuration:animated?self.duration:0 animations:^{
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( fitOnScreen ) {
                self.target.frame = window.bounds;
            }
            else {
                self.target.frame = origin;
            }
            [self.target layoutIfNeeded];
        } completion:^(BOOL finished) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( !fitOnScreen ) {
                [self.superview addSubview:self.target];
                self.target.frame = self.superview.bounds;
            }
            
            self.transitioning = NO;

            if ( completionHandler )
                completionHandler(self);
        }];
    });
}

- (void)setInnerFitOnScreen:(BOOL)innerFitOnScreen {
    if ( innerFitOnScreen == _innerFitOnScreen )
        return;
    _innerFitOnScreen = innerFitOnScreen;
}

- (void)setTransitioning:(BOOL)transitioning {
    _transitioning = transitioning;
    [NSNotificationCenter.defaultCenter postNotificationName:SJFitOnScreenManagerTransitioningValueDidChangeNotification object:self];
}
@end
NS_ASSUME_NONNULL_END
