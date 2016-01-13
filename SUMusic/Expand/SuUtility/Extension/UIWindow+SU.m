//
//  UIWindow+SuExt.m
//  SuUtility
//
//  Created by KevinSu on 15/10/17.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "UIWindow+SU.h"

@implementation UIWindow (SU)

- (void)chooseRootViewControllerWithNewFeatureController:(UIViewController *)newFeatureVC homeController:(UIViewController *)homeVC {
    
    // 判断是否显示新特性
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [defaults objectForKey:@"CFBundleShortVersionString"];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion compare:localVersion] == NSOrderedDescending) {

        window.rootViewController = newFeatureVC;
        
        [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [defaults synchronize];
    } else {
        window.rootViewController = homeVC;
    }
}

@end
