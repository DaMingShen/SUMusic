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
    self.songList = [NSMutableArray array];
    self.currentSong = [[SongInfo alloc]init];
    self.currentSong.sid = @"0";
    self.currentSongIndex = 0;
    self.currentChannelID = @"0";  //默认频道：私人频道
    self.currentChannelName = @"私人频道";
    
    AVAudioSession * session = [[AVAudioSession alloc]init];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //播放完毕后的通知
    RegisterNotify(MPMoviePlayerPlaybackDidFinishNotification, @selector(playNext))
    //Loading状态改变通知
    RegisterNotify(MPMoviePlayerLoadStateDidChangeNotification, @selector(loadingStatusChange))
    //播放状态改变通知
    RegisterNotify(MPMoviePlayerPlaybackStateDidChangeNotification, @selector(playBackStatusChange))
    //可播放时间改变通知
    RegisterNotify(MPMovieDurationAvailableNotification, @selector(durationAvailable))

}

#pragma mark - 播放器控制
//开始／继续播放
- (void)startPlay {
    if (self.isPlaying) return;
    
    [self.player play];
//    SendNotify(SONGPLAY, nil)
    
    //如果是最后一首，加载更多歌曲
    if (!self.isLocalPlay && self.currentSongIndex == self.songList.count - 1) [self loadMoreSong];
}

//暂停播放
- (void)pausePlay {
    if (!self.isPlaying) return;
    
    [self.player pause];
    SendNotify(SONGPAUSE, nil)
}

//播放完毕
- (void)endPlay {
    if (!self.isPlaying) return;
    
    [self.player pause];
    SendNotify(SONGEND, nil)
}

//自然播放下一首
- (void)playNext {
    
    if (!self.isLocalPlay) {
        //先报告上一首歌已完成
        [self reportSongEnd];
    }
    
    //播放列表下一首歌
    [self endPlay];
    [self loadSongInfoWithResetStatus:NO];
    [self startPlay];
}

//停止当前歌曲并从第一首开始播放
- (void)resetPlay {
    [self loadSongInfoWithResetStatus:YES];
    [self startPlay];
}

//加载下一首歌曲信息（reset ：打开app、切歌、ban歌之后）
- (void)loadSongInfoWithResetStatus:(BOOL)reset {
    //是否从第一首播放
    self.currentSongIndex = reset ? 0 : self.currentSongIndex + 1;
    //如果是播放本地列表，则循环播放
    if (self.isLocalPlay && self.currentSongIndex > self.songList.count - 1) self.currentSongIndex = 0;
    //更新当前歌曲信息
    self.currentSong = self.songList[self.currentSongIndex];
    //加载URL（如果是离线播放，则播放离线文件）
    NSURL * url;
    if (self.isOffLinePlay) {
        NSString * filePath = [SuGlobal getOffLineFilePath];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            BASE_INFO_FUN(@"文件存在");
            url = [NSURL fileURLWithPath:filePath];
        }else {
            BASE_INFO_FUN(@"文件不存在");
            url = [NSURL URLWithString:self.currentSong.url];
        }
    }else {
        url = [NSURL URLWithString:self.currentSong.url];
    }
    [self.player setContentURL:url];
    //准备播放
    [self.player prepareToPlay];
    SendNotify(SONGREADY, nil)
}

#pragma mark - 网络操作
//纯粹获取播放列表(打开app、切换频道)
- (void)newChannelPlay {
    [self endPlay];
    [SUNetwork fetchPlayListWithType:OperationTypeNone completion:^(BOOL isSucc) {
        if (isSucc) {
            self.isLocalPlay = NO;
            [self resetPlay];
        };
    }];
}

//切歌
- (void)skipSongWithHandle:(void(^)(BOOL isSucc))handle {
    //本地播放下一首
    if (self.isLocalPlay) {
        [self playNext];
        if (handle) handle(YES);
    }
    //网络播放下一首
    else {
        [SUNetwork fetchPlayListWithType:OperationTypeSkip completion:^(BOOL isSucc) {
            if (isSucc) {
                [self endPlay];
                [self resetPlay];
            }
            if (handle) handle(isSucc);
        }];
    }
}

//ban歌
- (void)banSongWithHandle:(void(^)(BOOL isSucc))handle {
    
    [SUNetwork fetchPlayListWithType:OperationTypeBan completion:^(BOOL isSucc) {
        if (isSucc) {
            [self endPlay];
            [self resetPlay];
        }
        if (handle) handle(isSucc);
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

#pragma mark - 本地列表播放
- (void)playLocalListWithIndex:(NSInteger)index {
    [self endPlay];
    self.isLocalPlay = YES;
    self.currentSongIndex = index - 1;
    [self loadSongInfoWithResetStatus:NO];
    [self startPlay];
}

#pragma mark - 播放器属性获取

/*
 * 处理频道名称
 */
- (void)setCurrentChannelName:(NSString *)currentChannelName {
    _currentChannelName = [NSString stringWithFormat:@"🎵 %@ MHz 🎵",currentChannelName];
}

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
 * 总时长(秒)
 */
- (NSString *)playDuration {
    
    return [NSString stringWithFormat:@"%.f", self.player.duration];
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

/*
 * 播放器播放状态
 */
- (BOOL)isPlaying {
    return self.player.playbackState == MPMoviePlaybackStatePlaying;
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

#pragma mark - loading状态
- (void)loadingStatusChange {
    
    switch (self.player.loadState) {
        case MPMovieLoadStateUnknown:
            BASE_INFO_FUN(@"未知状态");
            break;
        case MPMovieLoadStatePlayable:
            BASE_INFO_FUN(@"可以播放");
            break;
        case MPMovieLoadStatePlaythroughOK:
            BASE_INFO_FUN(@"缓冲完成");
            break;
        case MPMovieLoadStateStalled:
            BASE_INFO_FUN(@"缓冲中");
            break;
        default:
            break;
    }
}

#pragma mark - 播放状态
- (void)playBackStatusChange {
    
    switch (self.player.playbackState) {
        case MPMoviePlaybackStatePlaying:
            SendNotify(SONGPLAY, nil)
            BASE_INFO_FUN(@"State:正在播放");
            break;
        case MPMoviePlaybackStatePaused:
//            SendNotify(SONGPAUSE, nil)
            BASE_INFO_FUN(@"State:暂停播放");
            break;
        case MPMoviePlaybackStateStopped:
            BASE_INFO_FUN(@"State:停止播放");
            break;
        case MPMoviePlaybackStateInterrupted:
            BASE_INFO_FUN(@"State:中断播放");
            break;
        case MPMoviePlaybackStateSeekingForward:
            BASE_INFO_FUN(@"State:向前定位");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            BASE_INFO_FUN(@"State:向后定位");
            break;
        default:
            break;
    }
    
}

- (void)durationAvailable {
    BASE_INFO_FUN(@"可播放时间改变通知");
    [[AppDelegate delegate] configNowPlayingCenter];
}


@end
