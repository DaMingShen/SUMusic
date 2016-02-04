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

@property (nonatomic, strong) UIButton * editBtn;

@end

@implementation MyOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我的离线"];
    
    //编辑按钮
    /*
    self.editBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 44, 44) Title:@"编辑" FontSize:15 Color:[UIColor darkGrayColor] Target:self Selector:@selector(editAction)];
    [self.editBtn setTitle:@"完成" forState:UIControlStateSelected];
    UIBarButtonItem * navEditBtn = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    self.navigationItem.rightBarButtonItem = navEditBtn;
    */
    
    //列表
    self.songList = [[SongTableView alloc]init];
    WEAKSELF
    [self.songList setEditHideBlock:^(BOOL isHide) {
        weakSelf.editBtn.hidden = isHide;
        weakSelf.editBtn.selected = NO;
    }];
    [self addChildViewController:self.songList];
    [self.view addSubview:self.songList.view];
    [self.songList loadListWithType:ListTypeOffLine];
}


#pragma mark - 编辑
- (void)editAction {
    self.editBtn.selected = !self.editBtn.selected;
    [self.songList editList:self.editBtn.selected];
}

@end
