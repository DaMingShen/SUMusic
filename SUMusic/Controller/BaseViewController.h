//
//  BaseViewController.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


#pragma mark ===========================消息相关============================

- (void)ToastMessage:(NSString *)message;
- (void)showAlert:(NSString *)message;

//显示动画
- (void)showLoadingAni;
- (void)hideAni;
- (UIView *)showLoadingInView:(UIView *)sender;
- (void)hideLoading:(UIView *)loadingView;

#pragma mark ===========================导航相关============================
- (void)setNavigationTitle:(NSString *)title;
- (void)setNavigationTitleView:(UIView *)view;
- (void)setStatusBarStyle:(UIStatusBarStyle)style;
- (UIBarButtonItem *)setNavigationLeft:(NSString *)imageName sel:(SEL)sel;
- (UIBarButtonItem *)setNavigationRight:(NSString *)imageName sel:(SEL)sel;
- (UIBarButtonItem *)setNavigationRightButton:(NSString *)btnName sel:(SEL)sel;

@end
