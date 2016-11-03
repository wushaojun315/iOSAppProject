//
//  ZZZAPISignatureGenerator.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/11/1.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZAPISignatureGenerator.h"
#include <CommonCrypto/CommonDigest.h>

@implementation ZZZAPISignatureGenerator

+ (NSString *)signGetWithSigParams:(NSDictionary *)allParams methodName:(NSString *)methodName privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey
{
    NSString *sigString = [allParams urlParamsStringSignature];
    
    return [[NSString stringWithFormat:@"%@%@", sigString, privateKey] APISign_md5];
}

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    NSString *part1 = [NSString stringWithFormat:@"%@/%@", apiVersion, methodName];
    NSString *part2 = [allParams urlParamsStringSignature];
    NSString *part3 = privateKey;
    
    NSString *beforeSign = [NSString stringWithFormat:@"%@%@%@", part1, part2, part3];
    return [beforeSign APISign_md5];
}

+ (NSString *)signPostWithApiParams:(NSDictionary *)apiParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey
{
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:apiParams];
    sigParams[@"api_key"] = publicKey;
    NSString *sigString = [sigParams urlParamsStringSignature];
    return [[NSString stringWithFormat:@"%@%@", sigString, privateKey] APISign_md5];
}

+ (NSString *)signRestfulPOSTWithApiParams:(id)apiParams commonParams:(NSDictionary *)commonParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    NSString *part1 = [NSString stringWithFormat:@"%@/%@", apiVersion, methodName];
    NSString *part2 = [commonParams urlParamsStringSignature];
    NSString *part3 = nil;
    if ([apiParams isKindOfClass:[NSDictionary class]]) {
        part3 = [(NSDictionary *)apiParams toJsonString];
    } else if ([apiParams isKindOfClass:[NSArray class]]) {
        part3 = [(NSArray *)apiParams toJsonString];
    } else {
        return @"";
    }
    
    NSString *part4 = privateKey;
    
    NSString *beforeSign = [NSString stringWithFormat:@"%@%@%@%@", part1, part2, part3, part4];
    
    return [beforeSign APISign_md5];
}

@end


@implementation NSString (ZZZAPISignature)

- (NSString *)APISign_md5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

@end


@implementation NSDictionary (ZZZAPISignature)

- (NSString *)urlParamsStringSignature {
    // 将字典中每个key-value对，形成字符串（value经过编码，key都是string无需编码）
    NSMutableArray *keyValuesArray = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // obj不是字符串的要转化为字符串
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        // 转换为“key=value”的格式
        if ([obj length] > 0) {
            [keyValuesArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    // 排序然后使用&连接
    NSString *resultString = [[keyValuesArray sortedArrayUsingSelector:@selector(compare:)] componentsJoinedByString:@"&"];
    
    return resultString;
}

/** 字典变json */
- (NSString *)toJsonString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


@implementation NSArray (ZZZAPISignature)

/** 数组变json */
- (NSString *)toJsonString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
