//
//  UserInfo.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_expire forKey:@"expire"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_user_id forKey:@"user_id"];
    [aCoder encodeObject:_user_name forKey:@"user_name"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.expire = [aDecoder decodeObjectForKey:@"expire"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
    }
    return self;
}

- (void)archiverUserInfo {
    
    NSMutableData * data = [[NSMutableData alloc]init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"userInfo"];
    [archiver finishEncoding];
    
    NSString * filePath = [SuGlobal getArchiverFile];
    if ([data writeToFile:filePath atomically:YES]) {
        BASE_INFO_FUN(@"存储UserInfo成功");
    }
}

+ (instancetype)loadUserInfo {
    
    NSData * data = [[NSData alloc]initWithContentsOfFile:[SuGlobal getArchiverFile]];
    NSKeyedUnarchiver * unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    UserInfo * userInfo = [unArchiver decodeObjectForKey:@"userInfo"];
    if (userInfo) {
        BASE_INFO_FUN(@"读取UserInfo成功");
    }else {
        BASE_INFO_FUN(@"读取UserInfo失败");
    }
    return userInfo;
}

@end
