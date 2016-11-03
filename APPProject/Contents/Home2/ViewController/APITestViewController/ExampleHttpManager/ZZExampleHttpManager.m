//
//  ZZExampleHttpManager.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/31.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZExampleHttpManager.h"

@implementation ZZExampleHttpManager

#pragma mark - ZZZAPIManagerProtocol代理方法
// 可以得到服务器，然后得到服务器的主机地址（URL地址的前半段）
- (NSString *)serverIdentifier {
    return kAPIServerExampleServerIdentifier;
}

- (NSString *)subURLString {
    return kAPISubURLStringExample;
}

- (ZZZAPIManagerRequestType)requestType {
    return ZZZAPIManagerRequestTypePost;
}

#pragma mark - ZZZAPIManagerProtocol中的可选代理方法
- (BOOL)shouldCache {
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    [dict setObject:@"07010001" forKey:@"wsCodeReq"];
    [dict setObject:@"18817365945" forKey:@"phoneNumber"];
    
    return dict;
}

@end
