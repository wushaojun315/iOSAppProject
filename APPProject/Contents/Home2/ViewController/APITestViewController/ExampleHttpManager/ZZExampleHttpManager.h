//
//  ZZExampleHttpManager.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/31.
//  Copyright © 2016年 George. All rights reserved.
//


/**
 网络框架使用说明：
 1，确定API的服务端，server有如下要求：（见ZZZExampleServer）
    i:首先新建一个新的server类，要继承ZZZBaseServer
    ii:返回服务器主机地址的方法是必须要实现的,并且返回的主机地址注意要使用"/"结尾
    iii:如果该服务器需要证书验证，那么重写init方法，在init方法中设置needVerification为YES（默认父类中是关闭的，也就是不要验证），然后重写publicKey和privateKey的getter方法设置公共私密的key；
        如果服务器不需要证书验证，那么这几步重写都不需要操作
    iiii:在子类中设定该服务器的apiVersion和commonHTTPHeader（如果没有就不用了，apiVersion这个属性一般用不到）
    iiiii：在ZZZNetworkConfigurer中增加新的serverIdentifier，并在ZZZServerFactory中新加根据新id创建对应server的代码
 
 2，其次子类Manager中（一个manager对应一个api）:(见本类)
    ①：新建子manager，继承自ZZZBaseAPIManager,并且必须遵守ZZZAPIManagerProtocol协议
        初始化时可以在init方法中设置自己是遵守某些协议的，所以设置一些属性，如：
            self.validator = self;
            self.paramSource = self;  //等等……
 
        实现协议方法：
            - (NSString *)serverIdentifier;  // 定义在ZZZNetworkingConfigurer中
            - (NSString *)subURLString;
            - (ZZZAPIManagerRequestType)requestType;
        视情况看是否需要实现：
        - (BOOL)shouldCache;  // 当API请求需要缓存时，需要实现这个方法返回YES，父类默认是NO（不缓存）
        - (NSDictionary *)reformParams:(NSDictionary *)params; // 需要重新构造参数的情况下需要实现
    ②：如果要校验请求参数和响应数据是否正确的话，必须要有validator，可以遵守ZZZAPIManagerValidateProtocol，自身判断参数返回值是否正确
    // 以下都是可选
    ③：如果接口的参数是固定的，那么可以遵守ZZZAPIParamSourceProtocol协议自身提供参数（比如刷新请求的时候）
    ④：另外也可以遵守ZZZAPIDataReformerProtocol和ZZZAPIInterceptProtocol协议，自身实现相关功能
 */


/**
 下面说一说定义的几个协议的用处：
 ZZZAPICallbackProtocol协议：由viewController实现
    通常由viewController实现，在网络请求结束之后会调用响应成功或者失败的方法
 
 ZZZAPIParamSourceProtocol协议:通常由viewController实现（参数固定时，可以由manager遵守实现）
    在viewController中实现代理方法，提供网络请求需要用到的参数（一般是需要在界面输入啥的）
 
 ZZZAPIManagerValidateProtocol协议：可以由viewController遵守也可以由manager遵守还可以用其他类遵守
    可以由任意类遵守，实现其中校验参数和返回值的方法。由viewController遵守实现的话可以方便更新UI提示
 
 ZZZAPIDataReformerProtocol协议：可以由manager实现也可以由其他自定义的类实现（然后在类中规格化得到的响应数据）
    可以由任意类遵守，实现其中的代理方法规范化响应数据
 
 ZZZAPIManagerProtocol协议：ZZZAPIBaseManager的子类必须实现这一协议，一般也是有子manager来遵守
    需要实现@required的必须方法，视情况实现其他方法
    - (BOOL)shouldCache;  // 当API请求需要缓存时，需要实现这个方法返回YES，父类默认是NO（不缓存）
    - (NSDictionary *)reformParams:(NSDictionary *)params; // 需要重新构造参数的情况下需要实现
 
 ZZZAPIInterceptProtocol协议：可以由manager、viewController或者其他任何类遵守，实现代理方法即可
    那个类想实现代理方法，在请求发送前后等时期对请求发送进行拦截的时候就可以遵守这个类，然后实现了
 */

#import "ZZZBaseAPIManager.h"

@interface ZZExampleHttpManager : ZZZBaseAPIManager<ZZZAPIManagerProtocol>

@end
