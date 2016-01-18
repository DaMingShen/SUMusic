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

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *currentProgress;
@property (weak, nonatomic) IBOutlet UIView *progressPoint;
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;


@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _player = [SUPlayerManager manager];
    
    RegisterNotify(SONGBEGIN, @selector(refreshUI));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_player.isPlaying) [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeTimer];
}

- (void)setupUI {
    
    self.songConver.layer.masksToBounds = YES;
    self.songConver.layer.cornerRadius = self.songConver.h / 2.0;
    
    self.progressPoint.layer.masksToBounds = YES;
    self.progressPoint.layer.cornerRadius = self.progressPoint.h / 2.0;
    
    /*
    UIVisualEffectView * visualEfView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = self.bgImg.frame;
    visualEfView.alpha = 1.0;
    [self.bgImg addSubview:visualEfView];
     */
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
- (void)refreshUI {
    
    self.songName.text = _player.currentSong.title;
    [self.songConver sd_setImageWithURL:[NSURL URLWithString:_player.currentSong.picture] placeholderImage:nil];
//    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:_player.currentSong.picture] placeholderImage:nil];
    
    [self addTimer];
}

- (void)refreshProgress {
    
    self.playTime.text = _player.timeNow;
    self.totalTime.text = _player.duration;
    
    float pointW = self.progressPoint.w / 2.0;
    float progress = _player.progress;
    if (isnan(progress)) progress = 0.0;
//    NSLog(@"%f %f %f",pointW, progress, self.progressBar.w);
    self.currentProgress.w = pointW  + (self.progressBar.w - pointW) * progress;
    self.progressPoint.centerX = self.progressBar.x + self.currentProgress.w;
}

#pragma mark - timer
- (void)addTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [_timer invalidate];
    _timer = nil;
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
