//
//  LoginViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/16.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "LoginViewController.h"
#import "HeaderKit.h"
#import "LeTabBarViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
typedef enum{
    none,
    user,
    pass
}LoginShowType;
@property(nonatomic,assign)LoginShowType showType;
@property(nonatomic,strong)UIImageView *left;
@property(nonatomic,strong)UIImageView *middle;
@property(nonatomic,strong)UIImageView *right;
@property(nonatomic,strong)LeTabBarViewController *ltbVc;

@property(nonatomic,assign)BOOL flag;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *udf=[[NSUserDefaults alloc] init];
    [udf setBool:YES forKey:@"isfirst"];
    [udf synchronize];//存一下    
    
    self.showType = none;
    [self addView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.txtUser becomeFirstResponder];

}

-(void)addView{
    UIView *topView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, 375, 64)];
    topView.backgroundColor = DefaultColor;
    [self.view addSubview:topView];
    UILabel *tittleLabel = [[UILabel alloc]initWithFrame:AAdaptionRect((375-120)/2, 20, 120, 44)];
    tittleLabel.text = @"登陆";
    tittleLabel.font = AAFont(20);
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    [tittleLabel setTextColor:[UIColor whiteColor]];
    [topView addSubview:tittleLabel];
    
    
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(30, 200+70, 150, 35)];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    registerBtn.backgroundColor = DefaultColor;
    registerBtn.tag = 100;
    registerBtn.layer.cornerRadius = AAdaption(2);
    [registerBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth-60-100+32-50, 200+70, 150, 35)];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.backgroundColor = DefaultColor;
    loginBtn.tag = 101;
    loginBtn.layer.cornerRadius = AAdaption(2);
    [loginBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth-60-100+32-50, 200+70+35+20, 150, 25)];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
//    forgetBtn.backgroundColor = DefaultColor;
    [forgetBtn setTitleColor:DefaultColor forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = AAFont(12);
    forgetBtn.tag = 102;
    [forgetBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    self.left = [[UIImageView alloc]initWithFrame:AAdaptionRect(0, 0+70, 62, 61)];
    self.left.image = [UIImage imageNamed:@"left.png"];
    [self.view addSubview:self.left];
    
    self.middle = [[UIImageView alloc]initWithFrame:AAdaptionRect(120, 15+70, 97, 31)];
    self.middle.image = [UIImage imageNamed:@"myLogo1.png"];
    [self.view addSubview:self.middle];
    
    self.right = [[UIImageView alloc]initWithFrame:AAdaptionRect(KBaseWidth-57, 0+70, 58, 60)];
    self.right.image = [UIImage imageNamed:@"right.png"];
    [self.view addSubview:self.right];

    self.txtUser = [[UITextField alloc]initWithFrame:AAdaptionRect(30, 80+70, 320, 44)];
    self.txtUser.placeholder = @"请输入手机号";
    self.txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtUser.delegate = self;
        [self.txtUser addTarget:self action:@selector(begClick:) forControlEvents:UIControlEventEditingDidBegin];
    self.txtUser.layer.cornerRadius = AAdaption(5);
    self.txtUser.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtUser.layer.borderWidth = AAdaption(0.5);
    self.txtUser.leftView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, 44, 44)];
    self.txtUser.leftViewMode = UITextFieldViewModeAlways;
//    self.txtUser.text = @"18982641698";
    UIImageView *imgUser = [[UIImageView alloc]initWithFrame:AAdaptionRect(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"login_username.png"];
    [self.txtUser.leftView addSubview:imgUser];
    [self.view addSubview:self.txtUser];
    
    self.txtPwd = [[UITextField alloc]initWithFrame:AAdaptionRect(30, 130+70, 320, 44)];
    self.txtPwd.placeholder = @"请输入密码";
    self.txtPwd.secureTextEntry = YES;
    self.txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtPwd.delegate = self;
    [self.txtPwd addTarget:self action:@selector(begClick:) forControlEvents:UIControlEventEditingDidBegin];
//    self.txtPwd.text = @"123456";
    self.txtPwd.layer.cornerRadius = AAdaption(5);
    self.txtPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtPwd.layer.borderWidth = AAdaption(0.5);
    self.txtPwd.leftView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, 44, 44)];
    self.txtPwd.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imgPwd = [[UIImageView alloc]initWithFrame:AAdaptionRect(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"login_password.png"];
    [self.txtPwd.leftView addSubview:imgPwd];
    [self.view addSubview:self.txtPwd];
    
    [self.txtUser becomeFirstResponder];

}

-(void)checkUser:(NSString *)number andPWD:(NSString *)password{
    [AVUser logInWithMobilePhoneNumberInBackground:number password:password block:^(AVUser *user, NSError *error) {
        if (user!=nil) {
            self.ltbVc = [[LeTabBarViewController alloc]init];
            self.ltbVc.user = user;
            [self presentViewController:self.ltbVc animated:NO completion:nil];
        }else{
            UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号和密码不匹配！！" preferredStyle:UIAlertControllerStyleAlert];
            [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:chooseAlert animated:YES completion:nil];
        } 
    }];
}

-(void)click:(UIButton*)btn{
    switch (btn.tag) {
        case 100://注册
        {
            RegisterViewController *ltbvc = [[RegisterViewController alloc]init];
            [self presentViewController:ltbvc animated:NO completion:nil];
            break;
        }
        case 101://登陆
        {
            [self checkUser:self.txtUser.text andPWD:self.txtPwd.text];
            break;
        }
        case 102://忘记密码
        {
            UpdatePWDViewController *ltbvc = [[UpdatePWDViewController alloc]init];
            [self presentViewController:ltbvc animated:NO completion:nil];
            break;
        }
        default:
            break;
    }

}

-(void)begClick:(UITextField *)textField{
    
    if ([textField isEqual:self.txtPwd]) {
        if (self.showType == pass) {
            self.showType = pass;
//            return YES;
        }
        self.showType = pass;
        //animate
        [UIView animateWithDuration:0.01 animations:^(){
            self.left.image = [UIImage imageNamed:@"left_hide.png"];
            self.right.image = [UIImage imageNamed:@"right_hide.png"];
            
        }];
        self.txtUser.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.txtPwd.layer.borderColor = DefaultColor.CGColor;
    }
    
    
    if ([textField isEqual:self.txtUser]) {
        if (self.showType == user) {
            self.showType = user;
//            return YES;
        }
        self.showType = user;
        //animate
        [UIView animateWithDuration:0.01 animations:^(){
            self.left.image = [UIImage imageNamed:@"left.png"];
            self.right.image = [UIImage imageNamed:@"right.png"];
            
        }];
        self.txtUser.layer.borderColor = DefaultColor.CGColor;
        self.txtPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
