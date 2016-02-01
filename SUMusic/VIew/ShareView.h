//
//  ShareView.h
//  SUMusic
//
//  Created by 万众科技 on 16/2/1.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeSina,
    ShareTypeWeChat,
    ShareTypeTimeLine
};

@interface ShareView : UIView

@property (nonatomic, copy) void(^shareBlock)(NSInteger shareType);

- (void)showInView:(UIView *)view;

- (IBAction)dismiss:(id)sender;

@end
