//
//  ZZZAPICacheManager.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/29.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZAPICacheManager.h"

#import "ZZZNetworkConfigurer.h"
#import "ZZZAPICacheObject.h"
#import "ZZZAPIResponse.h"

@interface ZZZAPICacheManager ()

@property (nonatomic, strong) NSCache *cacheCollections;

@end

@implementation ZZZAPICacheManager

#pragma mark - 懒加载
- (NSCache *)cacheCollections {
    if (_cacheCollections == nil) {
        _cacheCollections = [[NSCache alloc] init];
        _cacheCollections.countLimit = kNetworkCachedResponseMaxCount;
    }
    return _cacheCollections;
}

#pragma mark - 生命周期
+ (instancetype)sharedInstance {
    
    static ZZZAPICacheManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZZZAPICacheManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 公共方法
// 获取缓存起来的某一个api的特定参数对应的响应对象
- (ZZZAPIResponse *)fetchCacheResponseWithServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString requestParams:(NSDictionary *)requestParams {
    
    NSString *cachedKey = [self generateKeyWithServerIdentifier:serverIdentifier subURLString:subURLString requestParams:requestParams];
    
    ZZZAPICacheObject *cacheObject = [self.cacheCollections objectForKey:cachedKey];
    // 如果对应key存在缓存对象、缓存未过期、缓存对象中的响应数据不为空，则返回响应对象，否则返回空
    if (cacheObject && !cacheObject.isOutdated && cacheObject.cachedResponse) {
        return cacheObject.cachedResponse;
    } else {
        return nil;
    }
}

- (void)saveToCacheWithResponse:(ZZZAPIResponse *)response serverIndetifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString requestParams:(NSDictionary *)requestParams {
    
    NSString *cachedKey = [self generateKeyWithServerIdentifier:serverIdentifier subURLString:subURLString requestParams:requestParams];
    
    ZZZAPICacheObject *cacheObject = [self.cacheCollections objectForKey:cachedKey];
    // 获取到缓存中该key对应的缓存对象，如果不为空（说明过期了）需要更新缓存对象的response，如果为空则相当于新赋值
    if (cacheObject == nil) {
        cacheObject = [[ZZZAPICacheObject alloc] init];
    }
    // 对于要保存起来的response，需要设置其isCache属性为真
    [response updateCachedStatus:YES];
    [cacheObject updateCacheResponse:response];
    [self.cacheCollections setObject:cacheObject forKey:cachedKey];
}

- (void)deleteCacheWithServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString requestParams:(NSDictionary *)requestParams {
    
    NSString *cachedKey = [self generateKeyWithServerIdentifier:serverIdentifier subURLString:subURLString requestParams:requestParams];
    // 从缓存中拿到cacheObject
    ZZZAPICacheObject *cacheObject = [self.cacheCollections objectForKey:cachedKey];
    // 如果存在这个缓存对象就删除
    if (cacheObject) {
        [self.cacheCollections removeObjectForKey:cachedKey];
    }
}

- (void)cleanCache {
    [self.cacheCollections removeAllObjects];
}

- (void)cleanCacheWithServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString {
    
}

#pragma mark - 私有方法
// 使用参数生成唯一的key
- (NSString *)generateKeyWithServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString requestParams:(NSDictionary *)requestParams {
    // 先将requestParams转化为唯一对应字符串
    NSString *uniqueParamString = [requestParams toUniqueURLParamString];
    // 再全部连接起来获取唯一标识key
    NSString *cachedKey = [NSString stringWithFormat:@"%@%@?%@", serverIdentifier, subURLString, uniqueParamString];
    
    return cachedKey;
}

@end


@implementation NSDictionary (ZZZAPICacheManagerAddtional)

// 将作为参数的字典形成唯一的字符串
- (NSString *)toUniqueURLParamString {
    // 将字典中每个key-value对，形成字符串（value经过编码，key都是string无需编码）
    NSMutableArray *keyValuesArray = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // obj不是字符串的要转化为字符串
        if (![obj isKindOfClass:[NSString class]]) {
#warning TODO: 这样转化能保持两个obj对应的字符串一致(如果obj不是字符串的话)？
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        // 对从value对象获得的字符串进行UTF8编码
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
#pragma clang diagnostic pop
        // 转换为“key=value”的格式
        if ([obj length] > 0) {
            [keyValuesArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    // 排序然后使用&连接
    NSString *resultString = [[keyValuesArray sortedArrayUsingSelector:@selector(compare:)] componentsJoinedByString:@"&"];
    
    return resultString;
}

@end
