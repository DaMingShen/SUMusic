//
//  PlayViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "PlayViewController.h"
#import "OffLineManager.h"
#import <UMSocial.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import "LyricView.h"
#import "ShareView.h"

@interface PlayViewController ()

@property (nonatomic, strong) SUPlayerManager * player; //播放器类
@property (nonatomic, strong) LyricView * lycView;      //歌词
@property (nonatomic, strong) ShareView * shareView;    //分享
@property (nonatomic, strong) NSTimer * timer;          //界面刷新定时器

@property (weak, nonatomic) IBOutlet UILabel *channelName;

@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;

@property (weak, nonatomic) IBOutlet UIButton *loveSong;
@property (weak, nonatomic) IBOutlet UIButton *nextSong;
@property (weak, nonatomic) IBOutlet UIButton *banSong;

@property (weak, nonatomic) IBOutlet UIView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *currentProgress;
@property (weak, nonatomic) IBOutlet UIView *progressPoint;
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *songCover;
@property (weak, nonatomic) IBOutlet UIView *playBtnBg;
@property (weak, nonatomic) IBOutlet UIImageView *playBtn;

@property (weak, nonatomic) IBOutlet UIButton *lyricsBtn;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player = [AppDelegate delegate].player;
    self.channelName.text = _player.currentChannelName;

    //监听状态变化
    RegisterNotify(SONGPLAYSTATUSCHANGE, @selector(observeSongPlayStatus))
    
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
        
        //歌词
        _lycView = [[LyricView alloc]initWithFrame:self.coverView.frame];

    });
    
    if (_player.isPlaying) [self addTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) [self removeTimer];
}

#pragma mark - 界面出现和隐藏
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


#pragma mark - 通知处理
- (void)observeSongPlayStatus {
    switch (_player.status) {
        case SUPlayStatusNon:
            
            break;
        case SUPlayStatusReadyToPlay:
            [self synUI];
            [self addTimer];
            break;
        case SUPlayStatusPause:
            
            break;
        case SUPlayStatusStop:
            
            break;
        default:
            break;
    }
}

