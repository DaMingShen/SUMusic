//
//  MyFavorTableViewCell.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongListTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^downLoadBlock)(UIButton * sender);

@property (weak, nonatomic) IBOutlet UIImageView *songCover;

@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UILabel *artist;

@property (weak, nonatomic) IBOutlet UIImageView *playIndicator;

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


@end
