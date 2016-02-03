//
//  OffLineManager.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadInfo.h"

@interface OffLineManager : NSObject

@property (nonatomic, strong) NSMutableArray<DownLoadInfo *> * downLoadingList;

+ (instancetype)manager;

- (void)downLoadSong;

- (void)downLoadSongWithSongInfo:(SongInfo *)songInfo;

@end
