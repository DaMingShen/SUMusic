//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "HomeViewController.h"
#import "ChannelListViewController.h"
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
    
    RegisterNotify(SONGPLAY, @selector(songBeginNotice));
    RegisterNotify(SONGPAUSE, @selector(songStopNotice));
    RegisterNotify(SONGEND, @selector(songStopNotice));
    
    [_appDelegate.player newChannelPlay];
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

//    _playingPet = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenH - 75, 85, 75)];
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
    [_playingPet startAnimating];
    [self.navigationController.view addSubview:_playingPet];
}

- (void)petTap {
    if (_appDelegate.player.isPlaying) {
        [_appDelegate.playView show];
    }else {
        [_appDelegate.player startPlay];
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
- (void)songBeginNotice {
    [_playingPet startAnimating];
}

- (void)songStopNotice {
    [_playingPet stopAnimating];
}

@end
