//
//  SuDBManager.h
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SuDBManager : NSObject

#pragma mark - 离线
+ (void)saveToDownList;

+ (NSArray *)fetchDownList;

+ (SongInfo *)fetchSongInfoWithSid:(NSString *)sid;

#pragma mark - 收藏
+ (void)saveToFavorList;

+ (NSArray *)fetchFavorList;

#pragma mark - 分享的歌曲
+ (void)saveToSharedList;

+ (NSArray *)fetchSharedList;

@end
