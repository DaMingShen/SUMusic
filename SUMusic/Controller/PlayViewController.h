//
//  PlayViewController.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayViewController : BaseViewController

/**
 *  界面
 */
- (void)show;

- (void)launchShow;

- (IBAction)hide:(UIButton *)sender;

/**
 *  下一首歌曲
 */
- (IBAction)skipSong:(UIButton *)sender;

@end
