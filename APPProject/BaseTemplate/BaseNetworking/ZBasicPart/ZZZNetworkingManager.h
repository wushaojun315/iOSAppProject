//
//  ZZZNetworkingManager.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/25.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*     底层调用AFNetworking发送请求 获取响应数据 内部的方法由ZZZBaseAPIManager调用    */
/******************************************************************************/

#import <Foundation/Foundation.h>

/**
 *  调试模式下日志输出
 */
// Debug模式下输出日志，release模式下不输出
#ifdef DEBUG

# define ZZZAPILog(format, ...) \
            do { \
                fprintf(stderr, \
                "*******************DEBUG Message*******************\n"\
                "[文件信息]:\n"\
                "文件ZZZNetworkingManager.m，发网络请求的函数--120行\n"\
                "[输出信息]:====>                                    \n"\
                "%s\n"\
                "\n===================================================\n", \
                [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);\
            } while (0)

#else

# define ZZZAPILog(...)

#endif

@class ZZZAPIResponse;

@interface ZZZNetworkingManager : NSObject

+ (instancetype)sharedInstance;


/**
 GET 请求
 */
- (NSInteger)GETFromServerIdentifier:(NSString *)serverIdentifier
                        subURLString:(NSString *)subURLString
                          withParams:(NSDictionary *)params
                             success:(void (^)(ZZZAPIResponse *successResponse))successCallback
                             failure:(void (^)(ZZZAPIResponse *failureResponse))failureCallback;

/**
 POST 请求
 */
- (NSInteger)POSTFromServerIdentifier:(NSString *)serverIdentifier
                         subURLString:(NSString *)subURLString
                           withParams:(NSDictionary *)params
                              success:(void (^)(ZZZAPIResponse *successResponse))successCallback
                              failure:(void (^)(ZZZAPIResponse *failureResponse))failureCallback;

/**
 DELETE 请求
 */
- (NSInteger)DELETEFromServerIdentifier:(NSString *)serverIdentifier
                           subURLString:(NSString *)subURLString
                             withParams:(NSDictionary *)params
                                success:(void (^)(ZZZAPIResponse *successResponse))successCallback
                                failure:(void (^)(ZZZAPIResponse *failureResponse))failureCallback;

/**
 PUT 请求
 */
- (NSInteger)PUTFromServerIdentifier:(NSString *)serverIdentifier
                        subURLString:(NSString *)subURLString
                          withParams:(NSDictionary *)params
                             success:(void (^)(ZZZAPIResponse *successResponse))successCallback
                             failure:(void (^)(ZZZAPIResponse *failureResponse))failureCallback;

// 取消请求，使用每个请求对应的requestId
- (void)cancelRequestWithRequestID:(NSNumber *)requestId;
- (void)cancelRequestsWithRequestIdList:(NSArray *)requestIdList;

@end
