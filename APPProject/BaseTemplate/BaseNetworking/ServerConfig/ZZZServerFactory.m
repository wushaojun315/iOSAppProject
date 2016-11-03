//
//  ZZZServerFactory.m
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZServerFactory.h"

#import "ZZZNetworkConfigurer.h"
#import "ZZZExampleServer.h"

@interface ZZZServerFactory ()

@property (nonatomic, strong) NSMutableDictionary *serversSaved;

@end

@implementation ZZZServerFactory

#pragma mark - 懒加载
- (NSMutableDictionary *)serversSaved {
    if (_serversSaved == nil) {
        _serversSaved = [[NSMutableDictionary alloc] init];
    }
    return _serversSaved;
}

#pragma mark - 生命周期
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static ZZZServerFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZZZServerFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 公共方法
// 获取特定server
- (ZZZBaseServer *)serverWithIdentifier:(NSString *)identifier {
    // 看当前是否存有对应的server，没有的话就新建存起来
    if (self.serversSaved[identifier] == nil) {
        self.serversSaved[identifier] = [self createServerWithIdentifier:identifier];
    }
    return self.serversSaved[identifier];
}

#pragma mark - 私有方法
// 根据不同的identifier生产不同的server
- (ZZZBaseServer *)createServerWithIdentifier:(NSString *)identifier {
    
    if ([identifier isEqualToString:kAPIServerExampleServerIdentifier]) {
        return [[ZZZExampleServer alloc] init];
    }
    return nil;
}

@end
