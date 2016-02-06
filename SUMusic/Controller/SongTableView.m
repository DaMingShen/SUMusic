//
//  SongTableView.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/2.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SongTableView.h"
#import "SongListTableViewCell.h"
#import "OffLineManager.h"

@interface SongTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *noDataNotice;

@property (nonatomic, strong) NSMutableArray * downLoadList;
@property (nonatomic, strong) NSMutableArray * offLineList;

@property (nonatomic, assign) ListType listType;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation SongTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addUpdateTimer];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)loadListWithType:(ListType)listType {
    
    self.listType = listType;
    [self loadListFromDB];
}

- (void)loadListFromDB {

    switch (self.listType) {
        case ListTypeOffLine:
        {
            self.downLoadList = [SuDBManager fetchDownList].mutableCopy;
            self.offLineList = [SuDBManager fetchOffLineList].mutableCopy;
            self.songSource = [NSMutableArray array];
            [self.songSource addObjectsFromArray:[[self.downLoadList reverseObjectEnumerator]allObjects]];
            [self.songSource addObjectsFromArray:[[self.offLineList reverseObjectEnumerator]allObjects]];
        }
            break;
        case ListTypeMyFavor:
            self.songSource = [SuDBManager fetchFavorList].mutableCopy;
            break;
        case ListTypeShared:
            self.songSource = [SuDBManager fetchSharedList].mutableCopy;
            break;
        default:
            break;
    }

    if (self.songSource.count > 0) {
        self.noDataNotice.hidden = YES;
        if (self.editHideBlock) self.editHideBlock(NO);
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else {
        [self.tableView setEditing:NO animated:NO];
        if (self.editHideBlock) self.editHideBlock(YES);
        self.tableView.hidden = YES;
        self.noDataNotice.hidden = NO;
    }
}

#pragma mark - 编辑
- (void)editList:(BOOL)editStatus {
    [self.tableView setEditing:editStatus animated:YES];
}

#pragma mark - 定时刷新进度
- (void)addUpdateTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)updateProgress {
    if ([OffLineManager manager].downLoadingList.count <= 0) return;
    if (self.tableView.visibleCells.count <= 0) return;
    
    for (SongListTableViewCell * cell in self.tableView.visibleCells) {
        if (cell.progressLabel.hidden) {
            continue;
        }else {
            NSString * sid = [NSString stringWithFormat:@"%d",cell.progressLabel.tag];
            DownLoadInfo * info = [[OffLineManager manager]checkSongPlayingWithSid:sid];
            cell.progressLabel.text = [NSString stringWithFormat:@"%d%%",info.percent];
        }
    }
}

#pragma mark - UI
- (void)setupUI {
    
    self.view.frame = ScreenB;
    
    self.tableView.rowHeight = 70.0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"favorCell"];
}

- (void)refreshSongList {
    if (self.tableView.hidden) return;
    [self.tableView reloadData];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    [cell.songCover sd_setImageWithURL:[NSURL URLWithString:info.picture] placeholderImage:DefaultImg];
    cell.songName.text = info.title;
    cell.artist.text = info.artist;
    
    //播放状态
    if (![self.downLoadList containsObject:info] &&
        [[AppDelegate delegate].player.currentSong.sid isEqualToString:info.sid]) {
        cell.playIndicator.hidden = NO;
        cell.playIndicator.animationImages = @[[UIImage imageNamed:@"ic_channel_nowplaying1"],
                                               [UIImage imageNamed:@"ic_channel_nowplaying2"],
                                               [UIImage imageNamed:@"ic_channel_nowplaying3"],
                                               [UIImage imageNamed:@"ic_channel_nowplaying4"]];
        cell.playIndicator.animationDuration = 1.0;
        cell.playIndicator.animationRepeatCount = 0;
        [cell.playIndicator startAnimating];
    }else {
        [cell.playIndicator stopAnimating];
        cell.playIndicator.hidden = YES;
    }
    
    //离线歌曲
    if (self.listType == ListTypeOffLine) {
        
        //未下载完成
        if ([self.downLoadList containsObject:info]) {
            
            cell.progressLabel.tag = info.sid.intValue;
            //下载中
            if ([[OffLineManager manager]checkSongPlayingWithSid:info.sid]) {
                cell.progressLabel.hidden = NO;
                cell.downLoadBtn.hidden = YES;
                DownLoadInfo * downLoadInfo = [[OffLineManager manager]checkSongPlayingWithSid:info.sid];
                cell.progressLabel.text = [NSString stringWithFormat:@"%d%%",downLoadInfo.percent];
            }
            //未下载
            else {
                cell.progressLabel.hidden = YES;
                cell.downLoadBtn.hidden = NO;
                [cell setDownLoadBlock:^(UIButton * sender) {
                    BASE_INFO_FUN(@"下载");
                    sender.hidden = YES;
                    cell.progressLabel.hidden = NO;
                    [[OffLineManager manager]downLoadSongWithSongInfo:info];
                }];
            }
 
        //下载完成
        }else {
            cell.progressLabel.hidden = YES;
            cell.downLoadBtn.hidden = YES;
        }
        
    //非离线歌曲
    }else {
        cell.progressLabel.hidden = YES;
        cell.downLoadBtn.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BASE_INFO_FUN(@"播放歌曲");
    SongInfo * info = [self.songSource objectAtIndex:indexPath.row];
    //离线的情况
    if ([self.downLoadList containsObject:info]) {
        [self ToastMessage:@"该歌曲还没离线完成"];
        return;
    }
    
    //其他情况
    SUPlayerManager * player = [AppDelegate delegate].player;
    
    if (![player.currentSong.sid isEqualToString:info.sid] ) {
        [player.songList removeAllObjects];
        [player.songList addObjectsFromArray:self.listType == ListTypeOffLine ? self.offLineList : self.songSource];
        
        if (self.listType == ListTypeOffLine) player.isOffLinePlay = YES;
        [player playLocalListWithIndex:indexPath.row];
    }
    [[AppDelegate delegate].playView show];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == ListTypeOffLine) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SongInfo * songInfo = self.songSource[indexPath.row];
    if ([self.downLoadList containsObject:songInfo]) {
        [SuDBManager deleteFromDownListWithSid:songInfo.sid];
    }else if ([self.offLineList containsObject:songInfo]) {
        [SuDBManager deleteFromOffLineListWithSid:songInfo.sid];
    }
    [[OffLineManager manager]deleteSongWithSongInfo:songInfo];
}


@end
