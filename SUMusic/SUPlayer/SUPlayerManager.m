//
//  SUPlayer.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUPlayerManager.h"
#import "SongInfo.h"

@implementation SUPlayerManager

+ (instancetype)manager {
    
    static SUPlayerManager * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SUPlayerManager alloc]init];
    });
    return player;
}

- (id)init {
    if (self = [super init]) {
        self.songList = [NSMutableArray array];
        self.currentChannelID = @"0";  //默认频道：私人频道
        self.currentChannelName = @"私人频道";
//        self.playTime = @"0";
//        self.duration = @"0";
    }
    return self;
}

#pragma mark - 频道
/*
 * 处理频道名称
 */
- (void)setCurrentChannelName:(NSString *)currentChannelName {
    _currentChannelName = [NSString stringWithFormat:@"🎵 %@ MHz 🎵",currentChannelName];
}

#pragma mark - 播放器
/*
 * 播放器播放状态
 */
- (BOOL)isPlaying {
    return self.player.rate == 1;
}

/*
 * 当前播放时间(00:00)
 */
- (NSString *)timeNow {
    
    return [self convertStringWithTime:self.playTime.floatValue];
}

/*
 * 总时长(00:00)
 */
- (NSString *)duration {
    
    return [self convertStringWithTime:self.playDuration.floatValue];
}

/*
 * 开始播放
 */
- (void)startPlay {
    
    [self.player play];
    
    //如果是最后一首，加载更多歌曲
    if (self.currentSongIndex == self.songList.count - 1) [self loadMoreSong];
}

/*
 * 暂停播放
 */
- (void)pausePlay {
    
    if (!self.isPlaying) return;
    [self.player pause];
}

/*
 * 播放完毕
 */
- (void)endPlay {
    
}

/*
 * 自然播放下一首
 */
- (void)playNext {
    
    if (!self.isOffLinePlay) {
        //先报告上一首歌已完成
        [self reportSongEnd];
    }
    
}

#pragma mark - 加载歌曲
/*
 * 加载歌曲
 * reset: 从头开始
 */
- (void)loadSongInfoWithNewList:(BOOL)isNew {
    
    //更新当前歌曲信息
    self.currentSongIndex = isNew ? 0 : self.currentSongIndex + 1;
    self.currentSong = self.songList[self.currentSongIndex];
    
    //加载URL（如果是离线播放，则播放离线文件）
    NSURL * url;
    if (self.isOffLinePlay) {
        NSString * filePath = [SuGlobal getOffLineFilePath];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            url = [NSURL fileURLWithPath:filePath];
        }else {
            BASE_ERROR_FUN(@"文件不存在");
        }
    }else {
        url = [NSURL URLWithString:self.currentSong.url];
    }
    
    //移除监控
    if (self.player) {
        [self addObserver];
        self.player = nil;
    }
    
    //重置播放器
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    
    //给当前歌曲添加监控
    [self addObserver];
}

#pragma mark - KVO
- (void)addObserver {
    
    AVPlayerItem * songItem = self.player.currentItem;
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //更新播放器进度
    WEAKSELF
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
//        SuLog(@"%f, %f",current, total);
        if (current) {
            weakSelf.progress = current / total;
            weakSelf.playTime = [NSString stringWithFormat:@"%.2f",current];
            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
        }
    }];
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    
    AVPlayerItem * songItem = self.player.currentItem;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}


- (void)playbackFinished:(NSNotification *)notice {
    BASE_INFO_FUN(@"播放完成");
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem * songItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                BASE_INFO_FUN(@"未知状态");
                break;
            case AVPlayerStatusReadyToPlay:
                self.status = SUPlayStatusReadyToPlay;
                SendNotify(SONGPLAYSTATUSCHANGE, nil)
                BASE_INFO_FUN(@"正在播放");
                break;
            case AVPlayerStatusFailed:
                BASE_INFO_FUN(@"加载失败");
                break;
            default:
                break;
        }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        SuLog(@"共缓冲%.2f",totalBuffer);
    }
}


#pragma mark - 播放器网络操作
/*
 * 纯粹获取播放列表(打开app、切换频道)
 */
- (void)newChannelPlay {
    
    [SUNetwork fetchPlayListWithType:OperationTypeNone completion:^(BOOL isSucc) {
        if (isSucc) {
            [self loadSongInfoWithNewList:YES];
            [self startPlay];
        }else {
            //跳转到离线播放
        };
    }];
}

/*
 * 切歌
 */
- (void)skipSongWithHandle:(void(^)(BOOL isSucc))handle {

        [SUNetwork fetchPlayListWithType:OperationTypeSkip completion:^(BOOL isSucc) {
            if (isSucc) {
                
            }
            if (handle) handle(isSucc);
        }];

}

/*
 * ban歌
 */
- (void)banSongWithHandle:(void(^)(BOOL isSucc))handle {
    
    [SUNetwork fetchPlayListWithType:OperationTypeBan completion:^(BOOL isSucc) {
        if (isSucc) {
            [self endPlay];
        }
        if (handle) handle(isSucc);
    }];
}

/*
 * 报告歌曲正常播放完毕
 */
- (void)reportSongEnd {
    [SUNetwork fetchPlayListWithType:OperationTypeEnd completion:^(BOOL isSucc) {

    }];
}

/*
 * 播放到列表最后一首加载更多歌曲
 */
- (void)loadMoreSong {
    [SUNetwork fetchPlayListWithType:OperationTypePlay completion:^(BOOL isSucc) {
        
    }];
}

#pragma mark - 离线播放方法
- (void)playLocalListWithIndex:(NSInteger)index {
    
}


#pragma mark - 私有方法
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
