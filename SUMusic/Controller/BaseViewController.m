//
//  BaseViewController.m
//  SUMusic
//
//  Created by KevinSu on 16/1/17.
//  Copyright © 2016年 KevinSu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    
    UIView * _aniView;
}


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavUI];
}


#pragma mark ============================ UI设置 ============================
- (void)setupNavUI {
    
    self.view.backgroundColor = WhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    //edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll
    //    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    //当Bar不透明时，视图延伸至Bar所在区域
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = WhiteColor;
    self.navigationController.navigationBar.tintColor = BlackColor;
    
    //设置状态栏颜色（去info.plist文件里面设置View controller–based status bar appearance 为NO）
//    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //隐藏导航栏下面的线
//    [self hideNavBottomLine];
    
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    //自定义返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        [self setNavigationLeft:@"back_btn" sel:@selector(goBackAction)];
    }
    
}

//隐藏导航栏下面的线
- (void)hideNavBottomLine {
    
    UIImageView * navBottomLine = [SuImageView findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBottomLine.hidden = YES;
}


-(void)goBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ============================ 消息 ============================

- (void)ToastMessage:(NSString *)message {
    
    //计算字符串的尺寸
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];
    CGSize textSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    //创建Label
    UILabel * msg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 30, textSize.height + 20)];
    msg.center = CGPointMake(ScreenW / 2, ScreenH * 8.0 / 9.0);
    msg.text = message;
    msg.font = [UIFont systemFontOfSize:15.0];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.backgroundColor = [UIColor blackColor];
    msg.textColor = [UIColor whiteColor];
    msg.layer.masksToBounds = YES;
    msg.layer.cornerRadius = (textSize.height + 20) / 2;
    
    //加到window上
    [[UIApplication sharedApplication].keyWindow addSubview:msg];
    
    //出现后的动画
    POPSpringAnimation * scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [msg.layer pop_addAnimation:scaleAnimation forKey:@"size"];
    [self performSelector:@selector(dismissMsg:) withObject:msg afterDelay:1.5];
    
}

- (void)dismissMsg:(UIView *)msg {
    
    //透明度变化动画
    POPBasicAnimation * alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnimation.fromValue = @(1.0);
    alphaAnimation.toValue = @(0.0);
    [msg pop_addAnimation:alphaAnimation forKey:@"outAlpha"];
    
    [alphaAnimation setCompletionBlock:^(POPAnimation * anim, BOOL finished) {
        
        //动画完成之后从视图中移除
        [msg removeFromSuperview];
    }];
}

- (void)showAlert:(NSString *)message {
    
    [[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)showLoadingAni {
    
    if (_aniView == nil) {
        _aniView = [[UIView alloc]initWithFrame:ScreenB];
        _aniView.alpha = 0.f;
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.center = CGPointMake(ScreenW / 2, ScreenH / 2);
        imageView.image = [UIImage imageNamed:@"loading"];
        imageView.tag = 666;
        [_aniView addSubview:imageView];
    }
    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAni.duration = 2.0;
    rotationAni.cumulative = YES;
    rotationAni.repeatCount = NSIntegerMax;
    [[_aniView viewWithTag:666].layer addAnimation:rotationAni forKey:@"rotationAni"];

    [[UIApplication sharedApplication].keyWindow addSubview:_aniView];
    [UIView animateWithDuration:0.2 animations:^{
        _aniView.alpha = 1.0;
    }];
}

- (void)hideAni {
    [UIView animateWithDuration:0.2 animations:^{
        _aniView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_aniView removeFromSuperview];
    }];
}

- (UIView *)showLoadingInView:(UIView *)sender {
    
    UIView * loadingView = [[UIView alloc]initWithFrame:sender.frame];
    loadingView.backgroundColor = WhiteColor;
    loadingView.alpha = 0.f;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.center = CGPointMake(sender.w / 2, sender.h / 2);
    imageView.image = [UIImage imageNamed:@"loading"];
    imageView.tag = 666;
    [loadingView addSubview:imageView];

    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAni.duration = 2.0;
    rotationAni.cumulative = YES;
    rotationAni.repeatCount = NSIntegerMax;
    [[loadingView viewWithTag:666].layer addAnimation:rotationAni forKey:@"rotationAni"];
    
    [sender.superview addSubview:loadingView];
    [UIView animateWithDuration:0.2 animations:^{
        loadingView.alpha = 1.0;
    }];
    
    return loadingView;
}

- (void)hideLoading:(UIView *)loadingView {
    [UIView animateWithDuration:0.2 animations:^{
        loadingView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
}

#pragma mark ============================ 导航栏 ============================
- (void)setNavigationTitle:(NSString *)title {
    
    self.title = title;
    //设置标题颜色为白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BaseColor,NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
}

- (void)setNavigationTitleView:(UIView *)view {
    
    self.navigationItem.titleView = view;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)style {
    
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

- (UIBarButtonItem *)setNavigationLeft:(NSString *)imageName sel:(SEL)sel
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[SuButton createButtonWithFrame:CGRectMake(0, 0, 44, 44) Target:self Selector:sel ForgroundImage:imageName ForgroundImageSelected:imageName]];
    
    self.navigationItem.leftBarButtonItem = item;
    return item;
}

- (UIBarButtonItem *)setNavigationRight:(NSString *)imageName sel:(SEL)sel {
    
    UIButton * rightBtn = [SuButton createButtonWithFrame:CGRectMake(0, 0, 44, 44) Target:self Selector:sel ForgroundImage:imageName ForgroundImageSelected:imageName];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
    return item;
}


- (UIBarButtonItem *)setNavigationRightButton:(NSString *)btnName sel:(SEL)sel {
    
    UIButton * rightBtn = [SuButton createButtonWithFrame:CGRectMake(0, 0, 44, 44) Title:btnName FontSize:15 Color:[UIColor grayColor] Target:self Selector:sel];
    //    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
    return item;
}








@end
