//
//  ZZZAPIRequestGenerator.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/30.
//  Copyright © 2016年 George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZZAPIRequestGenerator : NSObject


/**
 单例对象
 */
+ (instancetype)sharedInstance;

/**
 为由serverIdentifier、subURLString形成的接口，使用参数paramDict生成用于GET请求方式的请求
 */
- (NSURLRequest *)generatorGETRequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict;

/**
 为由serverIdentifier、subURLString形成的接口，使用参数paramDict生成用于POST请求方式的请求
 */
- (NSURLRequest *)generatorPOSTRequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict;

/**
 为由serverIdentifier、subURLString形成的接口，使用参数paramDict生成用于DELETE请求方式的请求
 */
- (NSURLRequest *)generatorDELETERequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict;

/**
 为由serverIdentifier、subURLString形成的接口，使用参数paramDict生成用于PUT请求方式的请求
 */
- (NSURLRequest *)generatorPUTRequestForServerIdentifier:(NSString *)serverIdentifier subURLString:(NSString *)subURLString withParam:(NSDictionary *)paramDict;

@end
