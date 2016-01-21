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
    self.currentChannelID = @"1";  //默认频道：私人频道
    
    AVAudioSession * session = [[AVAudioSession alloc]init];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //播放完毕后的通知
    RegisterNotify(MPMoviePlayerPlaybackDidFinishNotification, @selector(playNext));
}

#pragma mark - 播放器控制
//开始／继续播放
- (void)startPlay {
    if (self.isPlaying) return;
    
    [self.player play];
    self.isPlaying = YES;
    
    //如果是最后一首，加载更多歌曲
    if (self.currentSongIndex == self.songList.count - 1) [self loadMoreSong];
}

//暂停播放
- (void)pausePlay {
    if (!self.isPlaying) return;
    
    [self.player pause];
    self.isPlaying = NO;
}

//自然播放下一首
- (void)playNext {
    
    //先报告上一首歌已完成
    [self reportSongEnd];
    
    //播放列表下一首歌
    [self pausePlay];
    SendNotify(SONGEND, nil);
    [self loadSongInfoWithResetStatus:NO];
    [self startPlay];
}

//停止当前歌曲并从第一首开始播放
- (void)resetPlay {
    [self pausePlay];
    SendNotify(SONGEND, nil);
    [self loadSongInfoWithResetStatus:YES];
    [self startPlay];
}

//加载下一首歌曲信息（reset ：打开app、切歌、ban歌之后）
- (void)loadSongInfoWithResetStatus:(BOOL)reset {
    self.currentSongIndex = reset ? 0 : self.currentSongIndex + 1;
    self.currentSong = self.songList[self.currentSongIndex];
    [self.player setContentURL:[NSURL URLWithString:self.currentSong.url]];
    SendNotify(SONGBEGIN, nil);
}

#pragma mark - 网络操作
//纯粹获取播放列表(打开app、切换频道)
- (void)newChannelPlay {
    [SUNetwork fetchPlayListWithType:OperationTypeNone completion:^(BOOL isSucc) {
        if (isSucc) {
            [self resetPlay];
        };
    }];
}

//切歌
- (void)skipSong {
    [self pausePlay];
    [SUNetwork fetchPlayListWithType:OperationTypeSkip completion:^(BOOL isSucc) {
        if (isSucc) {
            [self resetPlay];
        }
    }];
}

//ban歌
- (void)banSong {
    [self pausePlay];
    [SUNetwork fetchPlayListWithType:OperationTypeBan completion:^(BOOL isSucc) {
        if (isSucc) {
            [self resetPlay];
        }
    }];
}

//报告歌曲正常播放完毕
- (void)reportSongEnd {
    [SUNetwork fetchPlayListWithType:OperationTypeEnd completion:^(BOOL isSucc) {

    }];
}

//播放到列表最后一首
- (void)loadMoreSong {
    [SUNetwork fetchPlayListWithType:OperationTypePlay completion:^(BOOL isSucc) {
        
    }];
}

#pragma mark - 播放器属性获取
/*
 * 播放进度
 */
- (float)progress {
    
    if (isnan(self.player.currentPlaybackTime) || self.player.duration <= 0) return 0.f;
    return self.player.currentPlaybackTime / self.player.duration;
}

/*
 * 当前播放时间(秒)
 */
- (NSString *)playTime {
    
    return [NSString stringWithFormat:@"%.f",isnan(self.player.currentPlaybackTime) ? 0 : self.player.currentPlaybackTime];
}


/*
 * 当前播放时间(00:00)
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
