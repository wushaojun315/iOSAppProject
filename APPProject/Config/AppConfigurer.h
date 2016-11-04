//
//  AppConfigurer.h
//  APPProject
//
//  Created by 吴少军 on 2016/11/3.
//  Copyright © 2016年 George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacros.h"

#ifndef AppConfigurer_h
#define AppConfigurer_h


//导航栏以及tab栏是否半透明效果
#define kIsBarTranslucent         YES

//颜色常量
#define kAppThemeColor            [UIColor orangeColor]
#define kNaviBarBackgroundColor   ColorWithValue(0X2196F3) // 导航栏背景颜色
#define kNaviBarTitleColor        [UIColor whiteColor]  // 导航栏标题文字颜色
#define kNaviBackArrowColor       [UIColor whiteColor]   // 返回箭头的颜色
#define kNaviBarItemTextColor     [UIColor whiteColor] // 导航栏左右两侧按钮文字颜色

#define kTabBarBackgroundColor    [UIColor whiteColor] // tabBar的背景颜色
#define kSelectedTabTextColor     ColorWithValue(0X2196F3)  // tabBar中选中栏目的文字颜色

//字体
#define kNaviBarTitleFont         [UIFont systemFontOfSize:21]  // 导航栏标题文字大小

#endif /* AppConfigurer_h */

@interface AppConfigurer : NSObject

@end
