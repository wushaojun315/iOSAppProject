//
//  ZZZNetworkingProtocol.h
//  iOS-LearningRoad
//
//  Created by 吴少军 on 2016/10/27.
//  Copyright © 2016年 George. All rights reserved.
//

/******************************************************************************/
/*                         网络框架使用需要的几个协议                              */
/******************************************************************************/

#import <Foundation/Foundation.h>

@class ZZZBaseAPIManager;
@class ZZZAPIResponse;

typedef NS_ENUM (NSUInteger, ZZZAPIManagerRequestType){
    ZZZAPIManagerRequestTypeGet,
    ZZZAPIManagerRequestTypePost,
    ZZZAPIManagerRequestTypePut,
    ZZZAPIManagerRequestTypeDelete
};

/******************************************************************************/
/*                          ZZZAPICallbackProtocol                            */
/*                                                                            */
/*               API接口请求成功后的回调，一般为viewController实现                  */
/******************************************************************************/

@protocol ZZZAPICallbackProtocol <NSObject>
@required
- (void)didSuccessedOnCallingAPIWithManager:(ZZZBaseAPIManager *)manager;
- (void)didFailedOnCallingAPIWithManager:(ZZZBaseAPIManager *)manager;
@end


/******************************************************************************/
/*                         ZZZAPIDataReformerProtocol                         */
/*                                                                            */
/*                  格式化从API接口中获得的数据，让其可以直接使用                     */
/******************************************************************************/

