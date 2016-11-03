//
//  ZZZAPICacheObject.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/29.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*            API请求数据缓存的模型 存有当时获取的响应对象 处理是否过期                 */
/******************************************************************************/

#import <Foundation/Foundation.h>

@class ZZZAPIResponse;

@interface ZZZAPICacheObject : NSObject

/**
 存入的响应对象
 */
@property (nonatomic, strong, readonly) ZZZAPIResponse *cachedResponse;

/**
 获取cache对象是否已经过期的状态
 */
@property (nonatomic, assign, readonly) BOOL isOutdated;

/**
 新建的ZZAPICacheObject对象可以使用这个方法设置cachedResponse属性，过期的对象可以用这个方法更新cachedResponse
 */
- (void)updateCacheResponse:(ZZZAPIResponse *)newResponse;

@end
