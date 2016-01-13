//
//  CustomTabbar.h
//  SuUtility
//
//  Created by KevinSu on 15/10/18.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuButton.h"

@interface CustomTabbar : UITabBarController

/*
 自定义tabbar，完全自定义样式
 */
+ (instancetype)creatTabbarInController:(UIViewController *)controller WithTabbarColor:(UIColor *)tabbarColor BgImage:(NSString *)bgImg Page:(NSArray *)pageArray NameArray:(NSArray *)nameArray NorImgArray:(NSArray *)norImgArray SelImgArray:(NSArray *)selImgArray norColor:(UIColor *)norColor selColor:(UIColor *)selColor;

/*
 使用系统tabbar来配置
 */


@end
