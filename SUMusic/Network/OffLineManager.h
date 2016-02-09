//
//  OffLineManager.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadInfo.h"

@interface OffLineManager : NSObject

@property (nonatomic, strong) NSMutableArray<DownLoadInfo *> * downLoadingList;

/*
 * 单例
 */
+ (instancetype)manager;

/*
 * 下载当前歌曲
 */
- (void)downLoadSong;

/*
 * 下载指定歌曲
 */
- (void)downLoadSongWithSongInfo:(SongInfo *)songInfo;

/*
 * 删除指定歌曲（未下载完成时的删除）
 */
- (void)deleteSongWithSongInfo:(SongInfo *)songInfo;

/*
 * 检测歌曲是否在下载中
 */
- (DownLoadInfo *)checkSongPlayingWithSid:(NSString *)sid;

@end
