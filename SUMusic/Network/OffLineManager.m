//
//  OffLineManager.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "OffLineManager.h"

@implementation OffLineManager

+ (void)offLineSong {
    AFHTTPRequestOperation * op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[AppDelegate delegate].player.currentSong.url]]];
    [op setOutputStream:[NSOutputStream outputStreamToFileAtPath:[SuGlobal getOffLineFilePath] append:NO]];
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
    }];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"下载成功");
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"下载失败");
    }];
    [op start];
}

@end
