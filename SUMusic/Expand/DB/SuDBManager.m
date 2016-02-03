//
//  SuDBManager.m
//  DBTest
//
//  Created by 万众科技 on 15/11/27.
//  Copyright © 2015年 万众科技. All rights reserved.
//

#import "SuDBManager.h"
#import "SuDBManager+private.h"

#define DownListTable @"DownListTable"
#define OffLineTable @"OffLineTable"

#define FavorListTable @"FavorListTable"
#define SharedListTable @"SharedListTable"

@implementation SuDBManager

#pragma mark - 离线(未下载列表)
+ (void)saveToDownList {
    [self saveInfoToTable:DownListTable];
}

+ (NSArray *)fetchDownList {
    return [self fetchListFromTable:DownListTable];
}

+ (SongInfo *)fetchSongInfoWithSid:(NSString *)sid {
    
    NSArray * songInfos = [self fetchListFromTable:DownListTable];
    for (SongInfo * info in songInfos) {
        if ([info.sid isEqualToString:sid]) {
            return info;
        }
    }
    return nil;
}

+ (void)deleteFromDownListWithSid:(NSString *)sid {
    [self deleteWithSid:sid fromTable:DownListTable];
}


#pragma mark - 离线(已下载列表)
+ (void)saveToOffLineListWithSongInfo:(SongInfo *)info {
    [self saveInfo:info toTable:OffLineTable];
}

+ (NSArray *)fetchOffLineList {
    return [self fetchListFromTable:OffLineTable];
}


#pragma mark - 收藏
+ (void)saveToFavorList {
    [self saveInfoToTable:FavorListTable];
}

+ (NSArray *)fetchFavorList {
    return [self fetchListFromTable:FavorListTable];
}

#pragma mark - 分享的歌曲
+ (void)saveToSharedList {
    [self saveInfoToTable:SharedListTable];
}

+ (NSArray *)fetchSharedList {
    return [self fetchListFromTable:SharedListTable];
}

#pragma mark - 公共方法
+ (void)saveInfoToTable:(NSString *)table {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSString * sid = [AppDelegate delegate].player.currentSong.sid;
    NSString * jsonStr = [AppDelegate delegate].player.currentSong.jsonString;
    NSDictionary * dictContent = [NSDictionary dictionaryWithObjectsAndKeys:sid,@"sid",jsonStr,@"songInfo", nil];
    [SuDBManager save:dictContent primaryKey:@"sid" inTable:table inDBFile:path];
}

+ (void)saveInfo:(SongInfo *)info toTable:(NSString *)table {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSString * sid = info.sid;
    NSString * jsonStr = info.jsonString;
    NSDictionary * dictContent = [NSDictionary dictionaryWithObjectsAndKeys:sid,@"sid",jsonStr,@"songInfo", nil];
    [SuDBManager save:dictContent primaryKey:@"sid" inTable:table inDBFile:path];
}

+ (NSArray *)fetchListFromTable:(NSString *)table {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSArray * result = [SuDBManager fetchWithCondition:nil forFields:@[@"sid", @"songInfo"] inTable:table inDBFile:path];
    if (result.count > 0) {
        NSMutableArray * list = [NSMutableArray array];
        for (NSDictionary * rsDict in result) {
            NSString * jsonStr = rsDict[@"songInfo"];
            [list addObject:[SongInfo infoFromDict:[NSDictionary dictionaryWithJsonString:jsonStr]]];
        }
        return list;
    }
    return nil;
}

+ (void)deleteWithSid:(NSString *)sid fromTable:(NSString *)table {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSDictionary * conditionDict = [NSDictionary dictionaryWithObjectsAndKeys:sid,@"sid", nil];
    [SuDBManager deleteWithCondition:conditionDict inTable:table inDBFile:path];
}


@end
