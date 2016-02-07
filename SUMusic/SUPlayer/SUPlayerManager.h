//
//  SUPlayer.h
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, SUPlayStatus) {
    SUPlayStatusNon,
    SUPlayStatusReadyToPlay,
    SUPlayStatusPlay,
    SUPlayStatusPause,
    SUPlayStatusStop
};

@class SongInfo;
@interface SUPlayerManager : NSObject {
    
    id _timeObserve; //监控进度
}

#pragma mark - 状态
/*
 * 播放状态
 */
@property (nonatomic, assign) SUPlayStatus status;

#pragma mark - 列表
/*
 * 歌曲列表
 */
@property (nonatomic, strong) NSMutableArray<SongInfo *> * songList;

/*
 * 当前播放歌曲
 */
@property (nonatomic, strong) SongInfo * currentSong;

/*
 * 当前播放歌曲索引
 */
@property (nonatomic, assign) NSInteger currentSongIndex;

#pragma mark - 频道
/*
 * 当前频道ID
 */
@property (nonatomic, copy) NSString * currentChannelID;

/*
 * 当前频道名称
 */
@property (nonatomic, copy) NSString * currentChannelName;

#pragma mark - 播放器
/*
 * 播放器
 */
@property (nonatomic, strong) AVPlayer * player;

/*
 * 播放器播放状态
 */
@property (nonatomic, assign) BOOL isPlaying;

/*
 * 播放进度
 */
@property (nonatomic, assign) float progress;

/*
 * 缓冲进度
 */
@property (nonatomic, assign) float bufferProgress;

/*
 * 当前播放时间(秒)
 */
@property (nonatomic, copy) NSString * playTime;

/*
 * 总时长(秒)
 */
@property (nonatomic, copy) NSString * playDuration;

/*
 * 当前播放时间(00:00)
 */
@property (nonatomic, copy) NSString * timeNow;

/*
 * 总时长(00:00)
 */
@property (nonatomic, copy) NSString * duration;

/*
 * 获取单例
 */
+ (instancetype)manager;

/*
 * 开始播放
 */
- (void)startPlay;

/*
 * 暂停播放
 */
- (void)pausePlay;

/*
 * 纯粹获取播放列表(打开app、切换频道)
 */
- (void)newChannelPlay;

/*
 * 切歌
 */
- (void)skipSongWithHandle:(void(^)(BOOL isSucc))handle;

/*
 * ban歌
 */
- (void)banSongWithHandle:(void(^)(BOOL isSucc))handle;


#pragma mark - 离线播放方法

/*
 * 是否播放离线音乐
 */
@property (nonatomic, assign) BOOL isOffLinePlay;

/*
 * 播放本地列表(index: 开始的位置)
 */
- (void)playLocalListWithIndex:(NSInteger)index;


@end
