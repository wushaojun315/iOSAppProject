//
//  AppDelegate+AppService.m
//  APPProject
//
//  Created by 吴少军 on 2016/11/3.
//  Copyright © 2016年 George. All rights reserved.
//

#import "AppDelegate+AppService.h"

@implementation AppDelegate (AppService)

// 做各种需求要做的事情
- (void)doAppService {
    // Bugly框架使用，应用崩溃报告
    [self regBugly];
    // 注册短信发送三方
    [self regSMSSDK];
    // 注册友盟
    [self regUmeng];
    
    // ...
    
    // 接下来还可以有推送、登录完成后的用户信息登记、应用黑名单校验等等功能可以做
}

#pragma mark - 具体操作
- (void)regBugly {
    
//    [[CrashReporter sharedInstance] enableLog:YES];
//    [[CrashReporter sharedInstance] installWithAppId:CrashReportAppKey];
//    [[CrashReporter sharedInstance] setBlockMonitorJudgementLoopTimeout:10];
//    [[CrashReporter sharedInstance] setUserId:[NSString stringWithFormat:@"schoolID=%@,userId%@,userType=%@",[HHUserInfo getSchoolId],[HHUserInfo getUserId],[HHUserInfo getUserType]]];
}

- (void)regSMSSDK {
    
//    [SMSSDK registerApp:SMSMobAppKeyTest withSecret:SMSMobAppSecretTest];
}

- (void)regUmeng {
//    
//    [UMSocialData setAppKey:UmengAppKey];
//    [UMSocialQQHandler setQQWithAppId:ShareQQAppID appKey:ShareQQAppKey url:@"http://xxx.com"];
//    [UMSocialWechatHandler setWXAppId:WetChatAppId appSecret:WetChatAppSecret url:@"http://xxx.com"];
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
}

@end
