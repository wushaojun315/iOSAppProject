//
//  ZZZAPIResponse.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/28.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*                    发送请求之后的响应数据包装成统一的样子                         */
/******************************************************************************/

#import <Foundation/Foundation.h>

/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。（安居客PAD就有这样的需求，sigh～）
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager中的response属性已经帮你搞定了。。
 */
typedef NS_ENUM (NSUInteger, ZZZAPIManagerResultStautus){
    ZZZAPIManagerResultStautusDefault,         // 不明闲置状态
    ZZZAPIManagerResultStautusRequestIntercepted,       // 没有产生过API请求，比如拦截器拦截了请求，在请求还未发生时就已经结束了，就是这个状态
    ZZZAPIManagerResultStautusSuccessWithRightData,       // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    ZZZAPIManagerResultStautusSuccessWithWrongData,     // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    ZZZAPIManagerResultStautusParamsError,   // 参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    ZZZAPIManagerResultStautusTimeout,       // 请求超时。ZZZNetworkConfigurer设置的是20秒超时，具体超时时间的设置请自己去看ZZZNetworkConfigurer的相关代码。
    ZZZAPIManagerResultStautusNoNetWork,      // 网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    ZZZAPIManagerResultStautusOtherError     // 网络请求失败返回错误信息，除了能判断出是请求超时的错误外，都作为其他错误处理
};

@interface ZZZAPIResponse : NSObject

/**
 该响应是否是请求数据失败的响应，以及其错误类型，初始化时获取值（默认为NO，只有在失败后，生成的响应对象这个属性才是YES）
 */
@property (nonatomic, assign, getter=isRequestFailed, readonly) BOOL requestFailed;

/**
 请求得到响应了，设置请求的结果类型（是否请求成功，如果失败是那种错误类型）
 */
@property (nonatomic, assign, readonly) ZZZAPIManagerResultStautus requestResultStatus;

/**
 请求着陆后要将保存在队列中的任务删除，需要使用到requestId（是key），初始化时获取值
 */
@property (nonatomic, assign, readonly) NSInteger requestId;

/**
 接收到的responseObject，初始化时获取值
 */
@property (nonatomic, copy, readonly) id receivedResponseObject;

/**
 当前响应是否是缓存起来了的，一般在要缓存的时候将这个状态更新为YES
 */
@property (nonatomic, assign, readonly) BOOL isCache;

/**
 响应对应请求所用到的参数，在保存到缓存生成唯一key时需要用到，在请求成功之后才会给响应对象加上这个属性，因为只有响应成功才有可能缓存，才会需要它生成唯一的key
 */
@property (nonatomic, copy, readonly) NSDictionary *requestParam;

/**
 这个初始化方法一般用在请求还未发生时就已经确定失败的情况，比如参数错误、无网络连接等情况
 */
- (instancetype)initWithFailureType:(ZZZAPIManagerResultStautus)requestResultStatus requestId:(NSInteger)requestId;


/**
 这个初始化方法用于网络请求失败之后设置，会根据error信息设置对象的requestResultStatus属性
 */
- (instancetype)initWithResponseObject:(id)responseObject requestId:(NSInteger)requestId error:(NSError *)error;

/**
 这个初始化方法用于网络请求成功之后设置，failureType属性默认为ZZZAPIManagerResultStautusSuccessWithRightData，当校验时发现数据错误时可以更新为ZZZAPIManagerResultStautusSuccessWithWrongData
 */
- (instancetype)initSuccessResponseWithResponseObject:(id)responseObject requestId:(NSInteger)requestId;


/**
 需要更新响应的失败类型的情况，如请求成功了，但是校验时发现返回的数据不对
 */
- (void)updateRequestResultStatusWithStatus:(ZZZAPIManagerResultStautus)newStatus;


/**
 对外开放的requestParam属性设置方法，属性为只读
 */
- (void)setRequestParam:(NSDictionary *)requestParam;

/**
 更新响应对象的缓存状态，一般用在要将响应对象缓存时，将isCache属性设置为真
 */
- (void)updateCachedStatus:(BOOL)isCached;

@end
