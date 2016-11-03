//
//  ZZZNavigationController.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZNavigationController.h"
#import "AppConfigurer.h"
#import "CommonMacros.h"

@interface ZZZNavigationController ()

@end

@implementation ZZZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void)initialize
{
    if (self == [ZZZNavigationController class]) {
        // 1.appearance方法返回一个导航栏的外观对象
        // 修改了这个外观对象，相当于修改了整个项目中的外观
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        
        // 设置navigationBar栏是否半透明，若NO则颜色设置不会有色差
        navigationBar.translucent = kIsBarTranslucent;
        // 2，设置导航栏的背景颜色
        [navigationBar setBarTintColor:kNaviBarBackgroundColor];
        // 设置NavigationBarItem文字的颜色(左右两边按钮的文字颜色，返回按钮的文字和箭头的颜色)
        [navigationBar setTintColor:kNaviBackArrowColor];
        // 3.设置导航栏文字的主题
        NSShadow *shadow = [[NSShadow alloc]init];
        [shadow setShadowOffset:CGSizeZero];// 设置标题文字阴影
        [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kNaviBarTitleColor, NSFontAttributeName : kNaviBarTitleFont, NSShadowAttributeName : shadow}];
        
        // 4.修改所有UIBarButtonItem的外观
        UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
        if (SYSTEM_VERSION_EQUAL_TO(@"7.0")) {
            [barButtonItem setTintColor:kNaviBarItemTextColor];
        }else {
            // 修改UIBarButtonItem的背景图片
            //[barButtonItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            //[barButtonItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
            
            // 修改UIBarButtonItem上面的文字样式
            NSDictionary *dict =@{NSForegroundColorAttributeName : kNaviBarItemTextColor,
                                  NSShadowAttributeName : shadow};
            [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
            [barButtonItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
        }
        // 修改返回按钮样式
        //    [barButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
        
        // 5.设置状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - 重写返回按钮
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >1) {
//        viewController.navigationItem.leftBarButtonItem = [self creatBackButton];
//    }
//}
//-(UIBarButtonItem *)creatBackButton
//{
////    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
//    //或
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
//    
//    return backItem;
//}
//
//-(void)popSelf
//{
//    [self popViewControllerAnimated:YES];
//}

@end
