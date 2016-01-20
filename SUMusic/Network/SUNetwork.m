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
+ (void)fetchPlayListWithType:(OperationType)type completion:(void(^)(BOOL isSucc))completion {
    //type
    //n : 一开始进入豆瓣获取歌曲
    //e : 对该歌曲没有任何操作
    //u : 取消该歌曲的红心
    //r : 对该歌曲加红心
    //s : 下一曲
    //b : 将该歌曲放入垃圾桶
    //p : 单首歌曲播放开始且播放列表已空时发送
    //sid : Song ID
    SUPlayerManager * player = [AppDelegate delegate].player;
    NSArray * operationTypeList = @[@"n", @"e", @"u", @"r", @"s", @"b", @"p", ];
    NSString * url = [NSString stringWithFormat:DOU_API_PlayList,operationTypeList[type],player.currentSong.sid,player.timeNow,player.currentChannelID];
    BASE_INFO_FUN(url);
    [[SUNetwork manager] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        BASE_INFO_FUN(responseObject);
        if ([[responseObject objectForKey:NetResult] intValue] == NetOk) {
            
            //将歌曲加入数组
            [player.songList removeAllObjects];
            [player.songList addObjectsFromArray:[SongInfo arrayFromDict:responseObject]];
            
            if (completion) completion(YES);
            
        }else {
            if (completion) completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        if (completion) completion(NO);
    }];
}

+ (void)fetchMyFavorSongList {
    
    SUPlayerManager * player = [AppDelegate delegate].player;
    UserInfo * userInfo = [AppDelegate delegate].userInfo;
    NSArray * operationTypeList = @[@"n", @"e", @"u", @"r", @"s", @"b", @"p", ];
    NSString * url = [NSString stringWithFormat:DOU_API_PlayList_Login,operationTypeList[6],player.currentSong.sid,player.timeNow,@"-3",userInfo.user_id,userInfo.expire,userInfo.token];
    BASE_INFO_FUN(url);
    [[SUNetwork manager] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        BASE_INFO_FUN(responseObject);
        if ([[responseObject objectForKey:NetResult] intValue] == NetOk) {
            
            //将歌曲加入数组
            [player.songList removeAllObjects];
            [player.songList addObjectsFromArray:[SongInfo arrayFromDict:responseObject]];
            
            
        }else {
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];

}


@end
