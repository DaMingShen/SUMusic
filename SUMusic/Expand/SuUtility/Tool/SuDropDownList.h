//
//  DorpDownList.h
//  LazyWeather
//
//  Created by KevinSu on 15/11/7.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuDropDownList : UIView


/* 选择的回调 */
@property (nonatomic, copy) void(^callBackBlack)(NSString * selectedItem, int selectedIndex);

/* 初始化 view：需要下拉列表的view   soureArray：列表的数据 */
- (id)initWithView:(UIView *)view SourceArray:(NSArray *)sourceArray;

@end
