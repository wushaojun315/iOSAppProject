//
//  ZZZNetworkConfigurer.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZNetworkConfigurer.h"
#import "AFNetworkReachabilityManager.h"

// server的Identifier(注意：使用“/”结尾，否则内部实现中url拼接会出问题)
NSString * const kAPIServerExampleServerIdentifier = @"https://echo.getpostman.com/";

// 每条API的请求路径后半段（注意：不要使用“/”开头，否则内部实现中url拼接会出问题）
NSString * const kAPISubURLStringExample = @"post";

@interface ZZZNetworkConfigurer ()
// 用户的token管理
@property (nonatomic, copy, readwrite) NSString *accessToken;
@property (nonatomic, copy, readwrite) NSString *refreshToken;
@property (nonatomic, assign, readwrite) NSTimeInterval lastRefreshTime;

// 每次启动App时都会新生成,用于日志标记
@property (nonatomic, copy, readwrite) NSString *sessionId;

@end

@implementation ZZZNetworkConfigurer
@synthesize userInfo = _userInfo;
@synthesize userID = _userID;

#pragma mark - 生命周期
+ (instancetype)sharedInstance {
    
    static ZZZNetworkConfigurer *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZZZNetworkConfigurer alloc] init];
        // 开始检测网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

#pragma mark - 公共方法
// 判断网络是否正常
- (BOOL)isNetworkReachable {
    AFNetworkReachabilityStatus networkReachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    // 当网络是WIFI、流量或未知时返回网络正常
    return networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ||
    networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN ||
    networkReachabilityStatus == AFNetworkReachabilityStatusUnknown;
}


- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken
{
    self.accessToken = accessToken;
    self.refreshToken = refreshToken;
    self.lastRefreshTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanUserInfo
{
    self.accessToken = nil;
    self.refreshToken = nil;
    self.userInfo = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - getters and setters
- (void)setUserID:(NSString *)userID
{
    _userID = [userID copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userID
{
    if (_userID == nil) {
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    return _userID;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = [userInfo copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    }
    return _userInfo;
}


- (NSString *)accessToken
{
    if (_accessToken == nil) {
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    }
    return _accessToken;
}

- (NSString *)refreshToken
{
    if (_refreshToken == nil) {
        _refreshToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"refreshToken"];
    }
    return _refreshToken;
}

@end
