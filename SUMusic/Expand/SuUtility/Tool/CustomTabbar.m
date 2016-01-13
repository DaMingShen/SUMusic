//
//  CustomTabbar.m
//  SuUtility
//
//  Created by KevinSu on 15/10/18.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "CustomTabbar.h"

@interface CustomTabbar ()

/**
 *  设置之前选中的按钮
 */
@property (nonatomic, weak) UIButton * selectedBtn;

/**
 *  面板的颜色
 */
@property (nonatomic, weak) UIColor * tabbarColor;

/**
 *  面板的背景图片
 */
@property (nonatomic, weak) NSString * imgName;

/**
 *  页面数组
 */
@property (nonatomic, weak) NSArray * pageArray;

/**
 *  名字数组
 */
@property (nonatomic, weak) NSArray * nameArray;

/**
 *  正常图片数组
 */
@property (nonatomic, weak) NSArray * norImgArray;

/**
 *  选中图片数组
 */
@property (nonatomic, weak) NSArray * SelImgArray;

/**
 *  未选择的颜色
 */
@property (nonatomic, weak) UIColor * norColor;

/**
 *  选中的颜色
 */
@property (nonatomic, weak) UIColor * selColor;


@end

@implementation CustomTabbar


+ (instancetype)creatTabbarInController:(UIViewController *)controller WithTabbarColor:(UIColor *)tabbarColor BgImage:(NSString *)bgImg Page:(NSArray *)pageArray NameArray:(NSArray *)nameArray NorImgArray:(NSArray *)norImgArray SelImgArray:(NSArray *)selImgArray norColor:(UIColor *)norColor selColor:(UIColor *)selColor {
    
    CustomTabbar * newTabbar = [[CustomTabbar alloc]init];
    newTabbar.tabbarColor = tabbarColor;
    newTabbar.imgName = bgImg;
    newTabbar.pageArray = pageArray;
    newTabbar.nameArray = nameArray;
    newTabbar.norImgArray = norImgArray;
    newTabbar.SelImgArray = selImgArray;
    newTabbar.norColor = norColor;
    newTabbar.selColor = selColor;
    [newTabbar configTabbar];
    
    controller = newTabbar;
    return newTabbar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //下面两个方法在开发中是经常会用到的
    //    NSLog(@"%s",__func__);
    //    NSLog(@"%@",self.view.subviews); //能打印出所有子视图,和其frame
}
    
- (void)configTabbar {
    //删除现有的tabBar
    CGRect rect = self.tabBar.frame;
    [self.tabBar removeFromSuperview];  //移除TabBarController自带的下部的条
    
    //------------------------测试添加自己的视图------------------------
    UIView * myView = [[UIView alloc] init];
    myView.frame = rect;
    
    //自定义颜色
    if (self.tabbarColor) {
        myView.backgroundColor = self.tabbarColor;
    }
    
    //自定义背景图片
    if (self.imgName) {
        UIImageView * bgView = [[UIImageView alloc]initWithFrame:rect];
        bgView.image = [UIImage imageNamed:self.imgName];
        [myView addSubview:bgView];
    }
    
    [self.view addSubview:myView];
    
    
    //------------------------添加栏目按钮------------------------
    for (int i = 0; i < self.pageArray.count; i++) {
        
        //图片文字垂直排列的按钮
        SuButton * btn = [[SuButton alloc] init];
        
        if (self.norImgArray) {
            [btn setImage:[UIImage imageNamed:self.norImgArray[i]] forState:UIControlStateNormal];
        }
        
        if (self.SelImgArray) {
            [btn setImage:[UIImage imageNamed:self.SelImgArray[i]] forState:UIControlStateSelected];
        }
        
        if (self.nameArray) {
            [btn setTitle:self.nameArray[i] forState:UIControlStateNormal];
            [btn setTitle:self.nameArray[i] forState:UIControlStateSelected];
        }
        
        if (self.norColor) {
            [btn setTitleColor:self.norColor forState:UIControlStateNormal];
        }
        if (self.selColor) {
            [btn setTitleColor:self.selColor forState:UIControlStateSelected];
        }
        
        
        CGFloat x = i * myView.frame.size.width / self.pageArray.count;
        btn.frame = CGRectMake(x, 0, myView.frame.size.width / self.pageArray.count, myView.frame.size.height);
        
        [myView addSubview:btn];
        
        btn.tag = i;//设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
        
        //带参数的监听方法记得加"冒号"
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置刚进入时,第一个按钮为选中状态
        if (0 == i) {
            btn.selected = YES;
            self.selectedBtn = btn;  //设置该按钮为选中的按钮
            
            
        }
    }
    
    //------------------------添加VC------------------------
    if (self.pageArray) {
        
        for (Class cls in self.pageArray) {
            //创建一个界面(包含导航)
            UIViewController *vc = [[cls alloc] init];
            UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            //添加到tabBar中
            NSMutableArray * marr = [[NSMutableArray alloc] initWithArray:self.viewControllers];
            [marr addObject:nc];
            self.viewControllers = marr;
        }
    }
}
    

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = button.tag;
}





@end
