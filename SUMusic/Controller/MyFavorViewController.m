//
//  MyFavorViewController.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "MyFavorViewController.h"
#import "SongListView.h"

@interface MyFavorViewController ()

@end

@implementation MyFavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我的收藏"];
    
    SongListView * songList = [[NSBundle mainBundle]loadNibNamed:@"SongListView" owner:self options:nil][0];
    [songList loadListWithType:ListTypeMyFavor];
    [self.view addSubview:songList];
}

@end
