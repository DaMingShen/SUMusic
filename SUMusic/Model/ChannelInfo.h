//
//  ChannelInfo.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseInfo.h"

@interface ChannelInfo : BaseInfo

@property (nonatomic) NSString *abbr_en;

@property (nonatomic) NSString *channel_id;

@property (nonatomic) NSString *name;

@property (nonatomic) NSString *name_en;

@property (nonatomic) NSString *seq_id;

@property (nonatomic, copy) NSString * jsonString;

@end
