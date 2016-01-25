//
//  SUPlayer.h
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@class SongInfo;
@interface SUPlayerManager : NSObject

/*
 * 播放器
 */
@property (nonatomic, strong) MPMoviePlayerController * player;

/*
 * 播放器播放状态
 */
@property (nonatomic, assign) BOOL isPlaying;

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
 * 当前频道
 */
@property (nonatomic, copy) NSString * currentChannelID;

/*
 * 缓冲进度
 */
@property (nonatomic, assign) float bufferProgress;

/*
 * 播放进度
 */
@property (nonatomic, assign) float progress;

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


#pragma mark - ---> 方法 <---
/*
 * 获取单例
 */
+ (instancetype)manager;

/*
 * 初始化
 */
- (void)initialPlayer;

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
- (void)skipSong;

/*
 * ban歌
 */
- (void)banSong;



@end
