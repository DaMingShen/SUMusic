//
//  MySharedViewController.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/2.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "MySharedViewController.h"
#import "SongTableView.h"

@interface MySharedViewController ()

@property (nonatomic, strong) SongTableView * songList;

@end

@implementation MySharedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我分享的歌曲"];
    
    self.songList = [[SongTableView alloc]init];
    [self addChildViewController:self.songList];
    [self.view addSubview:self.songList.view];
    [self.songList loadListWithType:ListTypeShared];
}



@end
