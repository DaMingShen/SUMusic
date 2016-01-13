//
//  SUNetwork.m
//  SUMusic
//
//  Created by KevinSu on 16/1/12.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUNetwork.h"
#import "SUNetwork+Valid.h"

@implementation SUNetwork

#pragma mark - 获取Manager
+ (AFHTTPRequestOperationManager *)manager {
    
    static AFHTTPRequestOperationManager * manager;
    if (manager == nil) {
        manager = [AFHTTPRequestOperationManager manager];
        
    }
    return manager;
}

#pragma mark - 频道列表
+ (void)fetchChannels {
    
    [[SUNetwork manager] GET:DOU_API_Channels parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        for (NSDictionary * dict in responseObject[@"channels"]) {
            NSLog(@"%@",dict[@"name"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 歌曲列表
+ (void)fetchPlayListWithCompletion:(void(^)(SongInfo * song))completion {
    //type
    //n : 一开始进入豆瓣获取歌曲
    //e : 对该歌曲没有任何操作
    //u : 取消该歌曲的红心
    //r : 对该歌曲加红心
    //s : 下一曲
    //b : 将该歌曲放入垃圾桶
    //p : 单首歌曲播放开始且播放列表已空时发送
    //sid : Song ID
    NSString * url = [NSString stringWithFormat:DOU_API_PlayList,@"n",@"",0.f,@"1"];
    [[SUNetwork manager] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        BASE_INFO_FUN(responseObject);
        [self validDict:responseObject completion:^(NSArray *data) {
            
            if (data && data.count >= 1) {
                
                SongInfo * songInfo = [[SongInfo alloc]initWithDictionary:data[0] dealNull:YES];
                if (completion) completion(songInfo);
                
            }else {
                if (completion) completion(nil);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        if (completion) completion(nil);
    }];
}


@end
