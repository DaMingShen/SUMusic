//
//  DorpDownList.m
//  LazyWeather
//
//  Created by KevinSu on 15/11/7.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SuDropDownList.h"

@interface SuDropDownList ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UIView * initView;
@property (nonatomic,weak) NSArray * sourceArray;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation SuDropDownList

- (id)initWithView:(UIView *)view SourceArray:(NSArray *)sourceArray{
    
    if (self = [super init]) {
        
        self.initView = view;
        self.sourceArray = sourceArray;
        self.frame = self.initView.superview.bounds;
        [self show];
    }
    return self;
}

- (void)show {
    
    //设置背景为透明
    self.backgroundColor = ClearColor;
    [self.initView.superview addSubview:self];
    
    //添加背景
    UIView * bg = [[UIView alloc]initWithFrame:self.bounds];
    bg.backgroundColor = BlackColor;
    bg.alpha = 0.f;
    [self addSubview:bg];
    
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissList)];
    [bg addGestureRecognizer:tap];
    
    //使用表格展示内容
    CGFloat tableH = self.sourceArray.count > 6 ? 6 * self.initView.h : self.sourceArray.count * self.initView.h;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(_initView.x, _initView.y, _initView.w, tableH) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.rowHeight = self.initView.h;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //分割线置顶
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self addSubview:self.tableView];
    
    
    //添加出现的动画
    POPSpringAnimation * frameAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAni.toValue = [NSValue valueWithCGRect:CGRectMake(_tableView.x, _tableView.y, _tableView.w, tableH)];
    frameAni.springBounciness = 5.0;
    [_tableView pop_addAnimation:frameAni forKey:@"showAni"];
    
    POPBasicAnimation * opacityAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAni.fromValue = @(0);
    opacityAni.toValue = @(0.3);
    opacityAni.duration = 0.8;
    [bg.layer pop_addAnimation:opacityAni forKey:@"Opacity"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * ID = @"dropDownCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = self.sourceArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.callBackBlack) {
        
        self.callBackBlack(self.sourceArray[indexPath.row],(int)indexPath.row);
    }
    
    [self dismissList];
}

- (void)dismissList {
    
    //添加消失的动画
//    POPSpringAnimation * frameAni = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    frameAni.toValue = [NSValue valueWithCGRect:CGRectMake(_tableView.x, _tableView.y, _tableView.w, _initView.h)];
//    frameAni.springBounciness = 0.f;
//    frameAni.springSpeed = 45;
//    [_tableView pop_addAnimation:frameAni forKey:@"showAni"];
//    [frameAni setCompletionBlock:^(POPAnimation * ani, BOOL isFinished) {
//        
//        if (isFinished) {
//            
//            [self removeFromSuperview];
//        }
//    }];
    
    POPBasicAnimation * opacityAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAni.toValue = @(0);
    opacityAni.duration = 0.3;
    [self.layer pop_addAnimation:opacityAni forKey:@"Opacity"];
    [opacityAni setCompletionBlock:^(POPAnimation * ani, BOOL isFinished) {
        
        if (isFinished) {
            
            [self removeFromSuperview];
        }
    }];
    
}



@end
