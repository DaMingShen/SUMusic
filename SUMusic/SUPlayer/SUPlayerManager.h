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
 * 缓冲进度
 */
@property (nonatomic, assign) float bufferProgress;

/*
 * 播放进度
 */
@property (nonatomic, assign) float progress;

/*
 * 总时长
 */
@property (nonatomic, assign) float duration;


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
 * 继续播放
 */
- (void)restartPlay;

/*
 * 播放下一首
 */
- (void)playNext;

/*
 * 播放上一首
 */
- (void)playLast;


@end
