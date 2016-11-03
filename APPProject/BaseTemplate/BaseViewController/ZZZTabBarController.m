//
//  ZZZTabBarController.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZTabBarController.h"
#import "AppConfigurer.h"

@interface ZZZTabBarController ()

@end

@implementation ZZZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void)initialize
{
    if (self == [ZZZTabBarController class]) {
        UITabBar *tabBar = [UITabBar appearance];
        //设置tab栏是否半透明，若NO则颜色设置不会有色差
        tabBar.translucent = kIsBarTranslucent;
        // 设置选中时显示的颜色
        tabBar.tintColor = kSelectedTabTextColor;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];  backView.backgroundColor = kTabBarBackgroundColor;
        [tabBar insertSubview:backView atIndex:0];
        //tabBar.opaque = NO;
    }
}

@end
