//
//  SUPlayer.h
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SongInfo.h"
#import "ChannelInfo.h"

typedef NS_ENUM(NSInteger, SUPlayStatus) {
    SUPlayStatusNon,
    SUPlayStatusLoadSongInfo,
    SUPlayStatusReadyToPlay,
    SUPlayStatusPlay,
    SUPlayStatusPause,
    SUPlayStatusStop
};

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

/*
 * 当前播放歌曲图片
 */
@property (nonatomic, strong) UIImage * coverImg;

#pragma mark - 频道

/*
 * 当前频道
 */
@property (nonatomic, strong) ChannelInfo * currentChannel;


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
 * app启动完成的播放
 */
- (void)launchPlay;

/*
 * 纯粹获取播放列表(打开app、切换频道)
 */
- (void)newChannelPlayWithChannel:(ChannelInfo *)channel;

/*
 * 切歌
 */
- (void)skipSongWithHandle:(void(^)(BOOL isSucc))handle;

/*
 * ban歌
 */
- (void)banSongWithHandle:(void(^)(BOOL isSucc))handle;

/*
 * 播放分享歌曲
 */
- (void)playSharedSong:(SongInfo *)info;


/*
 * 是否播放离线音乐
 */
@property (nonatomic, assign) BOOL isOffLinePlay;

/*
 * 播放离线音乐(index: 开始的位置)
 */
- (void)playOffLineList:(NSArray *)songList index:(NSInteger)index;


@end
