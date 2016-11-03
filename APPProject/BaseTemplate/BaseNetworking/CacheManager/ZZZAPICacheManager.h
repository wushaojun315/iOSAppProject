//
//  ZZZAPICacheManager.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/29.
//  Copyright © 2016年 George. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZZAPIResponse;

@interface ZZZAPICacheManager : NSObject

/**
 单例
 */
+ (instancetype)sharedInstance;


/**
 通过参数给定的服务器ID，请求路径subURLString以及参数字典requestParams获取缓存起来的响应对象
 返回值为空时表示无法取得有效响应（缓存不存在，或者过期了）
 */
- (ZZZAPIResponse *)fetchCacheResponseWithServerIdentifier:(NSString *)serverIdentifier
                                              subURLString:(NSString *)subURLString
                                             requestParams:(NSDictionary *)requestParams;

/**
 将网络请求获得的响应对象缓存起来
 */
- (void)saveToCacheWithResponse:(ZZZAPIResponse *)response
               serverIndetifier:(NSString *)serverIdentifier
                   subURLString:(NSString *)subURLString
                  requestParams:(NSDictionary *)requestParams;

/**
 删除缓存中的某一条
 */
- (void)deleteCacheWithServerIdentifier:(NSString *)serverIdentifier
                           subURLString:(NSString *)subURLString
                          requestParams:(NSDictionary *)requestParams;

/**
 清空所有缓存
 */
- (void)cleanCache;

/**
 清空通过某个接口缓存的数据(使用NSCache的话我无法获取到keys，就没法删除了)--未实现
 */
- (void)cleanCacheWithServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString;

@end


@interface NSDictionary (ZZZAPICacheManagerAddtional)


/**
 将字典进行格式转换、编码得到唯一对应的字符串
 */
- (NSString *)toUniqueURLParamString;

@end
