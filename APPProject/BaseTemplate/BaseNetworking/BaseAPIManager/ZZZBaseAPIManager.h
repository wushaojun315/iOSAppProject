//
//  ZZZBaseAPIManager.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*        具体APIManager的基类 子类需要实现ZZZAPIManagerProtocol中的必要方法        */
/******************************************************************************/

#import "ZZZNetworkingProtocol.h"
#import "ZZZNetworkConfigurer.h"

@interface ZZZBaseAPIManager : NSObject

/**
 请求成功或者失败之后的回调，一般由viewController实现，可以在代理方法中，通过manager调用reformData方法，直接拿到可用的数据
 */
@property (nonatomic, weak) id<ZZZAPICallbackProtocol> delegate;

/**
 请求的参数提供者，一般由viewController实现代理方法提供，如果参数固定可以由子manager自己提供（子manager初始化时，设置slef.paramSource = self;）
 */
@property (nonatomic, weak) id<ZZZAPIParamSourceProtocol> paramSource;

/**
 这个是校验器，如果需要对传入的参数和传回的返回值进行检验的话，需要通过这个对象实现代理方法完成
 */
@property (nonatomic, weak) id<ZZZAPIManagerValidateProtocol> validator;

/**
 这个是拦截器，拦截器代理通过实现相应方法，可以实现在请求发送前、发送后，成功/失败前，成功/失败后进行响应的拦截（先做拦截器里面的事，如果有的返回NO，那就意味着不继续进行了），
 */
@property (nonatomic, weak) id<ZZZAPIInterceptProtocol> interceptor;
//里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) NSObject<ZZZAPIManagerProtocol> *child;

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要拿到响应对象直接从response中获取即可，其中包含了errortype
 */
@property (nonatomic, strong) ZZZAPIResponse *response;

/**
 取消这个apiManager发出的请求任务
 */
- (void)cancelAllRequests;
/**
 取消特定ID的请求任务
 */
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

/**
 APIManager的两种请求策略:
 如果APIManager正在加载数据，需要忽略新来的请求===
    如：当滚动tableView的时候会频繁触发加载下一页的事件，如果当前APIManager正在加载下一页，那么就不需要再发送加载请求
 如果APIManager正在加载数据，需要取消过去已经发送的请求===
    如：切换筛选条件的时候，如果前一次筛选条件的请求正在进行中，那么就应当取消前一次请求，执行现在的请求
 */
@property (nonatomic, assign, readonly) BOOL isLoading;

/**
 需要取消旧请求，发起新请求的时候，需要以此获得正在运行的请求的id，才能取消
 */
@property (nonatomic, assign, readonly) NSInteger lastRequestId;

/**
 上述两种请求策略：（补充：其实突然发现用拦截器来做更好一点，拦截器既可以拿到manager的isLoading状态，又可以拿到前后两次的参数，对比是否一样）
 子类需要重载requestDataFromAPI方法，根据父类提供的isLoading的状态，结合当前API应该使用的请求策略来决定应该不追加请求发送，还是应该取消当前isLoading的请求并发送新请求
 如：- (NSInteger)requestDataFromAPI {
        // 取消当前请求，重新发起请求的模式
        if (self.isLoading) {
            [self cancelRequestWithRequestId:self.lastRequestId];
            return [super requestDataFromAPI];
        } else {
            return [super requestDataFromAPI];
        }
 
        // 继续当前请求，不重复发送新的请求
        if (self.isLoading) {
            return -1;
        } else {
            return [super requestDataFromAPI];
        }
    }
 */
/**
 尽量使用requestDataFromAPI这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
 */
- (NSInteger)requestDataFromAPI;

/**
 把缓存中关于这一个API的缓存都清除--未实现，只能将缓存全部清空，无法清特定api的缓存数据
 */
//- (void)cleanCacheForAPIManager;

/**
 这个是manager调用，用来获取可用数据的方法，reformer需要实现ZZZAPIDataReformerProtocol的代理方法将response中的数据转化为可以直接使用的样子
 */
- (id)fetchDataWithReformer:(id<ZZZAPIDataReformerProtocol>)reformer;

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的（如果需要重载，那这些方法就需要在.h文件中开放）
 所有重载的方法，都需要return [super ....];这样才能保证调用到拦截器代理的拦截代码，以拦截器返回值作为最终返回值（如果有拦截器的话）
 这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(ZZZAPIResponse *)response;
- (void)afterPerformSuccessWithResponse:(ZZZAPIResponse *)response;

- (BOOL)beforePerformFailureWithResponse:(ZZZAPIResponse *)response;
- (void)afterPerformFailureWithResponse:(ZZZAPIResponse *)response;
// 返回yes，才能真正开始发送请求
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

/*
 用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
 CTAPIBaseManager会先调用这个函数，然后才会调用到 id<CTAPIManagerValidator> 中的 manager:isCorrectWithParamsData:
 所以这里返回的参数字典还是会被后面的验证函数去验证的。
 
 假设同一个翻页Manager，ManagerA的paramSource提供page_size=15参数，ManagerB的paramSource提供page_size=2参数
 如果在这个函数里面将page_size改成10，那么最终调用API的时候，page_size就变成10了。然而外面却觉察不到这一点，因此这个函数要慎用。
 
 这个函数的适用场景：
 当两类数据走的是同一个API时，为了避免不必要的判断，我们将这一个API当作两个API来处理。
 那么在传递参数要求不同的返回时，可以在这里给返回参数指定类型。
 */
// 这个一般不用重载，因为ZZZAPIManagerProtocol代理里面有这个可选方法
//- (NSDictionary *)reformParams:(NSDictionary *)params;

@end
