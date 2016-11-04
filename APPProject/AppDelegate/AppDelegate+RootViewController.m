//
//  AppDelegate+RootViewController.m
//  APPProject
//
//  Created by 吴少军 on 2016/11/3.
//  Copyright © 2016年 George. All rights reserved.
//

#import "AppDelegate+RootViewController.h"
#import "CommonMacros.h"
#import "HomeViewController0.h"
#import "HomeViewController1.h"
#import "HomeViewController2.h"
#import "ZZZTabBarController.h"
#import "ZZZNavigationController.h"

static NSString *kIsAppFirstOpenKey = @"isAppFirstOpen";
static NSInteger kGuidePageNumber = 4;

@interface AppDelegate ()<UIScrollViewDelegate>

@end

@implementation AppDelegate (RootViewController)

- (void)setUpRootViewController {
    // 如果对应能取到值，说明不是第一次使用app
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIsAppFirstOpenKey]) {
        // 不是第一次打开，直接进入主页面或者登陆
        [self setNormalRootVC];
    } else {
        // 第一次打开，可能有什么引导页什么的
        UIViewController *loadingGuidePageVC = [[UIViewController alloc] init];
        self.window.rootViewController = loadingGuidePageVC;
        // 往这个页面里加引导图片
        [self setGuidePage];
    }
}

#pragma mark - 第一次进入应用，打开引导页
// 往rootViewController中添加引导页
- (void)setGuidePage {
    // 使用scrollView加图片或者其他的什么的
    UIScrollView *guideScrollView = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    guideScrollView.pagingEnabled = YES;
    guideScrollView.delegate = self;
    guideScrollView.showsVerticalScrollIndicator = NO;
    guideScrollView.showsHorizontalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:guideScrollView];
    
    NSArray *imageNamesArray = @[@"guidePageImage01.jpg", @"guidePageImage02.jpg", @"guidePageImage03.jpg", @"guidePageImage04.jpg"];
    
    for (NSInteger i = 0; i < imageNamesArray.count; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:imageNamesArray[i]];
        imageView.userInteractionEnabled = YES; // 最后面要点击按钮，进入应用
        [guideScrollView addSubview:imageView];
        // 最后一张图要加按钮
        if (i == imageNamesArray.count - 1) {
            
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            enterButton.frame = CGRectMake(SCREEN_WIDTH /2 - 50, SCREEN_HEIGHT - 100, 100, 45);
            enterButton.backgroundColor = [UIColor yellowColor];
            [enterButton setTitle:@"开始体验" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            enterButton.layer.borderWidth = 1;
            enterButton.layer.borderColor = [UIColor yellowColor].CGColor;
            [enterButton addTarget:self action:@selector(goNormalRootVC) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterButton];
        }
    }
    // 设置滚动视图的内容size
    guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imageNamesArray.count, SCREEN_HEIGHT);
}

// 引导页过了之后，更新状态（已经不是第一次打开了），然后进入正常的页面
- (void)goNormalRootVC {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"App already opened!" forKey:kIsAppFirstOpenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 状态更新完成之后可以开始设置真正的rootViewController了
    [self setNormalRootVC];
}

#pragma mark - scrollView的代理方法，滑动超过一定距离之后也会直接跳转主页面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滑动到最后面，再拉动三分之一，就跳到主页
    if (scrollView.contentOffset.x > SCREEN_WIDTH * (kGuidePageNumber - 1) + 0.3 * SCREEN_WIDTH) {
        [self goNormalRootVC];
    }
}

#pragma mark - 设置真正的rootViewController
- (void)setNormalRootVC {
    
    NSArray *nameArray = @[@"首页", @"辅助功能", @"我的"];
    
    NSArray *imageArray = @[@"homeOne_unselected", @"homeTwo_unselected", @"homeTxree_unselected"];
    
    NSArray *selectedImageArray = @[@"homeOne_selected", @"homeTwo_selected", @"homeTxree_selected"];
    
    NSArray *viewControllerArray = @[[[HomeViewController0 alloc] init],
                                     [[HomeViewController1 alloc] init],
                                     [[HomeViewController2 alloc] init]];
    
    ZZZTabBarController *tabBarController = [[ZZZTabBarController alloc] init];
    
    for (int index = 0; index < nameArray.count; index ++) {
        
        UIViewController *viewController = viewControllerArray[index];
        ZZZNavigationController *navigationController = [[ZZZNavigationController alloc] initWithRootViewController:viewController];
        
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nameArray[index]
                                                                        image:[UIImage imageNamed:imageArray[index]]
                                                                selectedImage:[UIImage imageNamed:selectedImageArray[index]]];
        //设置文字偏移
        [navigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(2, -4)];
        
        [tabBarController addChildViewController:navigationController];
    }
    
    [self.window setRootViewController:tabBarController];
}

@end
