//
//  LoginRegisterViewController.m
//  APPProject
//
//  Created by 吴少军 on 2016/12/15.
//  Copyright © 2016年 George. All rights reserved.
//

#import "LoginRegisterViewController.h"

@interface LoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeadingConstraint;
@end

@implementation LoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 下面实现点击按钮之后，登录视图部分与注册视图部分的动画切换效果
- (IBAction)showLoginOrRegister:(UIButton *)sender {
    // 如果在输入时，停止输入
    [self.view endEditing:YES];
    // 判断当前“登录视图”和“注册视图”的位置关系
    if (self.leftLeadingConstraint.constant == 0) {
        // 约束的常量为零时，表示当前控制器看到的是“登录视图”，所以点击之后是要跳到注册视图
        self.leftLeadingConstraint.constant = - self.view.frame.size.width;
        [sender setTitle:@"已有账号？" forState:UIControlStateNormal];
    } else {
        // 当前控制器显示的是“注册视图”，点击后跳到登录视图
        self.leftLeadingConstraint.constant = 0;
        [sender setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    // 上面代码改变视图位置，后面在动画中layoutSubviews
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)closeController {
}

@end
