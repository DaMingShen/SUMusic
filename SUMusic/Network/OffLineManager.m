//
//  OffLineManager.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "OffLineManager.h"

@implementation OffLineManager

+ (instancetype)manager {
    static OffLineManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OffLineManager alloc]init];
        manager.downLoadingList = [NSMutableArray array];
    });
    return manager;
}

#pragma mark - 下载正在播放的歌曲
- (void)downLoadSong {
    //先添加到下载列表
    [SuDBManager saveToDownList];
    
    //添加模型
    DownLoadInfo * info = [[DownLoadInfo alloc]init];
    info.sid = [AppDelegate delegate].player.currentSong.sid;
    info.url = [AppDelegate delegate].player.currentSong.url;
    info.percent = 0;
    [self.downLoadingList addObject:info];
    
    //下载歌曲
    [self offLineSongWithSongInfo:info];
}

#pragma mark - 下载未下载完成的歌曲
- (void)downLoadSongWithSongInfo:(SongInfo *)songInfo {
    
    //添加模型
    DownLoadInfo * info = [[DownLoadInfo alloc]init];
    info.sid = songInfo.sid;
    info.url = songInfo.url;
    info.percent = 0;
    [self.downLoadingList addObject:info];
    
    //下载歌曲
    [self offLineSongWithSongInfo:info];
}


- (void)offLineSongWithSongInfo:(DownLoadInfo *)info {
    
    AFHTTPRequestOperation * op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:info.url]]];
    NSString * path = [[SuGlobal getOffLinePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",info.sid,@".mp4"]];
    [op setOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO]];
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        info.percent = (int)((float)totalBytesRead / totalBytesExpectedToRead * 100);
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"下载成功");
        info.isSucc = YES;
        [self.downLoadingList removeObject:info];
        
        //从download中移到offline中
        SongInfo * songInfo = [SuDBManager fetchSongInfoWithSid:info.sid];
        [SuDBManager saveToOffLineListWithSongInfo:songInfo];
        [SuDBManager deleteFromDownListWithSid:info.sid];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        info.isFail = YES;
        [self.downLoadingList removeObject:info];
        NSLog(@"下载失败");
    }];
    
    info.op = op;
    [op start];
}

- (void)deleteSongWithSongInfo:(SongInfo *)songInfo {
    //如果正在下载，先停止
    DownLoadInfo * info = [self checkSongPlayingWithSid:songInfo.sid];
    if (info != nil) {
        [info.op cancel];
    }
    
    //删除文件
    NSString * path = [[SuGlobal getOffLinePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",songInfo.sid,@".mp4"]];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        if ([fileManager removeItemAtPath:path error:nil]) {
            BASE_INFO_FUN(@"删除成功");
        }else {
            BASE_INFO_FUN(@"删除失败");
        }
    }else {
        BASE_INFO_FUN(@"文件不存在");
    }
}

#pragma mark - 检测歌曲是否在下载中
- (DownLoadInfo *)checkSongPlayingWithSid:(NSString *)sid {
    for (DownLoadInfo * info in self.downLoadingList) {
        if ([info.sid isEqualToString:sid]) {
            return info;
        }
    }
    return nil;
}

@end
