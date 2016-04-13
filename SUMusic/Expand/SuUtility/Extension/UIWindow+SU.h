//
//  UIWindow+SuExt.h
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (SU)


/*
 是否显示新特性页面
 */
- (void)chooseRootViewControllerWithNewFeatureController:(UIViewController *)loginVC homeController:(UIViewController *)homeVC;

@end
