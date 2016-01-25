//
//  PlayViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "PlayViewController.h"
#import <UMSocial.h>

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
@property (weak, nonatomic) IBOutlet UIView *playBtnBg;
@property (weak, nonatomic) IBOutlet UIImageView *playBtn;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *lyricsBtn;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player = [SUPlayerManager manager];
    
    RegisterNotify(SONGREADY, @selector(loadSongInfo));
    RegisterNotify(SONGPLAY, @selector(songBeginNotice));
    RegisterNotify(SONGPAUSE, @selector(songPauseNotice));
    RegisterNotify(SONGEND, @selector(songEndPlaying));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_player.isPlaying) [self addTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //进度条
        self.progressPoint.layer.masksToBounds = YES;
        self.progressPoint.layer.cornerRadius = self.progressPoint.h / 2.0;
        
        //封面
        CGRect coverBounds = CGRectMake(0, 0, self.coverView.h * 0.93, self.coverView.h * 0.93);
        CGPoint coverCenter = CGPointMake(self.coverView.w / 2, self.coverView.h / 2);
        self.songCover.bounds = coverBounds;
        self.songCover.center = coverCenter;
        self.songCover.layer.masksToBounds = YES;
        self.songCover.layer.cornerRadius = self.songCover.h / 2.0;
        self.songCover.layer.borderWidth = 5.0;
        self.songCover.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.playBtnBg.bounds = coverBounds;
        self.playBtnBg.center = coverCenter;
        self.playBtnBg.layer.masksToBounds = YES;
        self.playBtnBg.layer.cornerRadius = self.playBtnBg.h / 2.0;
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) [self removeTimer];
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

- (IBAction)pausePlaying:(UITapGestureRecognizer *)sender {
    [_player pausePlay];
}

- (IBAction)goOnPlaying:(UITapGestureRecognizer *)sender {
    [_player startPlay];
}

#pragma mark - 通知处理
- (void)loadSongInfo {
    
    [self enableInfo];
    
    self.songName.text = _player.currentSong.title;
    self.singer.text = [NSString stringWithFormat:@"—   %@    —",_player.currentSong.artist];
    self.loveSong.selected = _player.currentSong.like.intValue == 1 ? YES : NO;
    [self.songCover sd_setImageWithURL:[NSURL URLWithString:_player.currentSong.picture] placeholderImage:DefaultImg];
}

- (void)songBeginNotice {
    if (!_timer) [self addTimer];
    _playBtn.hidden = YES;
    _playBtnBg.hidden = YES;
}

- (void)songPauseNotice {
    if (_timer) [self removeTimer];
    self.playBtnBg.hidden = NO;
    self.playBtn.hidden = NO;
}

- (void)songEndPlaying {
    if (_timer) [self removeTimer];
    
    self.songName.text = @"";
    self.singer.text = @"";
    self.songCover.image = DefaultImg;
    self.playTime.text = @"00:00";
    self.totalTime.text = @"00:00";
    self.progressPoint.x = self.progressBar.x;
    self.coverView.userInteractionEnabled = NO;
    self.songCover.transform = CGAffineTransformMakeRotation(0.0);
    [self changeAllBtnStatus:NO];
}

#pragma mark - 刷新界面
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

- (void)enableInfo {
    self.coverView.userInteractionEnabled = YES;
    [self changeAllBtnStatus:YES];
}

- (void)changeAllBtnStatus:(BOOL)status {
    self.banSong.enabled = status;
    self.loveSong.enabled = status;
    self.nextSong.enabled = status;
    self.lyricsBtn.enabled = status;
    self.favorBtn.enabled = status;
    self.shareBtn.enabled = status;
}

#pragma mark - timer
- (void)addTimer {
    BASE_INFO_FUN(@"添加timer");
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    BASE_INFO_FUN(@"移除timer");
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - 播放控制

- (IBAction)skipSong:(UIButton *)sender {
    [self songEndPlaying];
    [_player skipSong];
}

- (IBAction)loveSong:(UIButton *)sender {
    OperationType type = sender.selected ? OperationTypeUnHeart : OperationTypeHeart;
    [SUNetwork fetchPlayListWithType:type completion:^(BOOL isSucc) {
        if (isSucc) sender.selected = !sender.selected;
    }];
}

- (IBAction)banSong:(UIButton *)sender {
    [self songEndPlaying];
    [_player banSong];
}

#pragma mark - 其他功能
- (IBAction)lyrics:(UIButton *)sender {
    [SUNetwork fetchLyricWithCompletion:^(BOOL isSucc, BOOL isExist, NSDictionary *lyric) {
        BASE_INFO_FUN(lyric);
    }];
}

- (IBAction)favor:(UIButton *)sender {
    
}

- (IBAction)share:(UIButton *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56a4941667e58e200d001b8d" shareText:[NSString stringWithFormat:@"%@%@",_player.currentSong.title,_player.currentSong.artist] shareImage:[UIImage imageNamed:@"logo"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil] delegate:nil];
}


@end
