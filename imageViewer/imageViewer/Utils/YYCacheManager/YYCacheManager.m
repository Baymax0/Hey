//
//  YYCacheManager.m
//  qyshow
//
//  Created by 李志伟 on 16/12/10.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import "YYCacheManager.h"
#import "YYCache.h"

static YYCacheManager *manager;
static NSString *lastUserId;

static YYCacheManager *manager2;

//用户相关   缓存路径
#define needLoginPath(userId) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"userCache_%@",userId]]
//用户不相关 缓存路径
#define unLoginPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"userCache_UnLogin"]]

//保存时间
#define SaveTimeDic @"SaveTimeDic"
//刷新时间间隔
#define ReflashInterval 3600*1

@interface YYCacheManager()

@property(nonatomic, strong) YYCache * cache;

@end

@implementation YYCacheManager

//不需要登录的数据缓存
+(YYCacheManager*)unLoginShare{
    if (!manager2) {
        manager2 = [[YYCacheManager alloc] init];
        NSString *path = unLoginPath;
        manager2.cache = [[YYCache alloc] initWithPath:path];
    }
    return manager2;
}
//退出登录
+(void)quitNeedLoginCache{
    manager = nil;
}

#pragma mark == get set Function==
-(id)getCacheForKey:(NSString *)key{
    if (key&&![key isEqualToString:@""]) {
        return [self.cache.diskCache objectForKey:key];
    }
    return nil;
}

-(void)setCache:(id)cache forKey:(NSString*)key{
    if (key&&![key isEqualToString:@""]) {
        [self.cache.diskCache setObject:cache forKey:key];
    }
}

-(NSMutableArray*)getListCacheForKey:(NSString *)key{
    NSArray *temp;
    if (key&&![key isEqualToString:@""]) {
        id data = [self.cache.diskCache objectForKey:key];
        if (data && [data isKindOfClass:[NSArray class]]) {
            temp = data;
        }else{
            temp = [NSArray array];
        }
    }else{
        temp = [NSArray array];
    }
    return temp.mutableCopy;
}

//#warning todo 清楚缓存
-(void)removeCache{
    
}

@end
