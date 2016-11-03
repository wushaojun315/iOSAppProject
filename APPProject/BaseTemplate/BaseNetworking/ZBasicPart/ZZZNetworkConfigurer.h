//
//  ZZZNetworkConfigurer.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*                                 网络框架的一些设置                            */
/******************************************************************************/

#import <Foundation/Foundation.h>

#ifndef ZZZNetworkingConfiguration_h
#define ZZZNetworkingConfiguration_h

// NSCache对象缓存数据的最多条数
static NSUInteger kNetworkCachedResponseMaxCount = 100;
// 15分钟的cache过期时间--900秒
static NSTimeInterval kNetworkCacheOutdateTime = 900;
// 请求响应的时间限制--30秒
static NSTimeInterval kAPIRequestTimeoutSeconds = 3000.0f;

// server的Identifier(注意：使用“/”结尾，否则内部实现中url拼接会出问题)
extern NSString * const kAPIServerExampleServerIdentifier;

// 每条API的请求路径后半段（注意：不要使用“/”开头，否则内部实现中url拼接会出问题）
extern NSString * const kAPISubURLStringExample;

#endif

@interface ZZZNetworkConfigurer : NSObject

// 用户token相关
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, assign, readonly) NSTimeInterval lastRefreshTime;

// 用户信息
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, readonly) BOOL isLoggedIn;

// app信息
@property (nonatomic, copy, readonly) NSString *sessionId; // 每次启动App时都会新生成
@property (nonatomic, readonly) NSString *appVersion;

// 推送相关
@property (nonatomic, copy) NSData *deviceTokenData;
@property (nonatomic, copy) NSString *deviceToken;
//@property (nonatomic, strong) CTAPIBaseManager *updateTokenAPIManager;

/**
 单例，单例对象可以检测网络状况、更新token等
 */
+ (instancetype)sharedInstance;

/**
 判断网络状况，是否有网络连接
 */
- (BOOL)isNetworkReachable;

- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;
- (void)cleanUserInfo;

@end
