//
//  ViewController.m
//  APPProject
//
//  Created by 吴少军 on 2016/11/2.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ViewController.h"

#import "ZZExampleHttpManager.h"
#import "ZZZAPIResponse.h"
#import "CommonMacros.h"
@interface ViewController ()<ZZZAPICallbackProtocol, ZZZAPIParamSourceProtocol>

@property (nonatomic, strong) ZZExampleHttpManager *exampleManager;
@property (nonatomic, weak) UITextView *resultTextView;

@end

@implementation ViewController

#pragma mark - getter/setter方法
- (ZZExampleHttpManager *)exampleManager {
    if (_exampleManager == nil) {
        _exampleManager = [[ZZExampleHttpManager alloc] init];
        _exampleManager.delegate = self;
        _exampleManager.paramSource = self;
    }
    return _exampleManager;
}

- (UITextView *)resultTextView {
    if (_resultTextView == nil) {
        UITextView *tempTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
        _resultTextView = tempTextView;
        [self.view addSubview:tempTextView];
        CGPoint viewCenter = CGPointMake(self.view.center.x, self.view.center.y - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
        _resultTextView.center = viewCenter;
        _resultTextView.backgroundColor = [UIColor whiteColor];
        _resultTextView.text = @"点击按钮发送请求后，展示结果";
    }
    return _resultTextView;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"主界面"];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    //下面添加其他UI控件
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    testButton.center = self.view.center;
    testButton.backgroundColor = [UIColor greenColor];
    [testButton setTitle:@"测试按钮" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonFounction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 方法
- (void)testButtonFounction:(UIButton *)button {
    
    self.resultTextView.text = @"sdfsdfdsf";
    [self.exampleManager requestDataFromAPI];
}

#pragma mark - ZZZAPIParamSourceProtocol代理方法
- (NSDictionary *)paramsForAPIManager:(ZZZBaseAPIManager *)manager {

    NSDictionary *paramDict = @{
                                @"userId" : @"a0a0e39441ad45050141b068ab9803a8",
                                @"organId" : @"130000000",
                                @"pageNo" : @"1",
                                @"pageSize" : @"10"};
    return paramDict;
}

#pragma mark - ZZZAPICallbackProtocol代理方法
- (void)didSuccessedOnCallingAPIWithManager:(ZZZBaseAPIManager *)manager {
    id responseObject = manager.response.receivedResponseObject;
    self.resultTextView.text = [NSString stringWithFormat:@"%@", responseObject];
}

- (void)didFailedOnCallingAPIWithManager:(ZZZBaseAPIManager *)manager {
    self.resultTextView.text = @"请求失败";
}

@end
