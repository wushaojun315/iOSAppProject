//
//  ZZZBaseAPIManager.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZBaseAPIManager.h"
#import "ZZZNetworkingManager.h"

#import "ZZZAPIResponse.h"
#import "ZZZAPICacheManager.h"
#import "ZZZNetworkConfigurer.h"

@interface ZZZBaseAPIManager ()

@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign, readwrite) NSInteger lastRequestId;

@end

@implementation ZZZBaseAPIManager

#pragma mark - 生命周期
- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(ZZZAPIManagerProtocol)]) {
            self.child = (id<ZZZAPIManagerProtocol>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - 公共方法
- (id)fetchDataWithReformer:(id<ZZZAPIDataReformerProtocol>)dataReformer {
    
    id resultData = nil;
    if ([dataReformer respondsToSelector:@selector(reformResposeInManager:)]) {
        resultData = [dataReformer reformResposeInManager:self];
    } else {
        resultData = self.response.receivedResponseObject;
    }
    return resultData;
}

// manager直接调用这个方法可以获取数据（请求信息都由manager内部提供）
- (NSInteger)requestDataFromAPI {
    // 使用manager的paramSource获取参数---通常由viewController提供
    NSDictionary *params = [self.paramSource paramsForAPIManager:self];
    // 从viewController拿到的参数如果需要添加另外一些固定的参数的话
    NSDictionary *completeParams = [self reformParams:params];
    
    NSInteger requestId = [self requestDataWithParams:completeParams];
    return requestId;
}

- (NSInteger)requestDataWithParams:(NSDictionary *)params {
    
    NSInteger requestId = 0;
    // 根据拦截器返回结果确定是否能够发起请求,若不能直接返回
    if (![self shouldCallAPIWithParams:params]) {
        // 返回一个响应模型(不需要设置requestParam属性了，因为无需缓存也无需取缓存)
        ZZZAPIResponse *paramErrorResponse = [[ZZZAPIResponse alloc] initWithFailureType:ZZZAPIManagerResultStautusRequestIntercepted requestId:requestId];
        [self failedOnCallingAPIWithResponse:paramErrorResponse];
        return requestId;
    }
    
    // 发起请求前，先校验参数是否正确（统一教研时，validator可以设置为manager自身，如果需要有弹窗可以设置为viewController）
    // 参数错误，直接返回requestId为0
    if (self.validator && ![self.validator manager:self isCorrectWithParamsData:params]) {
        // 返回一个响应模型(不需要设置requestParam属性了，因为无需缓存也无需取缓存)
        ZZZAPIResponse *paramErrorResponse = [[ZZZAPIResponse alloc] initWithFailureType:ZZZAPIManagerResultStautusParamsError requestId:requestId];
        [self failedOnCallingAPIWithResponse:paramErrorResponse];
        return requestId;
    }
    
    // 获得参数后，先查询缓存，如果这个接口的这个参数有缓存就先从缓存中拿数据
    if ([self shouldCache]) {
        
        ZZZAPIResponse *cachedResponse = [[ZZZAPICacheManager sharedInstance] fetchCacheResponseWithServerIdentifier:self.child.serverIdentifier subURLString:self.child.subURLString requestParams:params];
        // 得到的响应对象不为空表示获取到了缓存的响应，直接回调
        if (cachedResponse) { // 此时的response已经有requestParam属性因为缓存过
            [self successedOnCallingAPIWithResponse:cachedResponse];
            return requestId;
        }
    }
    
    // 接口不缓存，或者该参数没有缓存数据时，发送网络请求
    // 如果没有网络连接，直接返回带“无网络连接”错误的响应对象
    if (![[ZZZNetworkConfigurer sharedInstance] isNetworkReachable]) {
        // 不需要设置requestParam属性了，因为无需缓存也无需取缓存
        ZZZAPIResponse *noNetworkResponse = [[ZZZAPIResponse alloc] initWithFailureType:ZZZAPIManagerResultStautusNoNetWork requestId:requestId];
        [self failedOnCallingAPIWithResponse:noNetworkResponse];
        return requestId;
    }
    
    // 一切准备就绪，开始网络请求
    self.isLoading = YES;
    switch (self.child.requestType) {
        case ZZZAPIManagerRequestTypeGet: {
            __weak typeof(self) weakSelf = self;
            // 调用底层方法，获得requestId
            requestId = [[ZZZNetworkingManager sharedInstance] GETFromServerIdentifier:self.child.serverIdentifier subURLString:self.child.subURLString withParams:params success:^(ZZZAPIResponse *successResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                // 需要设置requestParam属性了，因为可能需要缓存，会用到params用于生成唯一key
                [successResponse setRequestParam:params];
                [strongSelf successedOnCallingAPIWithResponse:successResponse];
            } failure:^(ZZZAPIResponse *failureResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf failedOnCallingAPIWithResponse:failureResponse];
            }];
        }
            
            break;
        case ZZZAPIManagerRequestTypePost: {
            __weak typeof(self) weakSelf = self;
            // 调用底层方法，获得requestId
            requestId = [[ZZZNetworkingManager sharedInstance] POSTFromServerIdentifier:self.child.serverIdentifier subURLString:self.child.subURLString withParams:params success:^(ZZZAPIResponse *successResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                // 需要设置requestParam属性了，因为可能需要缓存，会用到params用于生成唯一key
                [successResponse setRequestParam:params];
                [strongSelf successedOnCallingAPIWithResponse:successResponse];
            } failure:^(ZZZAPIResponse *failureResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf failedOnCallingAPIWithResponse:failureResponse];
            }];
        }
            
            break;
        case ZZZAPIManagerRequestTypeDelete: {
            __weak typeof(self) weakSelf = self;
            // 调用底层方法，获得requestId
            requestId = [[ZZZNetworkingManager sharedInstance] DELETEFromServerIdentifier:self.child.serverIdentifier subURLString:self.child.subURLString withParams:params success:^(ZZZAPIResponse *successResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                // 需要设置requestParam属性了，因为可能需要缓存，会用到params用于生成唯一key
                [successResponse setRequestParam:params];
                [strongSelf successedOnCallingAPIWithResponse:successResponse];
            } failure:^(ZZZAPIResponse *failureResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf failedOnCallingAPIWithResponse:failureResponse];
            }];
        }
            
            break;
        case ZZZAPIManagerRequestTypePut: {
            __weak typeof(self) weakSelf = self;
            // 调用底层方法，获得requestId
            requestId = [[ZZZNetworkingManager sharedInstance] PUTFromServerIdentifier:self.child.serverIdentifier subURLString:self.child.subURLString withParams:params success:^(ZZZAPIResponse *successResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                // 需要设置requestParam属性了，因为可能需要缓存，会用到params用于生成唯一key
                [successResponse setRequestParam:params];
                [strongSelf successedOnCallingAPIWithResponse:successResponse];
            } failure:^(ZZZAPIResponse *failureResponse) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf failedOnCallingAPIWithResponse:failureResponse];
            }];
        }
            
            break;
            
        default:
            break;
    }
    self.lastRequestId = requestId;
    // 保存起当前任务的id
    [self.requestIdList addObject:@(requestId)];
    
