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

@property (nonatomic, strong) UserInfo * userInfo;

@property (nonatomic, strong) SUPlayerManager * player;

@property (nonatomic, strong) PlayViewController * playView;

+ (AppDelegate *)delegate;

@end

