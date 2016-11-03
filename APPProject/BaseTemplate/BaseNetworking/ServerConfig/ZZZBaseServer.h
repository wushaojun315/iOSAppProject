//
//  ZZZBaseServer.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*     用于表示后台服务器，测试、预发布和发布时可能使用不同的服务器，那个时候就需要切换      */
/******************************************************************************/

#import <Foundation/Foundation.h>

@interface ZZZBaseServer : NSObject

// 接口是否需要验证，使用到publicKey，privateKey（默认不验证，子类开启）
@property (nonatomic, assign, readonly) BOOL needVerification;
@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *privateKey;

// 主机地址
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
// API的版本（一般也用不到）
@property (nonatomic, strong, readonly) NSString *apiVersion;
// 向服务器发请求时，需要设置相同的httpHeader
@property (nonatomic, strong, readonly) NSDictionary *commonHTTPHeader;

@end