/*
 重组数据的场景：
 1.当不同的controller需要从同一个manager里面获得数据来进行不同的操作的时候，他们需要的数据格式可能不一样，比如列表页controller可能需要array型的数据，而单页只需要dictionary型的数据，那么此时就由 需要使用数据的controller 提供 reformer，让manager根据reformer中的方法进行重组来获得数据。
 
 2.我们现有的代码里面，有些时候是将manager返回的数据map成一个对象，有的时候并没有这么做，甚至将来可能有其它的数据使用者对数据结构有新的要求。那么，在上层将数据传递到下层接收者的时候，上层会很困惑应该传递什么类型的数据。
 以前为了解决这个问题，是让下层接收者接收id类型的数据，然后自己判断如何使用。在数据类型比较少的时候还能够做判断，当数据类型多的时候，判断就会变得很困难。
 现在如果要解决这个问题，则需要由下层接收者提供一个reformer交给上层，上层拿了下层提供的reformer来重组数据，并把重组的数据交给下层，就能保证提供的数据正是是下层需要的。
 
 3.reformer在运行层面上的本质是业务逻辑的插入，这个业务逻辑是由需求方提供的，由controller负责把业务逻辑提交给manager执行。
 
 举个例子：
 app需要在房源单页里面获得电话号码，这个电话号码的生成是有一个业务逻辑的：
 1.先要判断提供这个房源的人是不是经纪人，如果是经济人，则输出经纪人的电话号码
 2.如果是个人，则要判断个人是否公开电话号码，
 （1）如果公开，则显示个人的电话号码
 （2）如果不公开，则显示400电话号码。
 
 由此可见，这个业务逻辑的使用场景相对频繁，且相对复杂，而且比较通用（在所有租房要显示电话号码的地方都要用到）。那么如何使用reformer来实现这样的功能呢？
 
 接下来先说一个规范：controller负责调用manager获得数据，然后交给view去渲染。
 
 如果以前要实现这样的功能，有三种方法可以实现：
 1.controller调用manager获得数据，然后解析出电话号码，交给view。
 2.controller把manager的数据全部拿过来，交给view去解析出电话号码并显示。这是我们目前比较常用的做法。
 3.manager中直接做好获得电话号码的逻辑，由controller从manager中获取电话号码然后交给view。我们的项目中也有些地方是这么做的。
 
 第1种做法不评价，相信大家都明白缺点在哪儿。评价一下第2种做法：
 第一点，api的数据是有可能变的。当一个项目里面很多地方都需要显示电话号码的时候（收藏、列表、单页），各个view里面内联了同一套逻辑，当API出现修改时，需要到每个view的地方都要修改一次，会变的比较麻烦。
 第二点，由于逻辑被硬编码进入view，在其它的view需要电话号码的时候，只能从已经做好逻辑的view里面复制代码，这样就产生了代码冗余，降低了项目的可维护性。
 
 评价一下第3种做法：
 第3种做法是相对规范的，也解决了上述第2种方法中的两个问题。mananger中包含了业务逻辑，然后由controller去调用获得数据交给view。其中也有一些地方美中不足：
 1.manager会变得非常庞大，因为它集成了很多业务逻辑，修改和维护的时候定位代码会变得困难。
 2.如果不同的manager中有相同的业务逻辑，虽然各个manager提供的基础数据不同，但都是做一个相同的业务逻辑，这部分也会产生一定的冗余。对于产品来说，新房租房二手房的业务逻辑都是一样的，修改的时候可能都会有修改，那么我们就要分别到二手房，新房，租房的manager中修改同一套业务逻辑，这就是一种冗余。
 3.有的时候manager处理业务逻辑的时候也需要外部提供一些辅助数据，为了满足这样的需求，manager中会设置个别属性来提供冗余数据，但由于manager提供不止一种业务逻辑的处理，随之而来的就是manager提供业务逻辑所需要的辅助属性就会非常多，会降低代码的可维护性。
 
 于是我引入了reformer。reformer只能由需求方提供。具体可以参看后面的代码样例。
 reformer在这个角度上讲是业务逻辑的一种封装，它能够根据不同的manager以及不同的数据来处理业务逻辑，由于reformer是个相对独立的对象，它可以被每一个业务需求方引入，然后交给controller，controller拿着这个reformer去调用manager，并且把返回的数据交给view。这么做的好处就是把view和manager做了解耦，同时同样的业务逻辑只会在同一个reformer里面，这样就不会产生代码冗余，代码定位和代码维护都会非常方便。它是这么解决上述第3种方法的三个弊端的：
 1.由于业务逻辑被独立抽出来形成了一个对象，因此manager不会变得非常庞大，mananger只需要做好向API请求数据就可以了。在维护一个业务逻辑时，直接去维护这个业务逻辑对应得reformer就可以了，定位代码和维护代码都变得非常容易且独立。
 2.因为reformer能够区分不同的manager，在做相同的业务逻辑的时候可以在reformer内部调用不同的方法。注意，reformer其实也是一个对象。由于业务逻辑被独立出来，不同业务逻辑之间的耦合度被降低，同时相同业务逻辑之间的代码重用性也得到了提高，降低了代码冗余度。
 3.因为reformer自己本身也是一个对象，且一个reformer对应一个业务逻辑，那么就能够保证一个业务逻辑中所需要的辅助数据都能够在reformer中找到并设置。增强了代码的可维护性。
 
 下面描述一下使用reformer的流程。
 1.controller获得view的reformer
 2.controller给获得的reformer提供一些辅助数据，如果没有辅助数据，这一步可以省略。
 3.controller调用manager的 fetchDataWithReformer: 获得数据
 4.将数据交给view
 
 如何使用reformer：
 ContentRefomer *reformer = self.topView.contentReformer;    //reformer是属于需求方的，此时的需求方是topView
 reformer.contentParams = self.filter.params;                //如果不需要controller提供辅助数据的话，这一步可以不要。
 id data = [self.manager fetchDataWithReformer:reformer];
 [self.view configWithData:data];
 
 */
@protocol ZZZAPIDataReformerProtocol <NSObject>
@required
/*
 比如同样的一个获取电话号码的逻辑，二手房，新房，租房调用的API不同，所以它们的manager和data都会不同。
 即便如此，同一类业务逻辑（都是获取电话号码）还是应该写到一个reformer里面去的。这样后人定位业务逻辑相关代码的时候就非常方便了。
 
 代码样例：
 - (id)reformResposeInManager:(ZZZBaseAPIManager *)manager
 {
 id data = manager.receivedResponseObject;
 if ([manager isKindOfClass:[xinfangManager class]]) {
 return [self xinfangPhoneNumberWithData:data];      //这是调用了派生后reformer子类自己实现的函数，别忘了reformer自己也是一个对象呀。
 //reformer也可以有自己的属性，当进行业务逻辑需要一些外部的辅助数据的时候，
 //外部使用者可以在使用reformer之前给reformer设置好属性，使得进行业务逻辑时，
 //reformer能够用得上必需的辅助数据。
 }
 
 if ([manager isKindOfClass:[zufangManager class]]) {
 return [self zufangPhoneNumberWithData:data];
 }
 
 if ([manager isKindOfClass:[ershoufangManager class]]) {
 return [self ershoufangPhoneNumberWithData:data];
 }
 }
 */
