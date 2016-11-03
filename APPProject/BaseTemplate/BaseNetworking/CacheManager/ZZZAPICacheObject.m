//
//  ZZZAPICacheObject.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/29.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZAPICacheObject.h"
#import "ZZZNetworkConfigurer.h"

@interface ZZZAPICacheObject ()


@property (nonatomic, strong) NSDate *lastUpdateTime;

@end

@implementation ZZZAPICacheObject

#pragma mark - Getter/Setter方法
- (BOOL)isOutdated {
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    // 返回是否已经超过缓存的有效期
    return timeInterval > kNetworkCacheOutdateTime;
}

#pragma mark - 初始化方法
// 初始化时，需要设置lastUpdateTime
- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastUpdateTime = [NSDate date];
    }
    return self;
}

#pragma mark - 公共方法
// 对过期的cache更新response，对新建的cache设置response
- (void)updateCacheResponse:(ZZZAPIResponse *)newResponse {
    
    _cachedResponse = newResponse;
    _lastUpdateTime = [NSDate date];
}

@end
