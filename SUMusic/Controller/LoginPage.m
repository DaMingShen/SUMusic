//
//  LoginPage.m
//  LazyWeather
//
//  Created by 万众科技 on 15/10/27.
//  Copyright © 2015年 SuXiaoMing. All rights reserved.
//

#import "LoginPage.h"

@interface LoginPage ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField * userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;

@property (weak, nonatomic) IBOutlet UIImageView * left_hidden;
@property (weak, nonatomic) IBOutlet UIImageView * right_hidden;
@property (weak, nonatomic) IBOutlet UIImageView * left_look;
@property (weak, nonatomic) IBOutlet UIImageView * right_look;

@property (weak, nonatomic) IBOutlet UIButton * loginButton;

@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (assign,nonatomic) BOOL isEditingPWD;

@end

@implementation LoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UISetting];
    
}

#pragma mark - UI
-(void)UISetting{
    
    self.view.backgroundColor = [UIColor colorWithHexRGB:@"#00AA56"];
    
    UIView * nameLine = [UIView drawHorizonLineWithFrame:CGRectMake(_userNameTextField.x, _userNameTextField.y + _userNameTextField.h, _userNameTextField.w, 1)];
    nameLine.backgroundColor = [UIColor lightGrayColor];
    [_loginView addSubview:nameLine];
    UIView * pwdLine = [UIView drawHorizonLineWithFrame:CGRectMake(_passwordTextField.x, _passwordTextField.y + _passwordTextField.h, _passwordTextField.w, 1)];
    pwdLine.backgroundColor = [UIColor lightGrayColor];
    [_loginView addSubview:pwdLine];
    
    _userNameTextField.layer.borderColor = ClearColor.CGColor;
    _passwordTextField.layer.borderColor = ClearColor.CGColor;
    _loginView.layer.borderColor = ClearColor.CGColor;
    _passwordTextField.secureTextEntry = YES;
}

#pragma mark - textField代理
//处理动画
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _passwordTextField) {
        
        self.isEditingPWD = YES;
        [self animationUserToPassword];
    }else {
        
        if (self.isEditingPWD) {
            [self animationPasswordToUser];
        }
        self.isEditingPWD = NO;
    }
    
}

//处理编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _userNameTextField) {
        
        [_userNameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
        return YES;
    }
    if (textField == _passwordTextField) {
        
        //结束编辑(结束动画too)
        [self.view endEditing:YES];
        [self tapAction:nil];
        return YES;
    }
    return YES;
}

#pragma mark - 移开手动画
-(void)animationPasswordToUser{
    
    [UIView animateWithDuration:0.5f animations:^{
        
        //放着的手出现
        self.left_look.frame  = CGRectMake(self.left_look.x - 80, self.left_look.y, 40, 40);
        self.right_look.frame = CGRectMake(self.right_look.x + 40, self.right_look.y, 40, 40);
        
        //捂着的手隐藏
        self.right_hidden.frame = CGRectMake(self.right_hidden.x + 55, self.right_hidden.y + 40, 40, 66);
        self.left_hidden.frame  = CGRectMake(self.left_hidden.x - 60, self.left_hidden.y + 40, 40, 66);
    }];
}

#pragma mark - 捂眼动画
-(void)animationUserToPassword{
    [UIView animateWithDuration:0.5f animations:^{
        
        //放着的手隐藏
        self.left_look.frame  = CGRectMake(self.left_look.x + 80, self.left_look.y, 0, 0);
        self.right_look.frame = CGRectMake(self.right_look.x - 40, self.right_look.y, 0, 0);
        
        //捂着的手出现
        self.right_hidden.frame = CGRectMake(self.right_hidden.x - 55, self.right_hidden.y - 40, 40, 66);
        self.left_hidden.frame  = CGRectMake(self.left_hidden.x + 60, self.left_hidden.y - 40, 40, 66);
        
    }];
}

#pragma mark - Tap手势
- (IBAction)tapAction:(id)sender {
    
    //结束编辑
    if (self.isEditingPWD) {
        
        [self animationPasswordToUser];
        self.isEditingPWD = NO;
    }
    [self.view endEditing:YES];
}

- (IBAction)login:(id)sender {
    BASE_INFO_FUN(@"登陆");
   [SUNetwork loginWithUserName:_userNameTextField.text password:_passwordTextField.text completion:^(BOOL isSucc, NSString *msg) {
       if (isSucc) {
           BASE_INFO_FUN(msg);
           SendNotify(LoginSUCC, nil);
           [self back:nil];
       }else {
           BASE_INFO_FUN(msg);
           [self ToastMessage:msg];
       }
   }];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
