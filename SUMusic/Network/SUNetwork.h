//
//  SUNetwork.h
//  SUMusic
//
//  Created by KevinSu on 16/1/12.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUNetwork : NSObject

+ (AFHTTPRequestOperationManager *)manager;

+ (void)fetchChannels;

+ (void)fetchPlayList;

@end
