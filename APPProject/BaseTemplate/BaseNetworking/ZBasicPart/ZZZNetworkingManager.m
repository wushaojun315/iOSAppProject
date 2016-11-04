//
//  ZZZNetworkingManager.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/25.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZNetworkingManager.h"
#import "AFNetworking.h"

#import "ZZZAPIResponse.h"
#import "ZZZAPIRequestGenerator.h"

@interface ZZZNetworkingManager ()

// AFNetworking 中的类
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

// 根据requestId，存放 NSURLSessionDataTask *task
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation ZZZNetworkingManager

#pragma mark - 懒加载
- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

// 会生成一个AFHttpSessionManager实例
// 可以在这里设置 sessionManager 的 NSURLSessionConfiguration
// sessionManager 的 securityPolicy （默认是[AFSecurityPolicy defaultPolicy]）
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        
        //        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        //        [NSURLCache setSharedURLCache:URLCache];
        //
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 20;
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];;
        // 默认：
        //        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        //        _sessionManager.securityPolicy.validatesDomainName = NO;
        
        
    }
    return _sessionManager;
}

#pragma mark - 生命周期
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static ZZZNetworkingManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZZZNetworkingManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - 公共方法

- (NSInteger)GETFromServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParams:(NSDictionary *)params success:(void (^)(ZZZAPIResponse *successResponse))successCallback failure:(void (^)(ZZZAPIResponse *failureResponse))failureCallback {
    
    NSURLRequest *request = [[ZZZAPIRequestGenerator sharedInstance] generatorGETRequestForServerIdentifier:serverIdentifier subURLString:subURLString withParam:params];
    
    return [self callApiWithRequest:request success:successCallback failure:failureCallback];
}

- (NSInteger)POSTFromServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParams:(NSDictionary *)params success:(void (^)(ZZZAPIResponse *))successCallback failure:(void (^)(ZZZAPIResponse *))failureCallback {
    
    NSURLRequest *request = [[ZZZAPIRequestGenerator sharedInstance] generatorPOSTRequestForServerIdentifier:serverIdentifier subURLString:subURLString withParam:params];
    
    return [self callApiWithRequest:request success:successCallback failure:failureCallback];
}

- (NSInteger)DELETEFromServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParams:(NSDictionary *)params success:(void (^)(ZZZAPIResponse *))successCallback failure:(void (^)(ZZZAPIResponse *))failureCallback {
    
    NSURLRequest *request = [[ZZZAPIRequestGenerator sharedInstance] generatorDELETERequestForServerIdentifier:serverIdentifier subURLString:subURLString withParam:params];
    
    return [self callApiWithRequest:request success:successCallback failure:failureCallback];
}

- (NSInteger)PUTFromServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParams:(NSDictionary *)params success:(void (^)(ZZZAPIResponse *))successCallback failure:(void (^)(ZZZAPIResponse *))failureCallback {
    
    NSURLRequest *request = [[ZZZAPIRequestGenerator sharedInstance] generatorPUTRequestForServerIdentifier:serverIdentifier subURLString:subURLString withParam:params];
    
    return [self callApiWithRequest:request success:successCallback failure:failureCallback];
}

// 使用requestId取消特定请求任务
- (void)cancelRequestWithRequestID:(NSNumber *)requestId {
    // 获取对应任务后取消
    NSURLSessionTask *requestTask = self.dispatchTable[requestId];
    [requestTask cancel];
    // 更新dispatchTable
    [self.dispatchTable removeObjectForKey:requestId];
}

// 取消多个任务，某个特定的 XXXAPIManager，取消其在执行的所有任务
- (void)cancelRequestsWithRequestIdList:(NSArray *)requestIdList {
    // 遍历
    for (NSNumber *requestId in requestIdList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - 私有方法
/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSInteger)callApiWithRequest:(NSURLRequest *)request success:(void (^)(ZZZAPIResponse *successResponse))successCallback failure:(void (^)(ZZZAPIResponse *failureResponse))failureCallback {
    
    ZZZAPILog(@"请求地址:\n%@", request.URL);
    
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          
                                          // 请求着陆后，从表中去除此请求任务
                                          NSNumber *requestID = @([dataTask taskIdentifier]);
                                          [self.dispatchTable removeObjectForKey:requestID];
                                          
                                          // 错误的时候回调
                                          if (error) {
                                              ZZZAPILog(@"返回的Error信息：\n%@", error);
                                              
                                              ZZZAPIResponse *failureResponse = [[ZZZAPIResponse alloc] initWithResponseObject:responseObject requestId:[requestID integerValue] error:error];
                                              
                                              failureCallback ? failureCallback(failureResponse) : nil;
                                          } else {
                                              ZZZAPILog(@"返回的responseObject数据：\n%@", responseObject);
                                              // 成功的回调
                                              ZZZAPIResponse *successResponse = [[ZZZAPIResponse alloc] initSuccessResponseWithResponseObject:responseObject requestId:[requestID integerValue]];
                                              
                                              successCallback ? successCallback(successResponse):nil;
                                          }
                                      }];
    // 获取当前任务的id，保存起来
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return [requestId integerValue];
}

@end
