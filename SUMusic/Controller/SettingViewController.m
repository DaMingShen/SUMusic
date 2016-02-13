//
//  SettingViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/2/13.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshLogoutBtnStatus];

    RegisterNotify(LOGINSTATUSCHANGE, @selector(refreshLogoutBtnStatus))
}

- (void)setupUI {
    self.logoutBtn.backgroundColor = BaseColor;
    
    self.tableView.rowHeight = 70.0;
    self.tableView.tableFooterView = [UIView new];
}

- (void)refreshLogoutBtnStatus {
    if ([SuGlobal checkLogin]) {
        self.logoutBtn.hidden = NO;
        self.tableViewBottomConstraint.constant = 44.0;
    }else {
        self.logoutBtn.hidden = YES;
        self.tableViewBottomConstraint.constant = 0.f;
    }
}

- (IBAction)logout:(UIButton *)sender {
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"确定要退出当前账号吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    [sheet showInView:self.view];
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) return;
    
    [SuGlobal setLoginStatus:NO];
    SendNotify(LOGINSTATUSCHANGE, nil)
}




@end
