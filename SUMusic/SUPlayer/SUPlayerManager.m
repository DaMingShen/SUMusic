//
//  SUPlayer.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUPlayerManager.h"
#import "SongInfo.h"

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
    self.isPlaying = NO;
    self.songList = [NSMutableArray array];
    self.currentSong = [[SongInfo alloc]init];
    self.currentSong.sid = @"0";
    self.currentSongIndex = 0;
    self.currentChannelID = @"1";
    
    
    AVAudioSession * session = [[AVAudioSession alloc]init];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //播放完毕后的通知
    RegisterNotify(MPMoviePlayerPlaybackDidFinishNotification, @selector(playNext));
    
}

#pragma mark - 播放控制
- (void)startPlay {
    
    [SUNetwork fetchPlayListWithType:OperationTypeNewPlayList completion:^(BOOL isSucc) {
        if (isSucc) {
            [self play];
        }
        
    }];
    
    
}

- (void)play {
    
    self.currentSongIndex = 0;
    self.currentSong = self.songList[self.currentSongIndex];
    [self.player setContentURL:[NSURL URLWithString:self.currentSong.url]];
    [self restartPlay];
    SendNotify(SONGBEGIN, nil);
}

- (void)pausePlay {
    if (!self.isPlaying) return;
    
    [self.player pause];
    self.isPlaying = NO;
}

- (void)restartPlay {
    if (self.isPlaying) return;
    
    [self.player play];
    self.isPlaying = YES;
}

- (void)playNext {
    [self pausePlay];
    [SUNetwork fetchPlayListWithType:OperationTypeSkip completion:^(BOOL isSucc) {
        if (isSucc) {
            [self play];
        }
    }];
}

/*
 * 播放进度
 */
- (float)progress {
    
    if (isnan(self.player.currentPlaybackTime) || self.player.duration <= 0) return 0.f;
    return self.player.currentPlaybackTime / self.player.duration;
}


/*
 * 当前播放时间
 */
- (NSString *)timeNow {

    return [self convertStringWithTime:self.player.currentPlaybackTime];
}

/*
 * 总时长
 */
- (NSString *)duration {
    
    return [self convertStringWithTime:self.player.duration];
}



- (float)bufferProgress {
    
    /*
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
     */
    return 0.f;
}

#pragma mark - private method 
- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

@end
