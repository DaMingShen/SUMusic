//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ChannelListViewController.h"
#import "LoginPage.h"
#import "ChannelTableViewCell.h"
#import "ChannelInfo.h"

@interface ChannelListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    AppDelegate * _appDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ChannelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _appDelegate = [AppDelegate delegate];
//    [_appDelegate.player startPlay];
    
//    [_appDelegate.playView show];
//    [SUNetwork loginWithUserName:@"446135517@qq.com" password:@"kevinsu0321"];
//    [SUNetwork fetchMyFavorSongList];
    
    [self setupUI];
    [self fetchChannels];
}

#pragma mark - UI
- (void)setupUI {
    self.tableView.rowHeight = 70.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"channelCell"];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - 网络
- (void)fetchChannels {
    
    [SUNetwork fetchChannelsWithCompletion:^(BOOL isSucc, NSArray *channels) {
        
        if (isSucc) {
            self.dataSource = channels.mutableCopy;
            [self.tableView reloadData];
        }else {
            
        }
        
    }];

}


- (IBAction)login:(id)sender {
    
    LoginPage * loginVC = [[LoginPage alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    ChannelInfo * channel = [self.dataSource objectAtIndex:indexPath.row];
    cell.channelName.text = channel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