- (id)reformResposeInManager:(ZZZBaseAPIManager *)manager;
@end


/******************************************************************************/
/*                    ZZZAPIManagerValidateProtocol                           */
/*                                                                            */
/*                校验器  用于校验API请求的参数和返回值是否正确                       */
/******************************************************************************/

/*
 使用场景：
 当我们确认一个api是否真正调用成功时，要看的不光是status，还有具体的数据内容是否为空。由于每个api中的内容对应的key都不一定一样，甚至于其数据结构也不一定一样，因此对每一个api的返回数据做判断是必要的，但又是难以组织的。
 为了解决这个问题，manager有一个自己的validator来做这些事情，一般情况下，manager的validator可以就是manager自身。
 
 1.有的时候可能多个api返回的数据内容的格式是一样的，那么他们就可以共用一个validator。
 2.有的时候api有修改，并导致了返回数据的改变。在以前要针对这个改变的数据来做验证，是需要在每一个接收api回调的地方都修改一下的。但是现在就可以只要在一个地方修改判断逻辑就可以了。
 3.有一种情况是manager调用api时使用的参数不一定是明文传递的，有可能是从某个变量或者跨越了好多层的对象中来获得参数，那么在调用api的最后一关会有一个参数验证，当参数不对时不访问api，同时自身的errorType将会变为ZZZAPIManagerErrorTypeParamsError。这个机制可以优化我们的app。
 
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 */
@protocol ZZZAPIManagerValidateProtocol <NSObject>
@required
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(ZZZBaseAPIManager *)manager isCorrectWithCallBackResponse:(ZZZAPIResponse *)response;

/*
 
 “
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 ”
 
 所以不要以为这个params验证不重要。当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 
 */
- (BOOL)manager:(ZZZBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end


/******************************************************************************/
/*                      ZZZAPIParamSourceProtocol                             */
/*                                                                            */
/*              获取API请求所需要的参数，一般由viewController遵守                   */
/******************************************************************************/


@protocol ZZZAPIParamSourceProtocol <NSObject>
@required
- (NSDictionary *)paramsForAPIManager:(ZZZBaseAPIManager *)manager;
@end


/******************************************************************************/
/*                          ZZZAPIManagerProtocol                             */
/*                                                                            */
/*                ZZZBaseAPIManager的派生类必须符合这个protocol                   */
/******************************************************************************/

@protocol ZZZAPIManagerProtocol <NSObject>

@required
/**
 返回服务器的identifier，以此得到特定的server，包含有主机地址、公共头、签名的公共私有key等信息
 */
- (NSString *)serverIdentifier;

/**
 返回请求路径中除了主机外的部分
 */
- (NSString *)subURLString;

- (ZZZAPIManagerRequestType)requestType;

// used for pagable API Managers mainly
@optional
/**
 确定本接口是否需要缓存，默认为NO（需要缓存时，子类需要实现这一代理方法返回YES）
 */
- (BOOL)shouldCache;
- (NSDictionary *)reformParams:(NSDictionary *)params;

@end


/******************************************************************************/
/*                        ZZZAPIInterceptProtocol                             */
/*                                                                            */
/*        拦截器 在执行下一操作之前先进行其他操作 返回值可以决定能否执行原定代码           */
/******************************************************************************/

@protocol ZZZAPIInterceptProtocol <NSObject>

@optional
- (BOOL)manager:(ZZZBaseAPIManager *)manager beforePerformSuccessWithResponse:(ZZZAPIResponse *)response;
- (void)manager:(ZZZBaseAPIManager *)manager afterPerformSuccessWithResponse:(ZZZAPIResponse *)response;

- (BOOL)manager:(ZZZBaseAPIManager *)manager beforePerformFailWithResponse:(ZZZAPIResponse *)response;
- (void)manager:(ZZZBaseAPIManager *)manager afterPerformFailWithResponse:(ZZZAPIResponse *)response;

- (BOOL)manager:(ZZZBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(ZZZBaseAPIManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end
