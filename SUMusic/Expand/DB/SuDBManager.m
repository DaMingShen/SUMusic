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
#define FavorListTable @"FavorListTable"
#define SharedListTable @"SharedListTable"

@implementation SuDBManager

#pragma mark -
+ (void)saveToDownList {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSString * sid = [AppDelegate delegate].player.currentSong.sid;
    NSString * jsonStr = [AppDelegate delegate].player.currentSong.jsonString;
    NSDictionary * dictContent = [NSDictionary dictionaryWithObjectsAndKeys:sid,@"sid",jsonStr,@"songInfo", nil];
    [SuDBManager save:dictContent primaryKey:@"sid" inTable:DownListTable inDBFile:path];
}

+ (NSArray *)fetchDownList {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSArray * result = [SuDBManager fetchWithCondition:nil forFields:@[@"sid", @"songInfo"] inTable:DownListTable inDBFile:path];
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

+ (SongInfo *)fetchSongInfoWithSid:(NSString *)sid {
    
    NSString * path = [SuGlobal getUserDBFile];
    NSDictionary * dictCondiction = [NSDictionary dictionaryWithObjectsAndKeys:sid,@"sid", nil];
    NSArray * result = [SuDBManager fetchWithCondition:dictCondiction forFields:@[@"sid", @"songInfo"] inTable:DownListTable inDBFile:path];
    if (result.count > 0) {
        NSDictionary * rsDict = result[0];
        NSString * jsonStr = rsDict[@"songInfo"];
        return [SongInfo infoFromDict:[NSDictionary dictionaryWithJsonString:jsonStr]];
    }
    return nil;
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

@end