//    // 在调用成功之后的params字典里面，用这个key可以取出requestID
//    static NSString * const kCTAPIBaseManagerRequestID = @"kCTAPIBaseManagerRequestID";
//    NSMutableDictionary *apiParams = [params mutableCopy];
//    apiParams[kCTAPIBaseManagerRequestID] = @(requestId);
    // 拦截器，在调用完成之后调用
    [self afterCallingAPIWithParams:params];
    return requestId;
}

// 取消请求任务
- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    // 底层取消请求任务
    [[ZZZNetworkingManager sharedInstance] cancelRequestWithRequestID:@(requestID)];
    // 删除记录的该任务id
    [self.requestIdList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == requestID) {
            [self.requestIdList removeObject:obj];
        }
    }];
}

- (void)cancelAllRequests {
    
    [[ZZZNetworkingManager sharedInstance] cancelRequestsWithRequestIdList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cleanCacheForAPIManager {
    #warning TODO: 这里是把所有缓存都删除了,无法针对某一个api删除缓存
    [[ZZZAPICacheManager sharedInstance] cleanCache];
}

#pragma mark - 请求成功/失败后调用
// 成功后可以对数据进行缓存等
- (void)successedOnCallingAPIWithResponse:(ZZZAPIResponse *)apiResponse {
    // 请求着陆后，取消正在请求的状态
    self.isLoading = NO;
    // 将响应赋值
    self.response = apiResponse;
    // 请求已经结束，如果有保存这一requestId，需要先删除
    [self.requestIdList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == apiResponse.requestId) {
            [self.requestIdList removeObject:obj];
        }
    }];
    
    // 返回数据正确后,看看是否是从缓存中取出的数据，以此决定是否需要缓存起来
    
    // 如果获取的响应不是缓存起来的
    if (!apiResponse.isCache) {
        // 不是缓存起来的就要先检验返回数据是否正确，不正确则返回回调failedOnCallingAPIWithResponse:
        if (self.validator && ![self.validator manager:self isCorrectWithCallBackResponse:apiResponse]) {
            // 将response的failureType更新，然后回调失败操作
            [apiResponse updateRequestResultStatusWithStatus:ZZZAPIManagerResultStautusSuccessWithWrongData];
            [self failedOnCallingAPIWithResponse:apiResponse];
            return;
        }
        // 如果要缓存，则缓存起来（正确的数据才会走到缓存这一步）
        if ([self shouldCache]) {
            // 此时response对象已经有了请求时的参数了，可以用于设置唯一key
            // 缓存方法中会将response对象设置为isCahce为真
            [[ZZZAPICacheManager sharedInstance] saveToCacheWithResponse:apiResponse serverIndetifier:self.child.serverIdentifier subURLString:self.child.subURLString requestParams:apiResponse.requestParam];
        }
    }
    
    // 最后，不管数据是不是缓存的，都要回调了，回调前后两个拦截函数
    if ([self beforePerformSuccessWithResponse:apiResponse]) {
        [self.delegate didSuccessedOnCallingAPIWithManager:self];
    }
    [self afterPerformSuccessWithResponse:apiResponse];
}

