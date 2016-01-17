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
    
    ChannelListViewController * _channelVC;
    MineViewController * _mineVC;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    //顶部标签
    TopTabItemView * topView = [[NSBundle mainBundle]loadNibNamed:@"TopTabItemView" owner:self options:nil][0];
    topView.frame = CGRectMake(0, 0, ScreenW, 64);
    [topView setTabBlock:^(NSInteger index) {
        BASE_INFO_FUN(@(index));
    }];
    [self.navigationController.view addSubview:topView];
    
    //内容
    _channelVC = [[ChannelListViewController alloc]init];
    _channelVC.view.frame = self.view.bounds;
    [self addChildViewController:_channelVC];
    [self.view addSubview:_channelVC.view];
    
    
    _mineVC = [[MineViewController alloc]init];
    _mineVC.view.frame = self.view.bounds;
}


@end
