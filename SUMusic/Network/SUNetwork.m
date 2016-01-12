//
//  SUNetwork.m
//  SUMusic
//
//  Created by KevinSu on 16/1/12.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SUNetwork.h"

@implementation SUNetwork

+ (AFHTTPRequestOperationManager *)manager {
    
    static AFHTTPRequestOperationManager * manager;
    if (manager == nil) {
        manager = [AFHTTPRequestOperationManager manager];
        
    }
    return manager;
}

+ (void)fetchChannels {
    
    [[SUNetwork manager] GET:DOU_API_Channels parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        for (NSDictionary * dict in responseObject[@"channels"]) {
            NSLog(@"%@",dict[@"name"]);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+ (void)fetchPlayList {
    //type
    //n : 一开始进入豆瓣获取歌曲
    //e : 对该歌曲没有任何操作
    //u : 取消该歌曲的红心
    //r : 对该歌曲加红心
    //s : 下一曲
    //b : 将该歌曲放入垃圾桶
    //p : 单首歌曲播放开始且播放列表已空时发送
    //sid : Song ID
    //http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite
    NSString * url = [NSString stringWithFormat:DOU_API_PlayList,@"n",@"",0.f,@"1"];
    [[SUNetwork manager] GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
