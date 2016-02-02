//
//  MyOffLineViewController.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/2.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "MyOffLineViewController.h"
#import "SongTableView.h"

@interface MyOffLineViewController ()

@property (nonatomic, strong) SongTableView * songList;

@end

@implementation MyOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我的离线"];
    
    self.songList = [[SongTableView alloc]init];
    [self addChildViewController:self.songList];
    [self.view addSubview:self.songList.view];
    [self.songList loadListWithType:ListTypeOffLine];
}

@end
