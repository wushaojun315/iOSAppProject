//
//  ZZZResultModel.h
//  MVCGroupedFramework
//
//  Created by 吴少军 on 16/5/25.
//  Copyright © 2016年 George. All rights reserved.
//

/**
 *  从服务器拿到json结果后，直接转为此模型类对象
 */
#import "ZZZBaseModel.h"

@interface ZZZResultModel : ZZZBaseModel

//响应结果中的具体数据
@property (strong, nonatomic) NSObject<Optional> *body;
//响应结果中的状态码
@property (copy, nonatomic) NSString<Optional> *code;
//响应结果中的返回信息
@property (copy, nonatomic) NSString<Optional> *message;

/**
 *  当body是一个表示模型对象的字典时，使用此方法获取数据模型对象
 */
- (id)getObjectInBodyWithClass:(Class)aClass;

/*
*  使用此方法获取数据模型对象,使用于如下情况
*  json结构如下：
*  {
*      body:{
*          key1 : {},
*          key2 : {},
*          key3 : {}
*      }
*  }
*/
- (id)getObjectInBodyWithClass:(Class)aClass  byKey:(NSString *)key;

/**
 *  当body是一个表示模型对象的数组时，使用此方法获取数据模型对象数组
 *  json结构如下：
 *  {
 *      body:[
 *          {},
 *          {},
 *          {}
 *      ]
 *  }
 */
- (NSArray *)getObjectsArrayInBodyWithClass:(Class)aClass;

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
 */
- (NSArray *)getObjectsArrayInBodyWithClass:(Class)aClass  byKey:(NSString *)key;

@end
