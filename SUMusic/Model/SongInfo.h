//
//  SongInfo.h
//  SUMusic
//
//  Created by KevinSu on 16/1/10.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseInfo.h"

@class Singers;
@interface SongInfo : BaseInfo

@property (nonatomic, copy) NSString * like;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *album;

@property (nonatomic, copy) NSString *sha256;

@property (nonatomic, copy) NSString *kbps;

@property (nonatomic, copy) NSString *alert_msg;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSArray<Singers *> *singers;

@property (nonatomic, copy) NSString * length;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *albumtitle;

@property (nonatomic, copy) NSString *file_ext;

@property (nonatomic, copy) NSString *ssid;

@property (nonatomic, copy) NSString *artist;

@property (nonatomic, copy) NSString * status;

@property (nonatomic, copy) NSString *subtype;

@property (nonatomic, copy) NSString * jsonString;

@end


@interface Singers : BaseInfo

@property (nonatomic, assign) NSInteger related_site_id;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL is_site_artist;

@end

