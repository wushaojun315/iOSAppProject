//
//  HomeViewController1.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "HomeViewController1.h"
#import "JumpDestinationVC.h"

@interface HomeViewController1 ()

@end

@implementation HomeViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"第二页面";
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 54)];
    testButton.center = self.view.center;
    testButton.backgroundColor = [UIColor redColor];
    [testButton setTitle:@"测试跳转按钮" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonFounction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}

- (void)testButtonFounction:(UIButton *)button {
    
    JumpDestinationVC *destinationVC = [[JumpDestinationVC alloc] init];
    [self showViewController:destinationVC sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
