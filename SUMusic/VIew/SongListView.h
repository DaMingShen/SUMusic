//
//  SongListView.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ListType) {
    ListTypeOffLine,
    ListTypeMyFavor,
    ListTypeShared
};

@interface SongListView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * songSource;

- (void)loadListWithType:(ListType)listType;

@end
