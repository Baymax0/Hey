//
//  YYCacheManager.h
//  qyshow
//
//  Created by 李志伟 on 16/12/10.
//  Copyright © 2016年 baymax0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCacheManager : NSObject

//不需要登录的数据缓存
+(YYCacheManager*)unLoginShare;

//退出登录、切换缓存文件
+(void)quitNeedLoginCache;


#pragma mark == 存取方法 ==
-(id)getCacheForKey:(NSString *)key;
//cache = nil删除
-(void)setCache:(id)cache forKey:(NSString*)key;

-(NSMutableArray*)getListCacheForKey:(NSString *)key;

-(void)removeCache;



@end
