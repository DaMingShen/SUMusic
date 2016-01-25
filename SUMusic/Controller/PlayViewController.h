//
//  PlayViewController.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayViewController : BaseViewController

@property (nonatomic, strong) UIImage * coverImg;

@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UIButton *loveSong;

@property (weak, nonatomic) IBOutlet UIButton *nextSong;

@property (weak, nonatomic) IBOutlet UIButton *banSong;

/**
 *  弹出界面
 */
- (void)show;

/**
 *  继续播放
 */
- (IBAction)goOnPlaying:(UITapGestureRecognizer *)sender;

/**
 *  暂停播放
 */
- (IBAction)pausePlaying:(UITapGestureRecognizer *)sender;

/**
 *  下一首歌曲
 */
- (IBAction)skipSong:(UIButton *)sender;

@end
