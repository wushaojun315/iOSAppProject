//
//  HomeViewController0.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "HomeViewController0.h"
#import "UsefulHeaders.h"

@interface HomeViewController0 ()

@end

@implementation HomeViewController0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"第一页面";
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    testButton.center = self.view.center;
    testButton.backgroundColor = [UIColor greenColor];
    [testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonFounction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)testButtonFounction:(UIButton *)button {
    // 测试宏定义
    int i = 100;
    DLog(@"测试DLog使用==输出数字：%d", i);
    DLogAlert(@"请求成功！");
    // 测试pod功能，以及UIAlertController是否能显示正常
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 200, 80)];
    vv.backgroundColor = [UIColor greenColor];
    
    UILabel *containedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    containedLabel.text = @"这是一个Toast!";
    containedLabel.center = vv.center;
    containedLabel.backgroundColor = [UIColor yellowColor];
    [vv addSubview:containedLabel];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示框" message:@"测试UIAlertController是否能显示正常，因为以前有项目模板，这个无法显示标题！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view showToast:vv];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
