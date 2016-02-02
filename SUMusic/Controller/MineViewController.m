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
#import "LoginPage.h"
#import "MyFavorViewController.h"
#import "MySharedViewController.h"
#import "MyOffLineViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate * _appDelegate;
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
    
    RegisterNotify(LoginSUCC, @selector(refreshUI))
}

#pragma mark - UI
- (void)setupUI {
    
    _appDelegate = [AppDelegate delegate];
    
    //初始化数组
    _names = @[@"我的离线", @"我的收藏", @"我分享的歌曲", @"设置", @"版权声明"];
    _icons = @[@"mine_down", @"mine_favor", @"mine_share", @"mine_setting", @"mine_anouce"];
    
    //表格设置
    self.tableView.rowHeight = 70.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mineCell"];
    self.tableView.tableFooterView = [UIView new];
    
    //表格头部设置
    UIView * tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    _header = [[NSBundle mainBundle]loadNibNamed:@"MineHeader" owner:self options:nil][0];
    _header.frame = tableHeader.bounds;
    [_header.userIcon addTarget:self action:@selector(goLoginPage) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:_header];
    UIView * line = [UIView drawHorizonLineWithFrame:CGRectMake(0, tableHeader.h, tableHeader.w, 1)];
//    [tableHeader addSubview:line];
    self.tableView.tableHeaderView = tableHeader;
    
    //刷新头部
    [self refreshUI];
}

#pragma mark - 跳转登陆页面
- (void)goLoginPage {
    LoginPage * loginVC = [[LoginPage alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - 登陆登出通知处理
- (void)refreshUI {
    if ([SuGlobal checkLogin]) {
        _header.userName.text = _appDelegate.userInfo.user_name;
        _header.userIcon.userInteractionEnabled = NO;
    }else {
        _header.userName.text = @"未登陆";
        _header.userIcon.userInteractionEnabled = YES;
    }
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.icon.image = [UIImage imageNamed:_icons[indexPath.row]];
    cell.name.text = _names[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            MyOffLineViewController * offLine = [[MyOffLineViewController alloc]init];
            [self.navigationController pushViewController:offLine animated:YES];
        }
            break;
        case 1:
        {
            MyFavorViewController * favor = [[MyFavorViewController alloc]init];
            [self.navigationController pushViewController:favor animated:YES];
        }
            break;
        case 2:
        {
            MySharedViewController * shared = [[MySharedViewController alloc]init];
            [self.navigationController pushViewController:shared animated:YES];
        }
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
