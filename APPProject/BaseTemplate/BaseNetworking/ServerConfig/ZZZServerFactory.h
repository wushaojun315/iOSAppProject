//
//  ZZZServerFactory.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*     每个服务端只需要初始化一次，然后保存在服务器工厂中，需要时使用对应的key取出即可      */
/******************************************************************************/

#import <Foundation/Foundation.h>

@class ZZZBaseServer;

@interface ZZZServerFactory : NSObject


/**
 单例，存取都是使用同一个工厂

 @return 一个serverFactory的单例
 */
+ (instancetype)sharedInstance;

/**
 使用key值获取对应的服务器

 @param identifier 某个server对应的key值

 @return key值对应的server
 */
- (ZZZBaseServer *)serverWithIdentifier:(NSString *)identifier;

@end
