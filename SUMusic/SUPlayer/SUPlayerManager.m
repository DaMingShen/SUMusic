//
//  SUPlayer.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUPlayerManager.h"
#import "SongInfo.h"
#import "PlayerViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_CENTER CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

@implementation SUPlayerManager

+ (instancetype)manager {
    
    static SUPlayerManager * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SUPlayerManager alloc]init];
    });
    return player;
}

- (void)initialPlayer {
    
    //初始化
    self.player = [[MPMoviePlayerController alloc]init];
    self.playerVC = [[PlayerViewController alloc]init];
    
    //播放完毕后的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNext) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - 播放控制
- (void)startPlay {
    
    [SUNetwork fetchPlayListWithCompletion:^(SongInfo *song) {
        self.currentSong = song;
        if (self.currentSong) {
            [self.player setContentURL:[NSURL URLWithString:self.currentSong.url]];
            [self restartPlay];
        }
    }];
    
    
}

- (void)pausePlay {
    if (self.isPlaying) {
        [self.player pause];
        self.isPlaying = NO;
    }
}

- (void)restartPlay {
    if (!self.isPlaying) {
        [self.player play];
        self.isPlaying = YES;
    }
}

- (void)playNext {
    [self pausePlay];
    [self startPlay];
}

- (void)playLast {
    
}

- (float)bufferProgress {
    
    NSArray *events = self.player.accessLog.events;
    for (int i = 0; i < events.count; i++)
    {
        MPMovieAccessLogEvent *currentEvent = [events objectAtIndex:i];
        double byts = currentEvent.indicatedBitrate;
        int64_t byte = currentEvent.numberOfBytesTransferred;
        int64_t bytes = currentEvent.numberOfBytesTransferred >> 10;
        NSMutableString *strBytes = [[NSMutableString alloc] initWithCapacity:100];
//        [strBytes appendFormat:@"totalSize = %lld byte", bytes];
//        NSLog(@"%@",strBytes);
        if (bytes > 1024)
        {
            bytes = bytes >> 10;
//            [bytesS setString:@""];
//            [bytesS appendFormat:@"total = %d M", bytes];
        }
//        NSLog(@"byte = %f M bytes = %lld", (float)byte / (1024 * 1024), bytes);
    }
    return 0.f;
}

#pragma mark - 界面控制
- (void)show {
    
    self.playerVC.view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + SCREEN_HEIGHT);
    [KEY_WINDOW addSubview:self.playerVC.view];
    [UIView animateWithDuration:0.5 animations:^{
        self.playerVC.view.center = SCREEN_CENTER;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.playerVC.view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + SCREEN_HEIGHT);
    }];
    [self.playerVC.view removeFromSuperview];
}

@end
