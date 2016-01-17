//
//  UserInfo.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseInfo.h"

@interface UserInfo : BaseInfo <NSCoding>

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * expire;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * user_name;

- (void)archiverUserInfo;
+ (instancetype)loadUserInfo;

@end
