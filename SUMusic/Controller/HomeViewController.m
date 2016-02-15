//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "HomeViewController.h"
#import "ChannelListViewController.h"
#import "MyOffLineViewController.h"
#import "MineViewController.h"
#import "TopTabItemView.h"

@interface HomeViewController () {
    
    AppDelegate * _appDelegate;
    
    ChannelListViewController * _channelVC;
    MineViewController * _mineVC;
    TopTabItemView * _topView;
    NSArray<UIView *> * _subViewList;
    
    UIImageView * _playingPet;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = [AppDelegate delegate];
    
    [self setupUI];
    [self setupPlayingPet];
    
    //监听状态变化
    RegisterNotify(SONGPLAYSTATUSCHANGE, @selector(observeSongPlayStatus))
    RegisterNotify(NETWORKSTATUSCHANGE, @selector(networkStatusChange))
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{
       _topView.alpha = 1.0;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _topView.alpha = 0.f;
}

#pragma mark - UI
- (void)setupUI {
    
    //顶部标签
    _topView = [[NSBundle mainBundle]loadNibNamed:@"TopTabItemView" owner:self options:nil][0];
    _topView.frame = CGRectMake(0, 0, ScreenW, 64);
    [_topView setTabBlock:^(NSInteger index) {
        for (UIView * view in _subViewList) {
            if (view.hidden == NO) view.hidden = YES;
        }
        [_subViewList objectAtIndex:index].hidden = NO;
    }];
    [self.navigationController.view addSubview:_topView];
    
    //内容
    _mineVC = [[MineViewController alloc]init];
    _mineVC.view.frame = self.view.bounds;
    [self addChildViewController:_mineVC];
    [self.view addSubview:_mineVC.view];
    
    _channelVC = [[ChannelListViewController alloc]init];
    _channelVC.view.frame = self.view.bounds;
    [self addChildViewController:_channelVC];
    [self.view addSubview:_channelVC.view];
    
    _mineVC.view.hidden = YES;
    _subViewList = @[_channelVC.view, _mineVC.view];
}

#pragma mark - PlayingPet
- (void)setupPlayingPet {

    _playingPet = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 76, 76)];
    _playingPet.center = CGPointMake(ScreenW / 2, ScreenH - 38);
    _playingPet.contentMode = UIViewContentModeScaleAspectFill;
    _playingPet.userInteractionEnabled = YES;
    _playingPet.image = [UIImage imageNamed:@"playingPet_1"];
    _playingPet.animationImages = @[[UIImage imageNamed:@"playingPet_1"],
                                    [UIImage imageNamed:@"playingPet_2"],
                                    [UIImage imageNamed:@"playingPet_3"]];
    _playingPet.animationDuration = 0.5;
    _playingPet.animationRepeatCount = 0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(petTap)];
    [_playingPet addGestureRecognizer:tap];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(petPan:)];
    [_playingPet addGestureRecognizer:pan];
//    [_playingPet startAnimating];
    [self.navigationController.view addSubview:_playingPet];
}

- (void)petTap {
    //如果是暂停，则继续播放
    if (_appDelegate.player.status == SUPlayStatusPause) {
        [_appDelegate.player startPlay];
    }
    //不是则显示页面
    else {
        [_appDelegate.playView show];
    }
}

- (void)petPan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    _playingPet.center = CGPointMake(_playingPet.centerX + translation.x, _playingPet.centerY + translation.y);
    [pan setTranslation:CGPointZero inView:self.view];
    if (_playingPet.x < 5) _playingPet.x = 5;
    if (_playingPet.y < 10) _playingPet.y = 10;
    if (_playingPet.x > ScreenW - _playingPet.w + 5) _playingPet.x = ScreenW - _playingPet.w + 5;
    if (_playingPet.y > ScreenH - _playingPet.h) _playingPet.y = ScreenH - _playingPet.h;
}

#pragma mark - 通知处理
- (void)observeSongPlayStatus {
    SUPlayStatus status = [AppDelegate delegate].player.status;
    switch (status) {
        case SUPlayStatusLoadSongInfo:
            if (!_playingPet.isAnimating) [_playingPet startAnimating];
            break;
        case SUPlayStatusPause:
            if (_playingPet.isAnimating) [_playingPet stopAnimating];
            break;
        case SUPlayStatusPlay:
            if (!_playingPet.isAnimating) [_playingPet startAnimating];
            break;
        case SUPlayStatusStop:
            if (_playingPet.isAnimating) [_playingPet stopAnimating];
            break;
        default:
            break;
    }
}

- (void)networkStatusChange {
    //如果没有网络，则跳转离线播放
    if (![[SuNetworkMonitor monitor] isNetworkEnable]) {
        BASE_INFO_FUN(@"无网络：离线播放");
        NSString * currentVC = NSStringFromClass([[self.navigationController.viewControllers lastObject] class]);
        //切换到离线播放
        if (!_appDelegate.player.isOffLinePlay) {
            BASE_INFO_FUN(@"切换模式");
            [_appDelegate.playView hide:nil];
            NSArray * offlineSongList = [SuDBManager fetchOffLineList];
            [_appDelegate.player playOffLineList:offlineSongList index:0];
            
            //跳转到离线列表页面
            if (![currentVC isEqualToString:@"MyOffLineViewController"]) {
                BASE_INFO_FUN(@"切换页面");
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                MyOffLineViewController * offLine = [[MyOffLineViewController alloc]init];
                [self.navigationController pushViewController:offLine animated:YES];
            }
        }
    }
}

@end
