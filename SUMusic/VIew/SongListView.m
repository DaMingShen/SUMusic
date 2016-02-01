//
//  SongListView.m
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "SongListView.h"
#import "SongListTableViewCell.h"

@interface SongListView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SongListView

- (void)loadListWithType:(ListType)listType {
    
    [self setupUI];
    
    switch (listType) {
        case ListTypeOffLine:
            self.songSource = [SuDBManager fetchDownList].mutableCopy;
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
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)setupUI {
    
    self.frame = ScreenB;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70.0;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SongListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"favorCell"];
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
    return cell;
}


@end
