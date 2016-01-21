//
//  HomeViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "ChannelListViewController.h"
#import "ChannelTableViewCell.h"
#import "ChannelInfo.h"

@interface ChannelListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    AppDelegate * _appDelegate;
    UIImageView * _unConnectNotic;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ChannelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _appDelegate = [AppDelegate delegate];
    
    [self setupUI];
    [self fetchChannels];
}

#pragma mark - UI
- (void)setupUI {
    
    //表格设置
    self.tableView.rowHeight = 70.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"channelCell"];
    self.tableView.tableFooterView = [UIView new];
    
    //404提示
    _unConnectNotic = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _unConnectNotic.image = [UIImage imageNamed:@"network_404"];
    _unConnectNotic.hidden = YES;
    [self.view addSubview:_unConnectNotic];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fetchChannels)];
    [_unConnectNotic addGestureRecognizer:tap];
}

#pragma mark - 网络
- (void)fetchChannels {
    
    //showAni
    
    //loadData
    [SUNetwork fetchChannelsWithCompletion:^(BOOL isSucc, NSArray *channels) {
        //stopAni
        
        //refreshUI
        if (isSucc) {
            self.dataSource = channels.mutableCopy;
            _unConnectNotic.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else {
            _unConnectNotic.hidden = NO;
        }
    }];

}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChannelInfo * channel = [self.dataSource objectAtIndex:indexPath.row];
    cell.channelName.text = channel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelInfo * channel = [self.dataSource objectAtIndex:indexPath.row];
    //改变channel
    _appDelegate.player.currentChannelID = channel.channel_id;
    //开始播放
    [_appDelegate.player newChannelPlay];
    //弹出播放器
    [_appDelegate.playView show];
}

@end
