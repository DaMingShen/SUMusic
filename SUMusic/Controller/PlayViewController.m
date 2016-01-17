//
//  PlayViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () {
    
    SUPlayerManager * _player;
}

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player = [SUPlayerManager manager];
    
    RegisterNotify(SONGBEGIN, @selector(refreshUI));
}

#pragma mark - 全屏视图
- (void)show {
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.frame = keyWindow.bounds;
    [keyWindow.rootViewController.view addSubview:self.view];
//    [keyWindow addSubview:self.view];
}

- (IBAction)hide:(UIButton *)sender {
    
    [self.view removeFromSuperview];
}


#pragma mark - 刷新界面
- (void)refreshUI {
    
    self.songName.text = _player.currentSong.title;
    [self.songConver sd_setImageWithURL:[NSURL URLWithString:_player.currentSong.picture] placeholderImage:nil];
}



#pragma mark - 播放控制

- (IBAction)playNextSong:(id)sender {
    [_player playNext];
}

- (IBAction)loveCurrentSong:(id)sender {
    
}

- (IBAction)banCurrentSong:(id)sender {
    
}




@end
