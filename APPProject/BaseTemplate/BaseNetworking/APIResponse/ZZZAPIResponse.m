//
//  ZZZAPIResponse.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/28.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZAPIResponse.h"

@implementation ZZZAPIResponse

#pragma mark - 初始化方法
- (instancetype)initWithFailureType:(ZZZAPIManagerResultStautus)requestResultStatus requestId:(NSInteger)requestId{
    
    self = [super init];
    if (self) {
        _requestFailed = YES;
        _requestResultStatus = requestResultStatus;
        _requestId = requestId;
    }
    return self;
}

- (instancetype)initWithResponseObject:(id)responseObject requestId:(NSInteger)requestId error:(NSError *)error {
    
    self = [super init];
    if (self) {
        _requestFailed = YES;
        _requestResultStatus = [self getRequestResultStatusByError:error];
        _requestId = requestId;
        _receivedResponseObject = responseObject;
    }
    return self;
}

- (instancetype)initSuccessResponseWithResponseObject:(id)responseObject requestId:(NSInteger)requestId {
    
    self = [super init];
    if (self) {
        _requestFailed = NO;
        // 需要看看数据是否正确才能得到最终结果
        _requestResultStatus = ZZZAPIManagerResultStautusSuccessWithRightData;
        _requestId = requestId;
        _receivedResponseObject = responseObject;
    }
    return self;
}

#pragma mark - 对外暴露的属性设置/修改方法

- (void)updateRequestResultStatusWithStatus:(ZZZAPIManagerResultStautus)newStatus {
    
    _requestResultStatus = newStatus;
}

- (void)setRequestParam:(NSDictionary *)requestParam {
    _requestParam = [requestParam copy];
}

- (void)updateCachedStatus:(BOOL)isCached {
    _isCache = isCached;
}

#pragma mark - 私有方法
- (ZZZAPIManagerResultStautus)getRequestResultStatusByError:(NSError *)error {
    
    if (error) {
        ZZZAPIManagerResultStautus result = ZZZAPIManagerResultStautusOtherError;
        
        // 除了超时以外，所有错误都当成是OtherError
        if (error.code == NSURLErrorTimedOut) {
            result = ZZZAPIManagerResultStautusTimeout;
        }
        return result;
    } else {
        //
        return ZZZAPIManagerResultStautusDefault;
    }
}

@end
