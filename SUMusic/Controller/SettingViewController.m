//
//  SettingViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/2/13.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设置"];
    
    [self setupUI];

    RegisterNotify(LOGINSTATUSCHANGE, @selector(refreshUI))
}

- (void)setupUI {
    
    self.tableView.rowHeight = 50.0;
    self.tableView.tableFooterView = [UIView new];
    
    self.dataSource = @[@[@"使用流量收听", @"清除缓存"],@[@"退出当前账号"]];
}

- (void)refreshUI {
    [self.tableView reloadData];
}

#pragma mark - 表格代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([SuGlobal checkLogin]) return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch * flowSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW - 70, 10, 60, 30)];
        flowSwitch.on = [SuGlobal checkFlowUsable];
        [flowSwitch addTarget:self action:@selector(flowSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:flowSwitch];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = BaseColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [self logout];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                [self clearCache];
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 功能
- (void)logout {
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"确定要退出当前账号吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

- (void)clearCache {
    [TopAlertView showWithType:TopAlertTypeCheck message:@"清除完成"];
}

- (void)flowSwitchChange:(UISwitch *)flowSwitch {
    BASE_INFO_FUN(@(flowSwitch.on));
    [SuGlobal setFlowUsableStatus:flowSwitch.on];
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) return;
    
    [SuGlobal setLoginStatus:NO];
    SendNotify(LOGINSTATUSCHANGE, nil)
}




@end
