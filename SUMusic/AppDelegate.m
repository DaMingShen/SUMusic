//
//  AppDelegate.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "OffLineManager.h"

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
    
    //监听网络变化
    [[SuNetworkMonitor monitor]startMonitorNetwork];
    
    //打开音频会话
    AVAudioSession * session = [[AVAudioSession alloc]init];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //初始化用户数据
    [self initialUser];
    
    //初始化播放器
    self.player = [SUPlayerManager manager];
    self.playView = [[PlayViewController alloc]init];
    [self.playView launchShow];
    [self.player launchPlay];
    
    //Remote Control
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //下载未完成的离线歌曲
    [[OffLineManager manager]downLoadUncompletedSongs];
    
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

#pragma mark - network
- (void)setNetworkStatus:(NetworkStatus)networkStatus {
    if (_networkStatus != networkStatus) {
        _networkStatus = networkStatus;
        SendNotify(NETWORKSTATUSCHANGE, nil)
    }else {
        _networkStatus = networkStatus;
    }
}

#pragma mark - URL 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
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
    BASE_INFO_FUN(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    [info setObject:_player.currentSong.title forKey:MPMediaItemPropertyTitle];
    [info setObject:_player.currentSong.artist forKey:MPMediaItemPropertyArtist];
    [info setObject:@(self.player.playTime.intValue) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [info setObject:@(self.player.playDuration.intValue) forKey:MPMediaItemPropertyPlaybackDuration];
    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:_player.coverImg];
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
            [self.player startPlay];
            BASE_INFO_FUN(@"remote_play");
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.player pausePlay];
            BASE_INFO_FUN(@"remote_pause");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self.playView skipSong:nil];
            BASE_INFO_FUN(@"remote_skip");
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            self.player.isPlaying ? [self.player pausePlay] : [self.player startPlay];
            BASE_INFO_FUN(@"remote_toggle");
            break;
        default:
            break;
    }
}


@end
