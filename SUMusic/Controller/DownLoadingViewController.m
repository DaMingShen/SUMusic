//
//  DownLoadingViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/2/9.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "DownLoadingViewController.h"
#import "SongListTableViewCell.h"
#import "OffLineManager.h"

@interface DownLoadingViewController ()

@property (weak, nonatomic) IBOutlet UIView *noDataNotice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * songSource;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation DownLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"我的离线"];
    
    [self setupUI];
    [self loadListFromDB];
    [self addUpdateTimer];

    RegisterNotify(REFRESHSONGLIST, @selector(loadListFromDB))
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)loadListFromDB {
    
    self.songSource = [[[SuDBManager fetchDownList] reverseObjectEnumerator] allObjects];
    
    if (self.songSource.count > 0) {
        self.noDataNotice.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else {
        [self.tableView setEditing:NO animated:NO];
        self.tableView.hidden = YES;
        self.noDataNotice.hidden = NO;
    }
}

- (void)setupUI {
    
    self.view.frame = ScreenB;
    
    self.tableView.rowHeight = 70.0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DonwLoadCell"];
}

#pragma mark - 定时刷新进度
- (void)addUpdateTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)updateProgress {
    
    for (SongListTableViewCell * cell in self.tableView.visibleCells) {
        
        NSString * sid = [NSString stringWithFormat:@"%d",cell.progressIndicator.tag];
        DownLoadInfo * info = [[OffLineManager manager]checkSongDownloadingWithSid:sid];
        cell.progressIndicator.w = ScreenW * (info.percent / 100.0);
    }
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DonwLoadCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    [cell.songCover sd_setImageWithURL:[NSURL URLWithString:info.picture] placeholderImage:DefaultImg];
    cell.songName.text = info.title;
    cell.artist.text = info.artist;
    
    //下载进度
    cell.progressIndicator.hidden = NO;
    cell.progressIndicator.tag = info.sid.intValue;
    DownLoadInfo * downLoadInfo = [[OffLineManager manager]checkSongDownloadingWithSid:info.sid];
    cell.progressIndicator.w = ScreenW * (downLoadInfo.percent / 100.0);
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SongInfo * songInfo = self.songSource[indexPath.row];
    [SuDBManager deleteFromDownListWithSid:songInfo.sid];
    [[OffLineManager manager]deleteSongWithSongInfo:songInfo];
    [self loadListFromDB];
}

@end
