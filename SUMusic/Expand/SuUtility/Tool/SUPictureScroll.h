//
//  SUPictureScroll.h
//  KevinSu
//
//  Created by KevinSu on 15/9/1.
//  Copyright (c) 2015年 KevinSu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^showImg)(UIImageView * imageView, NSString * imgUrl);
typedef void (^clickImg)(NSInteger ImgCount, NSInteger currentImg);

@interface SUPictureScroll : UIView

@property (nonatomic,retain) NSMutableArray * picUrlArray;
@property (nonatomic,copy) void (^showImg)(UIImageView * imageView, NSString * imgUrl);
@property (nonatomic,copy) void (^clickImg)(NSInteger ImgCount, NSInteger currentImg);
@property (nonatomic,assign) BOOL isTimingShow;
@property (nonatomic,assign) int scrollTime;



/*
 图片轮播，设置actionBlock
 */
+ (instancetype)createAdsScollWithFrame:(CGRect)frame InView:(UIView *)view PicUrlArray:(NSArray *)picUrlArray IsScroll:(BOOL)isScroll IsAddScrollTimer:(BOOL)isAddScrollTimer ScrollTime:(int)scrollTime ShowBlock:(showImg)showBlock AndClickBlock:(clickImg)clickBlock;






@end
