//
//  AppDelegate.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)delegate {
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化窗口、设置根目录
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HomeViewController * homeVC = [[HomeViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //初始化用户数据
    [self initialUser];
    self.player = [SUPlayerManager manager];
    
    //初始化播放器
    [self.player initialPlayer];
    self.playView = [[PlayViewController alloc]init];
    [self.playView show];
    
    //初始化友盟
    [UMSocialData setAppKey:@"56a4941667e58e200d001b8d"];
    [UMSocialWechatHandler setWXAppId:@"wxf8ce75c31226366a" appSecret:@"4692af8d31f541dba7b1a2ffbcd29019" url:@"www.baidu.com"];
    
    //Remote Control
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - URL 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == false) {
        
    }
    return result;
}

#pragma mark - User
- (void)initialUser {
    
    UserInfo * userInfo = [UserInfo loadUserInfo];
    if (userInfo) {
        self.userInfo = userInfo;
    }
    BASE_INFO_FUN(userInfo.user_name);
}

#pragma mark - NowPlayingCenter & Remote Control
- (void)configNowPlayingCenter {
    
    //[UIApplication sharedApplication].applicationState == UIApplicationStateActive;
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    [info setObject:_player.currentSong.title forKey:MPMediaItemPropertyTitle];
    [info setObject:_player.currentSong.artist forKey:MPMediaItemPropertyArtist];
    [info setObject:@(self.player.playTime.intValue) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [info setObject:@(self.player.playDuration.intValue) forKey:MPMediaItemPropertyPlaybackDuration];
    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:self.playView.coverImg];
    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    switch (event.subtype)
    {
        case UIEventSubtypeRemoteControlPlay:
            [self.playView goOnPlaying:nil];
            BASE_INFO_FUN(@"remote_play");
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.playView pausePlaying:nil];
            BASE_INFO_FUN(@"remote_pause");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self.playView skipSong:nil];
            BASE_INFO_FUN(@"remote_skip");
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if (self.player.isPlaying) {
                [self.playView pausePlaying:nil];
            }else {
                [self.playView goOnPlaying:nil];
            }
            BASE_INFO_FUN(@"remote_toggle");
            break;
        default:
            break;
    }
}


@end
