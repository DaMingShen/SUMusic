//
//  LyricView.h
//  SUMusic
//
//  Created by 万众科技 on 16/1/26.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricView : UIView

@property (nonatomic, copy) void(^tapBlock)(LyricView * lyrView);

- (void)loadLyric:(NSDictionary *)dict;

- (void)clearLyric;

- (void)showInView:(UIView *)sender;

- (void)scrollLyric;

- (void)hide;

- (BOOL)checkLyric;

- (BOOL)checkShow;

@end
