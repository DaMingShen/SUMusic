//
//  SuTabBarController.m
//  tabbartest
//
//  Created by KevinSu on 15/11/4.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuTabBarController.h"

@interface SuTabBarController () {
    
    UIButton * _currentItem;
}

@end

@implementation SuTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonItemArray = [NSMutableArray array];
    //设置tabbar样式
    [self configUI];
}

- (void)configUI {
    
    self.tabBar.barTintColor = WhiteColor;
    self.tabBar.tintColor = [UIColor colorWithHexRGB:@"#ff9600"];
//    [UITabBarItem appearance]
//    self.tabBar.ti = [UIColor colorWithHexRGB:@"#6e7580"];
}

- (void)creatVCs {
    
    for (int i = 0; i < self.VCs.count; i ++) {
        
        [self addVCWithClass:self.VCs[i] Title:self.Titles[i] Image:self.Imgs[i] SelectedImage:self.SelectedImgs[i]];
    }
    
    //自定义tabbar
    [self setupCustomTabbar];
}

- (void)addVCWithClass:(NSString *)class Title:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedImage {
    
    //创建一个界面(包含导航)
    UIViewController * VC = [[NSClassFromString(class) alloc]init];
    VC.title = title;
    UINavigationController * NVC = [[UINavigationController alloc]initWithRootViewController:VC];
    NVC.tabBarItem.image = [UIImage imageNamed:image];
    NVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];// 始终绘制图片原始状态，不使用Tint Color
    
    //添加到tabBar中
    NSMutableArray * viewControllers = [[NSMutableArray alloc]initWithArray:self.viewControllers];
    [viewControllers addObject:NVC];
    self.viewControllers = viewControllers;
}

- (void)setupCustomTabbar {
    
    //隐藏原生tabbar
    self.tabBar.hidden = YES;
    
    //自定义tabbar
    _customTabbar = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - 49, ScreenW, 49)];
    _customTabbar.backgroundColor = WhiteColor;
    [self.view addSubview:_customTabbar];
    
    //自定义item
    for (int i = 0; i < self.VCs.count; i ++) {
        
        SuButton * item = [SuButton buttonWithType:UIButtonTypeCustom];
        item.tag = i;
        item.frame = CGRectMake(ScreenW / 4 * i, 5, ScreenW / 4, 44);
        [item addTarget:self action:@selector(itemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        //标题
        [item setTitle:self.Titles[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:11.0];
        //颜色
        [item setTitleColor:[UIColor colorWithHexRGB:@"#6e7580"] forState:UIControlStateNormal];
        [item setTitleColor:BaseColor forState:UIControlStateHighlighted];
        [item setTitleColor:BaseColor forState:UIControlStateSelected];
        //图片
        [item setImage:[UIImage imageNamed:self.Imgs[i]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:self.SelectedImgs[i]] forState:UIControlStateHighlighted];
        [item setImage:[UIImage imageNamed:self.SelectedImgs[i]] forState:UIControlStateSelected];
        [self.buttonItemArray addObject:item];
        [_customTabbar addSubview:item];
        
        //默认选择第一个tab
        if (i == 0) { _currentItem = item; _currentItem.selected = YES; }
    }
    
}

- (void)itemDidClick:(UIButton *)sender {
    
    //当前选择的index
    self.selectedIndex = _currentItem.tag;
    
    //如果实现了代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        
        //返回NO不操作
        if (![self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[sender.tag]]) return;
        
    }
    
    //取消选中上一个tiem
    _currentItem.selected = !_currentItem.selected;
    //选中当前tiem
    sender.selected = !sender.selected;
    //设置新的选中tiem
    _currentItem = sender;
    //切换页面
    self.selectedIndex = sender.tag;
}

- (void)setTabbarHidden:(BOOL)tabbarHidden {
    
    _tabbarHidden = tabbarHidden;
    _customTabbar.hidden = tabbarHidden;
}

- (void)selectedBarItemWithTag:(NSInteger)tag{
    //取消选中上一个tiem
    _currentItem.selected = !_currentItem.selected;
    //选中当前tiem
    UIButton *btn = [self.buttonItemArray objectAtIndex:tag];
    btn.selected = !btn.selected;
    //设置新的选中tiem
    _currentItem = btn;
    //切换页面
    self.selectedIndex = btn.tag;
}
@end
