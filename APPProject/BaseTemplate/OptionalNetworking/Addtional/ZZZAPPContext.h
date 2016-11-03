//
//  ZZZAPPContext.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*                 应用、设备等的一些具体参数 可能从中获取公共的HTTP头                 */
/******************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZZZBaseAPIManager;

@interface ZZZAPPContext : NSObject

//凡是未声明成readonly的都是需要在初始化的时候由外面给的

// 设备信息
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *model;
@property (nonatomic, copy, readonly) NSString *os;
@property (nonatomic, copy, readonly) NSString *rom;
@property (nonatomic, copy, readonly) NSString *ppi;
@property (nonatomic, copy, readonly) NSString *imei;
@property (nonatomic, copy, readonly) NSString *imsi;
@property (nonatomic, copy, readonly) NSString *deviceName;
@property (nonatomic, assign, readonly) CGSize resolution;

// 运行环境相关
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isOnline;

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
@property (nonatomic, strong) ZZZBaseAPIManager *updateTokenAPIManager;

// 地理位置
@property (nonatomic, assign, readonly) CGFloat latitude;
@property (nonatomic, assign, readonly) CGFloat longitude;

+ (instancetype)sharedInstance;

- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;
- (void)cleanUserInfo;

@end
