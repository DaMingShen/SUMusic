//
//  DownLoadInfo.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/3.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseInfo.h"

@interface DownLoadInfo : BaseInfo

@property (nonatomic, copy) NSString * sid;

@property (nonatomic, copy) NSString * url;

@property (nonatomic, assign) int percent;

@property (nonatomic, assign) BOOL isDownLoading;

@property (nonatomic, assign) BOOL isSucc;

@property (nonatomic, assign) BOOL isFail;

@end
