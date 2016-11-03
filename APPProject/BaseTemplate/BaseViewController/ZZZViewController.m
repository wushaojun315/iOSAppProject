//
//  ZZZViewController.m
//  MVCGroupedFramework
//
//  Created by 吴少军 on 2016/10/17.
//  Copyright © 2016年 George. All rights reserved.
//

#import "ZZZViewController.h"
#import "AppConfigurer.h"

@interface ZZZViewController ()

@end

@implementation ZZZViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //如果需要半透明效果，则需要设置edgesForExtendedLayout属性为UIRectEdgeNone
        //这样能保证xib可以从（0，0）的位置开始布局，而不被遮挡
        if (kIsBarTranslucent) {
            //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方。
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
