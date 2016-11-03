//
//  ZZZResultModel.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 16/5/25.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZResultModel.h"
#import "CommonMacros.h"

@implementation ZZZResultModel

//后台返回与预设不同时，需要设置keyMapper来统一（如后台返回的是result而不是body）
+(JSONKeyMapper *)keyMapper {
    
    NSDictionary *keyMapperDict = @{@"result" : @"body"};
    JSONKeyMapper *keyMapper = [[JSONKeyMapper alloc] initWithDictionary:keyMapperDict];
    
    return keyMapper;
}

/**
 *  当body是一个表示模型对象的字典时，使用此方法获取数据模型对象
 *
 *  @param aClass 需要获取模型对象的类
 *
 *  @return 返回获得的模型对象
 */
- (id)getObjectInBodyWithClass:(Class)aClass {
    
    id object;
    //body非空并且aClass存在
    if(aClass && !isNull(self.body)) {
        __autoreleasing NSError *err = nil;
        object = [[aClass alloc] initWithDictionary:(id)self.body error:&err];
        
        if(err){
            [self printErrorInfoWithError:err];
        }
    }
    
    return object;
}

/**
 *  使用此方法获取数据模型对象,使用于如下情况
 *  json结构如下：
 *  {
 *      body:{
 *          key1 : {},
 *          key2 : {},
 *          key3 : {}
 *      }
 *  }
 *
 *  @param aClass 需要获取模型对象数组的类
 *  @param key    需要的模型数组对应的key
 *
 *  @return 返回获得的模型对象数组
 */
- (id)getObjectInBodyWithClass:(Class)aClass  byKey:(NSString *)key {
    
    id object;
    //body非空并且aClass存在
    if(aClass && !isNull(self.body)) {
        __autoreleasing NSError *err = nil;
        if ([self.body isKindOfClass:[NSDictionary class]]) {
            //获取key对应的表示数据模型对象的字典
            NSDictionary *jsonDict = [(NSDictionary*)self.body objectForKey:key];
            //根据得到的字典，得到模型对象
            object = [[aClass alloc] initWithDictionary:jsonDict error:&err];
        }
        
        if(err){
            [self printErrorInfoWithError:err];
        }
    }
    
    return object;
}

/**
 *  当body是一个表示模型对象的数组时，使用此方法获取数据模型对象数组
 *  json结构如下：
 *  {
 *      body:[
 *          {},
 *          {},
            {},
 *      ]
 *  }
 *
 *  @param aClass 需要获取模型对象数组的类
 *
 *  @return 返回获得的模型对象数组
 */
- (NSArray *)getObjectsArrayInBodyWithClass:(Class)aClass {
    
    NSArray *objectsArray;
    //body非空并且aClass存在
    if(aClass && !isNull(self.body)) {
        __autoreleasing NSError *err = nil;
        objectsArray = [aClass arrayOfModelsFromDictionaries:(id)self.body error:&err];
        
        if(err){
            [self printErrorInfoWithError:err];
        }
    }
    
    return objectsArray;
}

/**
 *  使用此方法获取数据模型对象数组,使用于如下情况
 *  json结构如下：
 *  {
 *      body:{
 *          key1 : [
 *                  {},
 *                  {},
 *                  {}
 *          ],
 *          key2 :[
 *                  {},
 *                  {}
 *          ],
 *          key3 : [
 *                  {},
 *                  {},
 *                  {},
 *                  {}
 *          ]
 *      }
 *  }
 *
 *  @param aClass 需要获取模型对象数组的类
 *  @param key    需要的模型数组对应的key
 *
 *  @return 返回获得的模型对象数组
 */
- (NSArray *)getObjectsArrayInBodyWithClass:(Class)aClass  byKey:(NSString *)key {
    
    NSArray *objectsArray;
    //body非空并且aClass存在
    if(aClass && !isNull(self.body)) {
        __autoreleasing NSError *err = nil;
        if ([self.body isKindOfClass:[NSDictionary class]]) {
            //获取key对应的数组
            NSArray *jsonArr = [(NSDictionary*)self.body objectForKey:key];
            //根据得到的数组，获得模型对象数组
            objectsArray = [aClass arrayOfModelsFromDictionaries:jsonArr error:&err];
        }
        
        if(err){
            [self printErrorInfoWithError:err];
        }
    }
    
    return objectsArray;
}

/**
 *  用于输出错误信息
 *
 *  @param error NSError对象
 */
- (void)printErrorInfoWithError:(NSError *)error {
    NSDictionary *errUserInfo = [error userInfo];
    if ([[errUserInfo allKeys] containsObject:NSLocalizedDescriptionKey]) {
        DLog(@"错误信息:%@",errUserInfo[NSLocalizedDescriptionKey]);
    } else {
        DLog(@"错误描述:%@", error.description);
    }
}

@end
