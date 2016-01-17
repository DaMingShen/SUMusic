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
#import "PlayViewController.h"

@interface HomeViewController () {
    
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
    
    [self setupUI];
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

- (void)setupUI {
    
    //顶部标签
    _topView = [[NSBundle mainBundle]loadNibNamed:@"TopTabItemView" owner:self options:nil][0];
    _topView.frame = CGRectMake(0, 0, ScreenW, 64);
    [_topView setTabBlock:^(NSInteger index) {
        BASE_INFO_FUN(@(index));
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
    
    //左下角动画
    _playingPet = [[UIImageView alloc]initWithFrame:CGRectMake(20, ScreenH - 100, 80, 80)];
    _playingPet.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(petStopPlaying)];
    _playingPet.userInteractionEnabled = YES;
    [_playingPet addGestureRecognizer:tap];
//    [self.navigationController.view addSubview:_playingPet];
//    [self petGoPlaying];
    
    PlayViewController * playVC = [[PlayViewController alloc]init];
    playVC.view.frame = CGRectMake(0, 0, 375, 667);
    [[UIApplication sharedApplication].keyWindow addSubview:playVC.view];
    [self addChildViewController:playVC];
//    [self.navigationController.view insertSubview:playVC.view aboveSubview:_topView];
}

- (void)petGoPlaying {
    
    _playingPet.animationImages = @[[UIImage imageNamed:@"playingPet_1"],
                                    [UIImage imageNamed:@"playingPet_2"],
                                    [UIImage imageNamed:@"playingPet_3"]];
    _playingPet.animationDuration = 0.5;
    _playingPet.animationRepeatCount = 0;
    [_playingPet startAnimating];
}

- (void)petStopPlaying {
    
    [_playingPet stopAnimating];
    _playingPet.image = [UIImage imageNamed:@"playingPet_default"];
}


@end
