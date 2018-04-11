//
//  PhoneCodeViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/4/26.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "PhoneCodeViewController.h"
#import "HeaderKit.h"
#import "RegisterViewController.h"

#import "PhoneCodeViewController.h"

@interface PhoneCodeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSString *codeNumber;
@property(nonatomic,strong)UITextField *code;
@property(nonatomic,strong)UITextField *passwordNew;
@property(nonatomic,strong)UITextField *passwordConfirm;
@end

@implementation PhoneCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor yellowColor];
    [self addView];
}

-(void)addView{
    UIView *topView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, 375, 64)];
    topView.backgroundColor = DefaultColor;
    [self.view addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(0, 20, 30, 44)];
    [backBtn setTitle:@"← " forState:UIControlStateNormal];
    backBtn.tag = 10;
    [backBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel *tittleLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(375/2-60, 20, 120, 44)];
    tittleLabel.text = @"获取验证码";
    tittleLabel.font = AAFont(20);
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    [tittleLabel setTextColor:[UIColor grayColor]];
    [topView addSubview:tittleLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(20, 70, 375-30, 30)];
    tipLabel.text = @"验证码已经发送到手机，请在10分钟内完成注册";
    tipLabel.font = AAFont(15);
    [tipLabel setTextColor:DefaultColor];
    [self.view addSubview:tipLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(100, 110, 175, 30)];
    phoneLabel.text = self.phoneNumber;
    [phoneLabel setTextColor:DefaultColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneLabel];
    
    self.code = [[UITextField alloc]initWithFrame:AAdaptionRect(100, 150, 175, 50)];
    self.code.placeholder = @"请输入验证码";
    self.code.delegate = self;
    self.code.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.code];
    
    if (!self.isRe) {
        self.passwordNew = [[UITextField alloc]initWithFrame:AAdaptionRect(100, 200, 175, 40)];
        self.passwordNew.placeholder = @"请输入密码";
        self.passwordNew.delegate = self;
        self.passwordNew.secureTextEntry = YES;
        [self.view addSubview:self.passwordNew];
        
        self.passwordConfirm = [[UITextField alloc]initWithFrame:AAdaptionRect(100, 250, 175, 40)];
        self.passwordConfirm.placeholder = @"再次输入密码确认";
        self.passwordConfirm.delegate = self;
        self.passwordConfirm.secureTextEntry = YES;
        [self.view addSubview:self.passwordConfirm];
        
        UIButton * nextBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(10, 300, 375-20, 40)];
        nextBtn.backgroundColor = DefaultColor;
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextBtn.layer.cornerRadius = AAdaption(5);
        [nextBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.tag = 11;
        [self.view addSubview:nextBtn];
        
    }else{
        UIButton * nextBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(10, 210, 375-20, 40)];
        nextBtn.backgroundColor = DefaultColor;
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextBtn.layer.cornerRadius = AAdaption(5);
        [nextBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.tag = 11;
        [self.view addSubview:nextBtn];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


-(void)click:(UIButton *)btn{
    switch (btn.tag) {
        case 10:
        {
            LoginViewController *rVC = [LoginViewController alloc];
            [self presentViewController:rVC animated:NO completion:nil];
        }
        case 11:
        {
            //注册
            if (self.isRe) {
                self.codeNumber = self.code.text;
                NSLog(@"手机号，密码：%@%@",self.phoneNumber,self.codeNumber);
                [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneNumber smsCode:self.codeNumber block:^(AVUser *user, NSError *error) {
                    // 如果 error 为空就可以表示登录成功了，并且 user 是一个全新的用户
                    if (error==nil) {
                        CFUUIDRef uuidRef =CFUUIDCreate(NULL);
                        CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
                        CFRelease(uuidRef);
                        NSString *uniqueId = (__bridge NSString *)(uuidStringRef);
                        
                        AVObject *aUser = [[AVObject alloc]initWithClassName:@"AllUser"];
                        [aUser setObject:self.phoneNumber forKey:@"phoneNumber"];
                        [aUser setObject:uniqueId forKey:@"userName"];
                        [aUser setObject:@"123456" forKey:@"password"];
                        [aUser setObject:@"http://ac-yla0dwuu.clouddn.com/89bd1c35b39238818db0.jpg" forKey:@"headUrl"];
                        
                        [aUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                //在allUser中添加用户成功
                                LoginViewController *rVC = [LoginViewController alloc];
//                                rVC.user = [AVUser currentUser];
//                                NSLog(@"传过去的用户%@",rVC.user);
//                                [rVC.user setObject:uniqueId forKey:@"username"];
//                                [rVC.user setObject:@"123456" forKey:@"password"];
//                                [rVC.user saveInBackground];
                                [self presentViewController:rVC animated:NO completion:nil];
                            }
                        }];
                    }else{
                        NSLog(@"%@",error);
                        //失败
                        UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误！！" preferredStyle:UIAlertControllerStyleAlert];
                        [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [self presentViewController:chooseAlert animated:YES completion:nil];
                    }
                }];
            }
            //修改密码
            else{
                //判断两次输入是否一致
                if ([self.passwordNew.text isEqualToString:self.passwordConfirm.text]) {
                    NSLog(@"两次密码输入一致");
                    
                    [AVUser resetPasswordWithSmsCode:self.code.text newPassword:self.passwordNew.text block:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            NSLog(@"重置成功");
                            
                            LoginViewController *lgVC = [[LoginViewController alloc]init];
                            [self presentViewController:lgVC animated:NO completion:nil];
                        }else{
                            //失败
                            UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误！！" preferredStyle:UIAlertControllerStyleAlert];
                            [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            [self presentViewController:chooseAlert animated:YES completion:nil];
                        
                        }
                    }];
                }
                else{
                    NSLog(@"两次输入密码不一致，请重新输入");
                    UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入密码不一致，请重新输入！！" preferredStyle:UIAlertControllerStyleAlert];
                    [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:chooseAlert animated:YES completion:nil];

                }
            }
        }
        default:
            break;
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
