//
//  ZZZAPISignatureGenerator.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/11/1.
//  Copyright © 2016年 George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZZAPISignatureGenerator : NSObject

+ (NSString *)signGetWithSigParams:(NSDictionary *)allParams methodName:(NSString *)methodName privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey;

+ (NSString *)signPostWithApiParams:(NSDictionary *)apiParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey;
+ (NSString *)signRestfulPOSTWithApiParams:(id)apiParams commonParams:(NSDictionary *)commonParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey;

@end


@interface NSString (ZZZAPISignature)

- (NSString *)APISign_md5;

@end


@interface NSDictionary (ZZZAPISignature)

- (NSString *)urlParamsStringSignature;

- (NSString *)toJsonString;

@end


@interface NSArray (ZZZAPISignature)

/** 数组变json */
- (NSString *)toJsonString;

@end
