//
//  SuDBManager.h
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SuDBManager : NSObject

#pragma mark - 离线(未下载列表)
/*
 * 保存歌曲到待离线歌曲列表
 */
+ (void)saveToDownList;

/*
 * 获取待离线歌曲列表
 */
+ (NSArray *)fetchDownList;

/*
 * 从待离线歌曲列表删除歌曲
 */
+ (void)deleteFromDownListWithSid:(NSString *)sid;

/*
 * 从待离线歌曲列表获取歌曲信息
 */
+ (SongInfo *)fetchSongInfoWithSid:(NSString *)sid;

#pragma mark - 离线(已下载列表)
/*
 * 保存歌曲到已离线歌曲列表
 */
+ (void)saveToOffLineListWithSongInfo:(SongInfo *)info;

/*
 * 获取已离线歌曲列表
 */
+ (NSArray *)fetchOffLineList;

/*
 * 从离线歌曲列表删除歌曲
 */
+ (void)deleteFromOffLineListWithSid:(NSString *)sid;

#pragma mark - 收藏
/*
 * 收藏当前频道
 */
+ (void)saveToFavorList;

/*
 * 获取收藏频道列表
 */
+ (NSArray *)fetchFavorList;

/*
 * 取消收藏当前频道
 */
+ (void)deleteFromFavorListWithSid:(NSString *)sid;

#pragma mark - 分享的歌曲
/*
 * 保存当前歌曲到分享歌曲列表
 */
+ (void)saveToSharedList;

/*
 * 获取分享歌曲列表
 */
+ (NSArray *)fetchSharedList;

@end
