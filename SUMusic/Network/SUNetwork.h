//
//  SUNetwork.h
//  SUMusic
//
//  Created by KevinSu on 16/1/12.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongInfo.h"

typedef NS_ENUM(NSInteger, OperationType) {
    OperationTypeNewPlayList,
    OperationTypeNoAction,
    OperationTypeUnLove,
    OperationTypeLove,
    OperationTypeSkip,
    OperationTypeBan,
    OperationTypePlay
};

@interface SUNetwork : NSObject

+ (AFHTTPRequestOperationManager *)manager;

#pragma mark - 登陆
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd completion:(void(^)(BOOL isSucc, NSString * msg))completion;

#pragma mark - 频道列表
+ (void)fetchChannelsWithCompletion:(void(^)(BOOL isSucc, NSArray * channels))completion;

#pragma mark - 歌曲操作
+ (void)fetchPlayListWithType:(OperationType)type completion:(void(^)(BOOL isSucc))completion;

+ (void)fetchMyFavorSongList;

@end
