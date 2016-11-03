//
//  ZZZAPIRequestGenerator.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/30.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZAPIRequestGenerator.h"
#import "AFURLRequestSerialization.h"
#import "ZZZNetworkConfigurer.h"
#import "ZZZBaseServer.h"
#import "ZZZServerFactory.h"

@interface ZZZAPIRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation ZZZAPIRequestGenerator

#pragma mark - 懒加载
- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kAPIRequestTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - 生成单例
+ (instancetype)sharedInstance {
    
    static ZZZAPIRequestGenerator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZZZAPIRequestGenerator alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 公共方法
- (NSURLRequest *)generatorGETRequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict {
    // 通过serverIdentifier获取server，拿到请求的baseurl
    ZZZBaseServer *server = [[ZZZServerFactory sharedInstance] serverWithIdentifier:serverIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", server.apiBaseUrl, subURLString];
    
//    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:paramDict error:nil];
    // 设置请求的一些属性
//    [request setValue:[ZZZNetworkConfigurer sharedInstance].accessToken forHTTPHeaderField:@"XXXXX"];
    
    return request;
}

- (NSURLRequest *)generatorPOSTRequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict {
    // 通过serverIdentifier获取server，拿到请求的baseurl
    ZZZBaseServer *server = [[ZZZServerFactory sharedInstance] serverWithIdentifier:serverIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", server.apiBaseUrl, subURLString];
    
    //    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:paramDict error:nil];
    // 设置请求的一些属性
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paramDict options:0 error:NULL];
    //    [request setValue:[ZZZNetworkConfigurer sharedInstance].accessToken forHTTPHeaderField:@"XXXXX"];
    
    return request;
}

- (NSURLRequest *)generatorDELETERequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict {
    // 通过serverIdentifier获取server，拿到请求的baseurl
    ZZZBaseServer *server = [[ZZZServerFactory sharedInstance] serverWithIdentifier:serverIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", server.apiBaseUrl, subURLString];
    
    //    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:paramDict error:nil];
    // 设置请求的一些属性
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paramDict options:0 error:NULL];
    //    [request setValue:[ZZZNetworkConfigurer sharedInstance].accessToken forHTTPHeaderField:@"XXXXX"];
    
    return request;
}

- (NSURLRequest *)generatorPUTRequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict {
    // 通过serverIdentifier获取server，拿到请求的baseurl
    ZZZBaseServer *server = [[ZZZServerFactory sharedInstance] serverWithIdentifier:serverIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", server.apiBaseUrl, subURLString];
    
    //    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:paramDict error:nil];
    // 设置请求的一些属性
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paramDict options:0 error:NULL];
    //    [request setValue:[ZZZNetworkConfigurer sharedInstance].accessToken forHTTPHeaderField:@"XXXXX"];
    
    return request;
}

@end
