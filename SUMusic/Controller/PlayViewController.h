//
//  PlayViewController.h
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UIButton *loveSong;

@property (weak, nonatomic) IBOutlet UIButton *nextSong;

@property (weak, nonatomic) IBOutlet UIButton *banSong;


- (void)show;

@end
