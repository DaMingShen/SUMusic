//
//  SUNetwork.m
//  SUMusic
//
//  Created by KevinSu on 16/1/12.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUNetwork.h"
#import "UserInfo.h"
#import "ChannelInfo.h"

@implementation SUNetwork

#pragma mark - 获取Manager
+ (AFHTTPRequestOperationManager *)manager {
    
    static AFHTTPRequestOperationManager * manager;
    if (manager == nil) {
        manager = [AFHTTPRequestOperationManager manager];
        
    }
    return manager;
}

#pragma mark - 登陆
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd completion:(void(^)(BOOL isSucc, NSString * msg))completion {
    
    NSDictionary * loginParam = @{@"app_name":@"radio_android",
                                  @"version":@"100",
                                  @"email":userName,
                                  @"password":pwd };
    
    [[SUNetwork manager] POST:DOU_API_Login parameters:loginParam success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        BASE_INFO_FUN(responseObject);
        if ([[responseObject objectForKey:NetResult] intValue] == NetOk) {
            //解析数据
            UserInfo * userInfo = [[UserInfo alloc]initWithDictionary:responseObject dealNull:YES];
            [AppDelegate delegate].userInfo = userInfo;
            //本地化保存登陆信息
            [userInfo archiverUserInfo];
            [SuGlobal setLoginStatus:YES];
            //回调block
            if (completion) completion(YES, @"登陆成功");
        }else {
            if (completion) completion(NO, [responseObject objectForKey:NetResult]);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        BASE_INFO_FUN(error);
        if (completion) completion(NO, @"请检查您的网络");
    }];
}

#pragma mark - 频道列表
+ (void)fetchChannelsWithCompletion:(void(^)(BOOL isSucc, NSArray * channels))completion {
    
    [[SUNetwork manager] GET:DOU_API_Channels parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        BASE_INFO_FUN(responseObject);
        BASE_INFO_FUN(@"获取频道列表成功");
        NSArray * channels = [ChannelInfo arrayFromArray:responseObject[NetChannel]];
        if (completion) completion(YES, channels);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        BASE_INFO_FUN(@"获取频道列表失败");
        if (completion) completion(NO, nil);
    }];
}

#pragma mark - 歌曲操作
//n : None                  单纯获取歌曲（比如一开始进入豆瓣）
//e : Normally ended a song 正常播放完一首歌
//u : Unlike（un-heart）     取消该歌曲的红心
//r : Like（heart）          对该歌曲加红心
//s : Skip                  下一曲
//b : Ban                   将该歌曲放入垃圾桶
//p : 单首歌曲播放开始且播放列表已空时发送, 长报告
+ (void)fetchPlayListWithType:(OperationType)type completion:(void(^)(BOOL isSucc))completion {

    //取得管理实例
    SUPlayerManager * player = [AppDelegate delegate].player;
    UserInfo * userInfo = [AppDelegate delegate].userInfo;
    
    //生成链接
    NSArray * operationTypeList = @[@"n", @"e", @"u", @"r", @"s", @"b",@"p"];
    NSString * url;
    if ([SuGlobal checkLogin]) {
        url = [NSString stringWithFormat:DOU_API_PlayList_Login,operationTypeList[type],player.currentSong.sid,player.playTime,player.currentChannelID,userInfo.user_id,userInfo.expire,userInfo.token];
    }else {
        url = [NSString stringWithFormat:DOU_API_PlayList,operationTypeList[type],player.currentSong.sid,player.playTime,player.currentChannelID];
    }
    BASE_INFO_FUN(url);
    
    //请求数据
    [[SUNetwork manager] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        BASE_INFO_FUN(responseObject);
        if ([[responseObject objectForKey:NetResult] intValue] == NetOk) {
            //正常播放完一首歌 : 直接返回请求结果，不用切歌
            if (type == OperationTypeEnd) {
                
                if (completion) completion(YES);
            }
            //单纯获取歌曲、跳过、ban掉歌曲 : 停止播放然后切歌
            else if (type == OperationTypeNone  ||
                     type == OperationTypeSkip  ||
                     type == OperationTypeBan ) {
                
                [player.songList removeAllObjects];
                [player.songList addObjectsFromArray:[SongInfo arrayFromDict:responseObject]];
                if (completion) completion(YES);
            }
            //播放到列表最后一首、红心、取消红心 : 保留当前歌曲并且获取新的歌曲列表到播放列表
            else if (type == OperationTypePlay  ||
                     type == OperationTypeHeart ||
                     type == OperationTypeUnHeart) {
                
                SongInfo * currentSong = [player.songList objectAtIndex:player.currentSongIndex];
                [player.songList removeAllObjects];
                [player.songList addObject:currentSong];
                player.currentSongIndex = 0;
                [player.songList addObjectsFromArray:[SongInfo arrayFromDict:responseObject]];
                if (completion) completion(YES);
            }
        }
        else {
            if (completion) completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (completion) completion(NO);
    }];
}

@end
