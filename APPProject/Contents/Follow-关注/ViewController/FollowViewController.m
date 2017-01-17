//
//  FollowViewController.m
//  APPProject
//
//  Created by 吴少军 on 2016/12/15.
//  Copyright © 2016年 George. All rights reserved.
//

#import "FollowViewController.h"
#import "LoginRegisterViewController.h"

@interface FollowViewController ()

@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonAction:(UIButton *)sender {
    
    LoginRegisterViewController *loginRegisterController = [[LoginRegisterViewController alloc] init];
    [self presentViewController:loginRegisterController animated:YES completion:NULL];
}


@end
