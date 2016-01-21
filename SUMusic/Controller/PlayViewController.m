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
    
    NSTimer * _timer;
}

@property (weak, nonatomic) IBOutlet UIView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *currentProgress;
@property (weak, nonatomic) IBOutlet UIView *progressPoint;
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UIImageView *songCover;
@property (weak, nonatomic) IBOutlet UILabel *singer;


@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _player = [SUPlayerManager manager];
    
    RegisterNotify(SONGBEGIN, @selector(loadSongInfo));
    RegisterNotify(SONGEND, @selector(songEndPlaying));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshProgress];
    if (_player.isPlaying) [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeTimer];
}

- (void)setupUI {
        
    self.songCover.layer.masksToBounds = YES;
    self.songCover.layer.cornerRadius = self.songCover.h / 2.0;
    self.songCover.layer.borderWidth = 5.0;
    self.songCover.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.progressPoint.layer.masksToBounds = YES;
    self.progressPoint.layer.cornerRadius = self.progressPoint.h / 2.0;
}

#pragma mark - 全屏视图
- (void)show {
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
    [keyWindow addSubview:self.view];
    
    keyWindow.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        keyWindow.userInteractionEnabled = YES;
    }];
}

- (IBAction)hide:(UIButton *)sender {
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    keyWindow.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.view.y = ScreenH;
    } completion:^(BOOL finished) {
        keyWindow.userInteractionEnabled = YES;
        [self.view removeFromSuperview];
    }];
}


#pragma mark - 刷新界面
- (void)loadSongInfo {
    
    self.songName.text = _player.currentSong.title;
    self.singer.text = [NSString stringWithFormat:@"—   %@    —",_player.currentSong.artist];
    self.loveSong.selected = _player.currentSong.like.intValue == 1 ? YES : NO;
    [self.songCover sd_setImageWithURL:[NSURL URLWithString:_player.currentSong.picture] placeholderImage:DefaultImg];
    [self addTimer];
}

- (void)songEndPlaying {
    
    self.songCover.transform = CGAffineTransformMakeRotation(0.0);
}

- (void)refreshProgress {
    
    //显示时间
    self.playTime.text = _player.timeNow;
    self.totalTime.text = _player.duration;
    
    //进度条
    float pointW = self.progressPoint.w / 2.0;
    float progress = isnan(_player.progress) ? 0.f : _player.progress;
    self.currentProgress.w = pointW  + (self.progressBar.w - pointW) * progress;
    self.progressPoint.centerX = self.progressBar.x + self.currentProgress.w;
    
    //图片旋转
    self.songCover.transform = CGAffineTransformRotate(self.songCover.transform, M_PI / 1440);
}

#pragma mark - timer
- (void)addTimer {
    
    if (_timer) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - 播放控制

- (IBAction)skipSong:(UIButton *)sender {
    [_player skipSong];
}

- (IBAction)loveSong:(UIButton *)sender {
    OperationType type = sender.selected ? OperationTypeUnHeart : OperationTypeHeart;
    [SUNetwork fetchPlayListWithType:type completion:^(BOOL isSucc) {
        if (isSucc) sender.selected = !sender.selected;
    }];
}

- (IBAction)banSong:(UIButton *)sender {
    [_player banSong];
}




@end
