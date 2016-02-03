//
//  MyFavorTableViewCell.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SongListTableViewCell.h"

@implementation SongListTableViewCell


- (IBAction)downLoadNow:(UIButton *)sender {
    if (self.downLoadBlock) self.downLoadBlock(sender);
}

@end
