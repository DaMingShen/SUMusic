//
//  MineViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeader.h"
#import "MineTableViewCell.h"
#import "CopyrightViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate> {
    
    MineHeader * _header;
    NSArray * _names;
    NSArray * _icons;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
    _names = @[@"我的离线", @"我的收藏", @"我分享的歌曲", @"设置", @"版权声明"];
    _icons = @[@"mine_down", @"mine_favor", @"mine_share", @"mine_setting", @"mine_anouce"];
    
    self.tableView.rowHeight = 70.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mineCell"];
    self.tableView.tableFooterView = [UIView new];
    
    _header = [[NSBundle mainBundle]loadNibNamed:@"MineHeader" owner:self options:nil][0];
    _header.frame = CGRectMake(0, 0, ScreenW, 140);
    self.tableView.tableHeaderView = _header;
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
    cell.icon.image = [UIImage imageNamed:_icons[indexPath.row]];
    cell.name.text = _names[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
        {
            CopyrightViewController * copyrightVC = [[CopyrightViewController alloc]init];
            [self.navigationController pushViewController:copyrightVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
