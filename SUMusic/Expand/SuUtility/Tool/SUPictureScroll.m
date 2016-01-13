//
//  SUPictureScroll.m
//  PictureScrollDemo
//
//  Created by 万众科技 on 15/9/1.
//  Copyright (c) 2015年 万众科技. All rights reserved.
//

#import "SUPictureScroll.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height

@interface SUPictureScroll ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIPageControl * pageControl;

@property (nonatomic,strong) NSTimer * timer;

@end

@implementation SUPictureScroll


+ (instancetype)createAdsScollWithFrame:(CGRect)frame InView:(UIView *)view PicUrlArray:(NSArray *)picUrlArray IsScroll:(BOOL)isScroll IsAddScrollTimer:(BOOL)isAddScrollTimer ScrollTime:(int)scrollTime ShowBlock:(showImg)showBlock AndClickBlock:(clickImg)clickBlock {
    
    SUPictureScroll * PS = [[SUPictureScroll alloc]initWithFrame:frame];
    [PS setShowImg:showBlock];
    [PS setClickImg:clickBlock];
    PS.picUrlArray = [NSMutableArray arrayWithArray:picUrlArray];
    PS.scrollTime = scrollTime;
    PS.isTimingShow = isAddScrollTimer;
    [view addSubview:PS];
    
    return PS;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupScrollView];
        [self setupPageControl];
    }
    return self;
}


//创建scrollView
- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}

//设置pageControl
- (void)setupPageControl {
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT - 20, WIDTH, 20)];
//    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9646 green:1.0 blue:0.9708 alpha:1.0];
//    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.8443 green:0.4344 blue:0.4678 alpha:1.0];
    self.pageControl.currentPageIndicatorTintColor = BaseColor;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexRGB:@"#c9c9c9"];
    [self.pageControl addTarget:self action:@selector(handlePageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
}


//设置图片
-(void)setPicUrlArray:(NSMutableArray *)picUrlArray {
    if (picUrlArray.count >= 1) {
        _picUrlArray = picUrlArray;
 
        //循环轮播，数组＋2，图片＋2
        self.pageControl.numberOfPages = picUrlArray.count;

        [picUrlArray insertObject:[picUrlArray lastObject] atIndex:0];
        [picUrlArray addObject:picUrlArray[1]];

        self.scrollView.contentSize = CGSizeMake(picUrlArray.count * WIDTH, HEIGHT);
        [self.scrollView setContentOffset:CGPointMake(WIDTH, 0)];
        
        
        for (int i = 0; i < picUrlArray.count; i ++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //自定义显示图片的方式
            if (self.showImg) {
                NSString * picUrl = picUrlArray[i];
                self.showImg(imageView,picUrl);
            }
            
            //通过tag来识别哪张图片
            if (i != 0 && i != picUrlArray.count - 1) {
                imageView.userInteractionEnabled = YES;
                imageView.tag = 1000 + i;
            }
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgAction:)];
            [imageView addGestureRecognizer:tap];
            
            [self.scrollView addSubview:imageView];
        }
        
    }
}

- (void)clickImgAction:(UITapGestureRecognizer *)tap {
    
    if (self.clickImg) {
        self.clickImg(_picUrlArray.count - 2,tap.view.tag - 1000);
    }
}

//点击小圆点时动作
- (void)handlePageControl:(UIPageControl *)pageControl {
    
    [self.scrollView setContentOffset:CGPointMake((pageControl.currentPage + 1) * WIDTH, 0) animated:YES];
    
}

//滚动结束后调整位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    if (point.x == 0) {
        [self.scrollView setContentOffset:CGPointMake(size.width - WIDTH * 2, 0) animated:NO];
    }else if (point.x == size.width - WIDTH) {
        [self.scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
    }
    
    CGPoint newPoint = scrollView.contentOffset;
    self.pageControl.currentPage = (newPoint.x - WIDTH) / WIDTH;
    
    //重新添加定时器
    if (!self.timer && self.isTimingShow) {
        [self addScrollTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

//当开始拖动时（即有用户交互）移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeScrollTimer];
}

//定时器轮播
-(void)setIsTimingShow:(BOOL)isTimingShow {
    _isTimingShow = isTimingShow;
    
    if (isTimingShow) {
        [self addScrollTimer];
    }
}

- (void)changePic {
    CGPoint point = self.scrollView.contentOffset;
    point.x += WIDTH;
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)addScrollTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTime target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeScrollTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
