//
//  ZZZExampleServer.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZExampleServer.h"
#import "ZZZNetworkConfigurer.h"

@implementation ZZZExampleServer
@synthesize needVerification = _needVerification;

/**
 如果服务器需要公共密钥、私有密钥验证的话就需要重写init方法（不需要就不用重写），在init方法中设置needValidation为YES，然后接下来重写publicKey和privateKey的getter方法以获取需要的公共密钥、私有密钥
 */
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _needVerification = YES;
//    }
//    return self;
//}
//- (NSString *)publicKey {
//    return @"publicKey";
//}
//- (NSString *)privateKey {
//    return @"privateKey";
//}

// 返回服务器主机地址的方法是必须要实现的
- (NSString *)apiBaseUrl {
    return kAPIServerExampleServerIdentifier;
}

// 如果有公共的请求头参数的话，需要实现
- (NSDictionary *)commonHTTPHeader {
    
    NSDictionary *commonHeader = @{@"appName":@"configer.appName",
                                   @"osName":@"configer.osName",
                                   @"osVersion":@"configer.osVersion",
                                   @"deveiceName":@"configer.deviceName",
                                   @"qtime":@"configer.qtime"};
    return commonHeader;
}

// 如果有要求，需要实现（一般用不到）
- (NSString *)apiVersion {
    return @"v1.0";
}

@end