#pragma mark - 刷新界面
- (void)synUI {
    
    //激活按钮
    [self changeAllBtnStatus:YES];
    
    //频道
    self.channelName.text = _player.currentChannelName;
    
    //封面
    self.coverView.userInteractionEnabled = YES;
    [self.songCover sd_setImageWithURL:[NSURL URLWithString:_player.currentSong.picture] placeholderImage:DefaultImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    //歌名
    self.songName.text = _player.currentSong.title;
    self.singer.text = [NSString stringWithFormat:@"- %@ -",_player.currentSong.artist];
    
    //三大金刚
    self.loveSong.selected = _player.currentSong.like.intValue == 1 ? YES : NO;
    
    //四大天王
    [self refreshFavorStatus];
    [self refreshDownLoadStatus];
    
    //设置歌词
    [_lycView clearLyric];
    if ([_lycView checkShow]) {
        [SUNetwork fetchLyricWithCompletion:^(BOOL isSucc, BOOL isExist, NSDictionary *lyric) {
            if (isSucc) {
                [_lycView loadLyric:lyric];
            }else {
                
            }
        }];
    }
}

- (void)resetUI {

    self.songName.text = @"";
    self.singer.text = @"";
    
    self.songCover.image = DefaultImg;
    self.songCover.transform = CGAffineTransformMakeRotation(0.0);
    self.coverView.userInteractionEnabled = NO;
    
    self.playTime.text = @"00:00";
    self.totalTime.text = @"00:00";
    self.progressPoint.x = self.progressBar.x;
    
    [self changeAllBtnStatus:NO];
}

- (void)refreshProgress {
    
    //显示时间
    self.playTime.text = _player.timeNow;
    self.totalTime.text = _player.duration;
    
    //进度条
    float pointW = self.progressPoint.w / 2.0;
    float progress = _player.progress;
    self.currentProgress.w = pointW  + (self.progressBar.w - pointW) * progress;
    self.progressPoint.centerX = self.progressBar.x + self.currentProgress.w;
    
    //图片旋转
    self.songCover.transform = CGAffineTransformRotate(self.songCover.transform, M_PI / 1440);
    
    //歌词
    if ([_lycView checkShow]) [_lycView scrollLyric];
}


- (void)changeAllBtnStatus:(BOOL)status {
    self.banSong.enabled = status;
    self.loveSong.enabled = status;
    self.nextSong.enabled = status;
    
    self.lyricsBtn.enabled = status;
    self.favorBtn.enabled = status;
    self.downBtn.enabled = status;
    self.shareBtn.enabled = status;
}

- (void)refreshFavorStatus {
    NSArray * favorSongs = [SuDBManager fetchFavorList];
    BOOL isFavor = NO;
    for (SongInfo * info in favorSongs) {
        if ([info.sid isEqualToString:_player.currentSong.sid]) {
            isFavor = YES;
            break;
        }
    }
    self.favorBtn.selected = isFavor;
}

- (void)refreshDownLoadStatus {
    NSArray * downloadList = [SuDBManager fetchDownList];
    for (SongInfo * info in downloadList) {
        if ([info.sid isEqualToString:_player.currentSong.sid]) {
            self.downBtn.enabled = NO;
            return;
        }
    }
    NSArray * offLineList = [SuDBManager fetchOffLineList];
    for (SongInfo * info in offLineList) {
        if ([info.sid isEqualToString:_player.currentSong.sid]) {
            self.downBtn.enabled = NO;
            return;
        }
    }
    self.downBtn.enabled = YES;
}

#pragma mark - 定时器
- (void)addTimer {
    if (_timer) return;
    BASE_INFO_FUN(@"添加timer");
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_timer == nil) return;
    BASE_INFO_FUN(@"移除timer");
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - 播放控制
- (IBAction)pausePlaying:(UITapGestureRecognizer *)sender {
    [_player pausePlay];
}

- (IBAction)goOnPlaying:(UITapGestureRecognizer *)sender {
    [_player startPlay];
}

- (IBAction)skipSong:(UIButton *)sender {
    
    UIView * loading = [self showLoadingInView:sender];
    [_player skipSongWithHandle:^(BOOL isSucc) {
        [self hideLoading:loading];
        if (!isSucc) [self ToastMessage:@"网络错误"];
    }];
}

- (IBAction)loveSong:(UIButton *)sender {
    
    UIView * loading = [self showLoadingInView:sender];
    OperationType type = sender.selected ? OperationTypeUnHeart : OperationTypeHeart;
    [SUNetwork fetchPlayListWithType:type completion:^(BOOL isSucc) {
        if (isSucc) sender.selected = !sender.selected;
        [self hideLoading:loading];
        if (!isSucc) [self ToastMessage:@"网络错误"];
    }];
}

- (IBAction)banSong:(UIButton *)sender {
    UIView * loading = [self showLoadingInView:sender];
    [_player banSongWithHandle:^(BOOL isSucc) {
        [self hideLoading:loading];
        if (!isSucc) [self ToastMessage:@"网络错误"];
    }];
}

#pragma mark - 歌词
- (IBAction)lyrics:(UIButton *)sender {
    
    if ([_lycView checkLyric]) {
        if ([_lycView checkShow]) {
            [_lycView hide];
        }else {
            [_lycView showInView:self.view];
        }
    }else {
        
        UIView * loading = [self showLoadingInView:sender];
        [SUNetwork fetchLyricWithCompletion:^(BOOL isSucc, BOOL isExist, NSDictionary *lyric) {
            if (isSucc) {
                [_lycView loadLyric:lyric];
                [_lycView showInView:self.view];
            }else {
                [self ToastMessage:@"获取歌词失败"];
            }
            [self hideLoading:loading];
        }];
    }
}

#pragma mark - 收藏
- (IBAction)favor:(UIButton *)sender {
    //取消收藏
    if (sender.selected) {
        BASE_INFO_FUN(@"取消收藏");
        [SuDBManager deleteFromFavorListWithSid:_player.currentSong.sid];
        sender.selected = NO;
    }
    //收藏
    else {
        BASE_INFO_FUN(@"收藏成功");
        [SuDBManager saveToFavorList];
        sender.selected = YES;
    }
    
    
//
//
//    BASE_INFO_FUN([SuDBManager fetchDownList][0]);
//    BASE_INFO_FUN([SuDBManager fetchSongInfoWithSid:@"185725"].sid);
    
}

#pragma mark - 离线
- (IBAction)downLoad:(UIButton *)sender {
    
    [[OffLineManager manager] downLoadSong];
    sender.enabled = NO;
    [self ToastMessage:@"已添加到离线列表"];
}

#pragma mark - 分享
- (IBAction)share:(UIButton *)sender {
    
    if (_shareView == nil) {
        WEAKSELF
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil][0];
        _shareView.frame = ScreenB;
        [_shareView setShareBlock:^(NSInteger shareType) {
            [weakSelf shareWithType:shareType];
        }];
    }
    [_shareView showInView:self.view];
}

- (void)shareWithType:(NSInteger)shareType {
    
    NSArray * types = @[UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[types[shareType]] content:[NSString stringWithFormat:@"%@%@",_player.currentSong.title,_player.currentSong.artist] image:DefaultImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        
        [_shareView dismiss:nil];
        if (response.responseCode == UMSResponseCodeSuccess) {
            BASE_INFO_FUN(@"分享成功");
            [SuDBManager saveToSharedList];
        }else {
            BASE_INFO_FUN(@"分享失败");
        }
    }];
}

@end
