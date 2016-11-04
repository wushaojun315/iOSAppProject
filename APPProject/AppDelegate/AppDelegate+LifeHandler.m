//
//  AppDelegate+LifeHandler.m
//  APPProject
//
//  Created by 吴少军 on 2016/11/3.
//  Copyright © 2016年 George. All rights reserved.
//

#import "AppDelegate+LifeHandler.h"

@implementation AppDelegate (LifeHandler)

// 应用到后台
//-(void)applicationDidEnterBackground:(UIApplication *)application{
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//}

// 远程推送错误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"通知推送错误为: %@", error);
}

// 成功注册远程推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    [VTJpushTools registerDeviceToken:deviceToken];
    NSString *pushToken = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:@"deviceToken"];
}

// 注册UserNotification成功
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
}

// 收到本地通知做的处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    //[VTJpushTools showLocalNotificationAtFront:notification];
    application.applicationIconBadgeNumber = 0;
    
}

// 接受到远程推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    [VTJpushTools handleRemoteNotification:userInfo completion:completionHandler];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNotifation" object:nil];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GETNotifation"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    NSString *flag = [userInfo valueForKey:@"flag"];
//    NSString *url = [userInfo valueForKey:@"url"];
//    RDVTabBarController *tabbar = (RDVTabBarController *)self.viewController;
//    
//    if (application.applicationState == UIApplicationStateActive) {
//        
//    } else {
//        
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//}
#endif

// iOS 6.0收到通知
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
////    [VTJpushTools handleRemoteNotification:userInfo completion:nil];
//    application.applicationIconBadgeNumber = 0;
//    
//}

#pragma mark - App挑选回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.description hasPrefix:@""]) {
        //分享出去的链接打开应用
        return YES;
        
    }else{
//        return  [UMSocialSnsService handleOpenURL:url];
        return NO;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            
//            NSLog(@"支付result = %@",resultDic);
//        }];
    }
    
    
    if([url.host isEqualToString:@"alipayclient"]) {
        //支付宝钱包快登授权返回 authCode
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            
//            NSLog(@"支付result = %@",resultDic);
//        }];
    }
    
    
    
    if ([url.description hasPrefix:@"mingsi:"]) {
        
        NSString * courseId = [[url.description componentsSeparatedByString:@"id="] lastObject];
        
        //课程分享出去的链接打开应用并跳转到课程详情页面
//        RDVTabBarController *tabbar = (RDVTabBarController *)self.viewController; // 这是rootViewController
//        tabbar.selectedIndex = 3;
        //如果程序没有启动,界面是接收不到通知的,从而无法跳转
        [[NSUserDefaults standardUserDefaults] setObject:@{@"courseId":courseId} forKey:@"sharedCourseID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //如果程序启动,而且在后台(页面不会走viewWillAppear方法),发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shareCourse" object:@{@"courseId":courseId}];
    }else{
//        return  [UMSocialSnsService handleOpenURL:url];
        return NO;
    }
    
    return YES;
    
}

@end
