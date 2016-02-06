//
//  AppDelegate.h
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPlayerManager.h"
#import "UserInfo.h"
#import "PlayViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
 * 用户信息
 */
@property (nonatomic, strong) UserInfo * userInfo;

/*
 * 播放器类
 */
@property (nonatomic, strong) SUPlayerManager * player;

/*
 * 播放界面
 */
@property (nonatomic, strong) PlayViewController * playView;

/*
 * 获取app代理
 */
+ (AppDelegate *)delegate;

/*
 * 更新NowPlayingCenter
 */
- (void)configNowPlayingCenter;

@end