// 失败之后也可以先进行一些操作，比如对response信息获取到的token进行判断
- (void)failedOnCallingAPIWithResponse:(ZZZAPIResponse *)apiResponse {
    // 请求着陆后，取消正在请求的状态
    self.isLoading = NO;
    
    self.response = apiResponse;
    // 请求已经结束，如果有保存这一requestId，需要先删除
    [self.requestIdList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == apiResponse.requestId) {
            [self.requestIdList removeObject:obj];
        }
    }];
    // 使用响应对象回调前后可以执行拦截方法
    if ([self beforePerformFailureWithResponse:apiResponse]) {
        [self.delegate didFailedOnCallingAPIWithManager:self];
    }
    [self afterPerformFailureWithResponse:apiResponse];
}

#pragma mark - 拦截器方法
/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的（如果需要重载，那这些方法就需要在.h文件中开放）
 所有重载的方法，都需要return [super ....];这样才能保证调用到拦截器代理的拦截代码，以拦截器返回值作为最终返回值（如果有拦截器的话）
 这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(ZZZAPIResponse *)response
{
    BOOL result = YES;
    
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(ZZZAPIResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailureWithResponse:(ZZZAPIResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailureWithResponse:(ZZZAPIResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - 私有方法

#pragma mark - 子类方法
// 如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
// 子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

// 默认接口不缓存，需要缓存时，子类重新实现这个代理方法返回YES即可
- (BOOL)shouldCache {
    return NO;
}

#pragma mark - 懒加载
- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

@end
