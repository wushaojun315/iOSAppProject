//
//  JumpDestinationVC.m
//  MVCProject
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "JumpDestinationVC.h"
#import <UIView+Toast.h>

@interface JumpDestinationVC ()

@end

@implementation JumpDestinationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"跳转页面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右侧按钮" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemClick {
    
    [self.view makeToast:@"点击了右侧按钮"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
