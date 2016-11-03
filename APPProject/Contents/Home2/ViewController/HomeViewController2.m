//
//  HomeViewController2.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "HomeViewController2.h"
#import "ViewController.h"

@interface HomeViewController2 ()

@end

@implementation HomeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"第三页面";
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 54)];
    testButton.center = self.view.center;
    testButton.backgroundColor = [UIColor greenColor];
    [testButton setTitle:@"跳转网络测试页面" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonFounction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}

// 测试按钮，跳转网络请求页面
- (void)testButtonFounction:(UIButton *)button {
    
    ViewController *apiTestingVC = [[ViewController alloc] init];
    [self showViewController:apiTestingVC sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
