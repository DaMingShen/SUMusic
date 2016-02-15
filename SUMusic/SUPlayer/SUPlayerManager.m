//
//  SUPlayer.m
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUPlayerManager.h"

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
    }
    return self;
}
#pragma mark - 列表
/*
 * 当前播放歌曲图片
 */
- (UIImage *)coverImg {
    if (_coverImg == nil) {
        return DefaultImg;
    }
    return _coverImg;
}

#pragma mark - 频道

/*
 * 当前频道
 */
- (ChannelInfo *)currentChannel {
    if (_currentChannel == nil) {
        _currentChannel = DEFAULTCHANNEL;
    }
    return _currentChannel;
}

#pragma mark - 播放器
/*
 * 播放器播放状态
 */
- (BOOL)isPlaying {
    return self.player.rate == 1;
}

/*
 * 总时长(秒)
 */
- (void)setPlayDuration:(NSString *)playDuration {
    if (![_playDuration isEqualToString:playDuration] &&
        ![playDuration isEqualToString:@"0"]) {
        _playDuration = playDuration;
        [[AppDelegate delegate] configNowPlayingCenter];
    }else {
        _playDuration = playDuration;
    }
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
 * 是否播放离线音乐
 */
- (void)setIsOffLinePlay:(BOOL)isOffLinePlay {
    _isOffLinePlay = isOffLinePlay;
    if (isOffLinePlay) {
        SendNotify(PLAYMODECHANGE, nil)
    }else {
        SendNotify(PLAYMODECHANGE, nil)
    }
}

/*
 * 开始播放
 */
- (void)startPlay {
    if (self.status == SUPlayStatusPause) {
        self.status = SUPlayStatusPlay;
        SendNotify(SONGPLAYSTATUSCHANGE, nil)
    }
    [self.player play];
    
    //如果是最后一首，加载更多歌曲
    if (!self.isOffLinePlay && self.currentSongIndex == self.songList.count - 1) [self loadMoreSong];
}

/*
 * 暂停播放
 */
- (void)pausePlay {
    self.status = SUPlayStatusPause;
    [self.player pause];
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}

/*
 * 播放完毕
 */
- (void)endPlay {
    if (self.player == nil) return;
    
    self.status = SUPlayStatusStop;
    [self.player pause];
    
    //移除监控
    [self removeObserver];
    
    //重置进度
    self.progress = 0.f;
    self.playTime = @"0";
    self.playDuration = @"0";
    
    //重置封面
    self.coverImg = DefaultImg;

    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}

/*
 * 自然播放下一首
 */
- (void)playNext {
    
    [self endPlay];
    if (!self.isOffLinePlay) {
        //先报告上一首歌已完成
        [self reportSongEnd];
    }
    [self loadSongInfoWithNewList:NO];
    [self startPlay];
}

#pragma mark - 加载歌曲
/*
 * 加载歌曲
 * reset: 从头开始
 */
- (void)loadSongInfoWithNewList:(BOOL)isNew {
    
    //更新当前歌曲位置
    self.currentSongIndex = isNew ? 0 : self.currentSongIndex + 1;
    //离线播放
    if (self.isOffLinePlay) {
        //上一首<0则回到最后一首
        if (self.currentSongIndex < 0) {
            self.currentSongIndex = self.songList.count - 1;
        }
        //播放到最后一首则回到第一首
        if (self.currentSongIndex >= self.songList.count) {
            self.currentSongIndex = 0;
        }
    };
    //更新当前歌曲信息
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
    
    //重置播放器
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    if (self.player == nil) {
        self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    }else {
        [self.player replaceCurrentItemWithPlayerItem:songItem];
    }
    
    //给当前歌曲添加监控
    [self addObserver];
    
    self.status = SUPlayStatusLoadSongInfo;
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}

#pragma mark - KVO
- (void)addObserver {
    
    AVPlayerItem * songItem = self.player.currentItem;
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    
    //更新播放器进度
    WEAKSELF
    _timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
//        SuLog(@"%f, %f",current, total);
        if (current) {
            weakSelf.progress = current / total;
            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
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
    
    if (_timeObserve) {
        [self.player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
}


- (void)playbackFinished:(NSNotification *)notice {
    BASE_INFO_FUN(@"播放完成");
    [self playNext];
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
                BASE_INFO_FUN(@"KVO：未知状态");
                break;
            case AVPlayerStatusReadyToPlay:
                self.status = SUPlayStatusReadyToPlay;
                BASE_INFO_FUN(@"KVO：准备完毕");
                break;
            case AVPlayerStatusFailed:
                BASE_INFO_FUN(@"KVO：加载失败");
                break;
            default:
                break;
        }
        SendNotify(SONGPLAYSTATUSCHANGE, nil)
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
//        SuLog(@"共缓冲%.2f",totalBuffer);
    }
}


#pragma mark - 播放器网络操作
/*
 * app启动完成的播放
 */
- (void)launchPlay {
    
    //有网络：播放私人频道
    if ([[SuNetworkMonitor monitor] isNetworkEnable]) {
        [self newChannelPlay];
    }
    else {
        //无网络and有离线歌曲：播放离线歌曲
        if ([SuDBManager fetchOffLineList].count > 0) {
            [self playOffLineList:[SuDBManager fetchOffLineList] index:0];
        }
        //无网络and无离线歌曲：提示没有歌曲播放
        else {
            [SuGlobal alertMessage:@"没有歌曲播放"];
        }
    }
}

/*
 * 纯粹获取播放列表(切换频道)
 */
- (BOOL)newChannelPlay {
    
    [self endPlay];
    
    if (![[SuNetworkMonitor monitor] isNetworkEnable]) {
        [TopAlertView showWithType:TopAlertTypeBan message:@"网络不可用"];
        return NO;
    }

    [SUNetwork fetchPlayListWithType:OperationTypeNone completion:^(BOOL isSucc) {
        if (isSucc) {
            if (self.isOffLinePlay) self.isOffLinePlay = NO;
            [self loadSongInfoWithNewList:YES];
            [self startPlay];
        }else {
            //跳转到离线播放
        };
    }];
    
    return YES;
}

/*
 * 切歌
 */
- (void)skipSongWithHandle:(void(^)(BOOL isSucc))handle {
    
    [self endPlay];
    
    if (self.isOffLinePlay) {
        [self loadSongInfoWithNewList:NO];
        [self startPlay];
    }
    else {
        [SUNetwork fetchPlayListWithType:OperationTypeSkip completion:^(BOOL isSucc) {
            if (isSucc) {
                [self loadSongInfoWithNewList:YES];
                [self startPlay];
            }
            if (handle) handle(isSucc);
        }];
    }
}

/*
 * ban歌
 */
- (void)banSongWithHandle:(void(^)(BOOL isSucc))handle {
    
    [self endPlay];
    
    if (self.isOffLinePlay) {
        //因为loadsong会将index加1，这里要减2，才是上一首
        self.currentSongIndex -= 2;
        [self loadSongInfoWithNewList:NO];
        [self startPlay];
    }
    else {
        [SUNetwork fetchPlayListWithType:OperationTypeBan completion:^(BOOL isSucc) {
            if (isSucc) {
                [self loadSongInfoWithNewList:YES];
                [self startPlay];
            }
            if (handle) handle(isSucc);
        }];
    }
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

#pragma mark - 离线播放
- (void)playOffLineList:(NSArray *)songList index:(NSInteger)index {
    [self endPlay];
    //如果songlist为nil则无离线歌曲
    if (songList == nil) {
        [SuGlobal alertMessage:@"没有歌曲播放"];
        return;
    }
    //切换到离线播放
    if (!self.isOffLinePlay) self.isOffLinePlay = YES;
    //加载列表
    [self.songList removeAllObjects];
    [self.songList addObjectsFromArray:songList];
    //因为加载的是下一首歌的信息， 这里要减1
    self.currentSongIndex = index - 1;
    //加载信息
    [self loadSongInfoWithNewList:NO];
    //播放
    [self startPlay];
}

#pragma mark - 播放分享歌曲
- (void)playSharedSong:(SongInfo *)info {
    //正在播放该歌曲的情况
    if (!self.isOffLinePlay && [self.currentSong.sid isEqualToString:info.sid]) return;
    //设置为非离线播放
    if (self.isOffLinePlay) {
        self.currentChannel = DEFAULTCHANNEL;
        self.isOffLinePlay = NO;
    }
    
    [self endPlay];
    [self.songList removeAllObjects];
    [self.songList addObject:info];
    [self loadSongInfoWithNewList:YES];
    [self startPlay];
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

#pragma mark - 网络权限


@end
