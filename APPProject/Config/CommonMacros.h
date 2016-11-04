//
//  CommonMacros.h
//  APPProject
//
//  Created by 吴少军 on 2016/11/3.
//  Copyright © 2016年 George. All rights reserved.
//

#ifndef CommonMacros_h
#define CommonMacros_h

/******************************************************************************/
/*                            一些宽高、尺寸的获取                                */
/******************************************************************************/
// 状态栏高度
#define STATUS_BAR_HEIGHT      20
// NavBar高度
#define NAVIGATION_BAR_HEIGHT  44
// 屏幕宽高
#define SCREEN_WIDTH           ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT          ([UIScreen mainScreen].bounds.size.height)

/******************************************************************************/
/*                                 获取图片的方式                                */
/******************************************************************************/
// 加载mainBundle中的图片
#define LOADIMAGE(imageName, type) \
        [UIImage imageWithContentsOfFile:\
                        [[NSBundle mainBundle] pathForResource:imageName \
                                                        ofType:type]]


/******************************************************************************/
/*                                   颜色设置                                  */
/******************************************************************************/
// 随机颜色
#define RandomColor             [UIColor colorWithRed:arc4random_uniform(256)/255.0 \
                                                green:arc4random_uniform(256)/255.0 \
                                                blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define RGBColor(r, g, b)       [UIColor colorWithRed:(r)/255.0 \
                                                green:(g)/255.0 \
                                                blue:(b)/255.0 alpha:1.0]

#define RGBAColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 \
                                                green:(r)/255.0 \
                                                blue:(r)/255.0 alpha:a]
// 获取16进制的颜色
#define ColorWithValue(OXValue) [UIColor colorWithRed:((float)((OXValue & 0XFF0000) >> 16))/255.0 \
                                                green:((float)((OXValue & 0XFF00) >> 8))/255.0 \
                                                blue:((float)(OXValue & 0XFF))/255.0 alpha:1.0]

/******************************************************************************/
/* 获取__weak 和 __strong 变量,可以在__weak之前加 autoreleasepool{}，就可以使用@符号 */
/******************************************************************************/
// STRONG需要在WEAK之后才能使用（因为需要使用weak的变量）
#define WEAKSelf             typeof(self) __weak selfWeak = self;
#define STRONGSelf           typeof(self) __strong selfStrong = selfWeak;
#define WEAKObject(object)   __weak typeof(object) object##Weak = object;
#define STRONGObject(object) __strong typeof(object) object##Strong = object##Weak;

/******************************************************************************/
/*                                设置单例模式                                  */
/******************************************************************************/
#define SingleInstance \
            + (id)sharedInstance { \
                static id _sharedInstance = nil; \
                static dispatch_once_t onceToken; \
                dispatch_once(&onceToken, ^{ \
                    _sharedInstance = [[self alloc] init]; \
                }); \
                return _sharedInstance; \
            }

/******************************************************************************/
/*                                  自定义Log                                  */
/******************************************************************************/
// Debug模式下输出日志，release模式下不输出
#ifdef DEBUG
#define DLog(format, ...) \
            do { \
                fprintf(stderr, \
                "*******************DEBUG Message*******************\n"\
                "[文件信息]:                                         \n"\
                "<%s - 第%d行>\n"\
                "[方法名]:                                           \n"\
                "%s\n"\
                "[输出信息]:====>                                    \n"\
                "%s\n"\
                "\n===================================================\n", \
                [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
                __LINE__, __func__, \
                [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);\
            } while (0)
#else
# define DLog(...)
#endif

// Debug模式下弹窗提示
#ifdef DEBUG
#define DLogAlert(...)  \
{\
    UIAlertView *alert = [[UIAlertView alloc] \
                                initWithTitle:@"提示信息" \
                                message:[NSString stringWithFormat:__VA_ARGS__]\
                                delegate:nil \
                                cancelButtonTitle:@"确认" \
                                otherButtonTitles:nil]; \
    [alert show];\
}
#else
#define DLogAlert(...)
#endif

/******************************************************************************/
/*                                有关系统环境的宏                               */
/******************************************************************************/
// 系统版本是否等于v
#define SYSTEM_VERSION_EQUAL_TO(v) \
            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] \
                                                                    == NSOrderedSame)
// 系统版本是否大于v
#define SYSTEM_VERSION_GREATER_THAN(v) \
            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] \
                                                                    == NSOrderedDescending)
// 系统版本是否大于等于v
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] \
                                                                    != NSOrderedAscending)
// 系统版本是否小于v
#define SYSTEM_VERSION_LESS_THAN(v) \
            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] \
                                                                    == NSOrderedAscending)
// 系统版本是否小于等于v
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
            ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] \
                                                                    != NSOrderedDescending)
// 系统版本是否大于等于7.0
#define iOS7_OR_LATER           SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
// 系统版本是否大于等于8.0
#define iOS8_OR_LATER           SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
// 获取当前系统版本
#define SystenVersionFloat      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SystenVersionDouble     ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SystemVersionString     ([[UIDevice currentDevice] systemVersion])
// 是否是iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为iPhone
#define isIPhone                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/******************************************************************************/
/*                                其他的功能宏定义                               */
/******************************************************************************/
// 获取系统时间戳
#define SecondSice1970  [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]
// 当前语言
#define CURRENTLANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])


#endif /* CommonMacros_h */
