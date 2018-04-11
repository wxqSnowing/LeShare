//
//  RegisterViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/16.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "RegisterViewController.h"
#import "HeaderKit.h"
#import "PhoneCodeViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneTxtField;
@property(nonatomic,strong)UILabel *errorInfolabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    tittleLabel.text = @"注册";
    tittleLabel.font = AAFont(20);
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    [tittleLabel setTextColor:[UIColor whiteColor]];
    [topView addSubview:tittleLabel];
    
    _phoneTxtField = [[UITextField alloc]initWithFrame:AAdaptionRect(5, 80, 365, 50)];
    _phoneTxtField.placeholder = @"请输入手机号码";
    _phoneTxtField.delegate = self;
    _phoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneTxtField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_phoneTxtField.frame.origin.x,_phoneTxtField.frame.origin.y+_phoneTxtField.frame.size.height,_phoneTxtField.frame.size.width,AAdaption(0.3))];
    lineView.backgroundColor = DefaultColor;
    [self.view addSubview:lineView];
    
    self.errorInfolabel = [[UILabel alloc]initWithFrame:AAdaptionRect(5, 140, 365, 18)];
    self.errorInfolabel.text = @"手机号码输入错误！";
    self.errorInfolabel.hidden = YES;
    self.errorInfolabel.textColor = [UIColor redColor];
    self.errorInfolabel.font = AAFont(13);
    [self.view addSubview:self.errorInfolabel];
    
    UIButton * registerBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(10, 190, 355, 40)];
    registerBtn.backgroundColor =DefaultColor;
    [registerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    registerBtn.tag = 11;
    registerBtn.layer.cornerRadius = AAdaption(5);
    [registerBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(15, 240, 375-30, 40)];
    tipLabel.text = @"点击“获取验证码”按钮，即表示同意注册协议";
    tipLabel.textColor = [UIColor lightGrayColor];
    [tipLabel setFont:AAFont(14)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
}

//获取验证码
-(void)click:(UIButton *)btn{
    switch (btn.tag) {
        case 10:
        {
            //回到登陆界面
            LoginViewController *lgVC = [LoginViewController alloc];
            [self presentViewController:lgVC animated:NO completion:nil];
            break;
        }
        case 11:
        {
            if ([self vailMobile:self.phoneTxtField.text]) {
                AVQuery *query = [AVQuery queryWithClassName:@"AllUser"];
                [query whereKey:@"phoneNumber" equalTo:self.phoneTxtField.text];
                if (![query getFirstObject]) {
                    [AVOSCloud requestSmsCodeWithPhoneNumber:self.phoneTxtField.text callback:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //succeed
                            PhoneCodeViewController *lgVC = [PhoneCodeViewController alloc];
                            lgVC.phoneNumber = self.phoneTxtField.text;
                            lgVC.isRe = YES;
                            [self presentViewController:lgVC animated:NO completion:nil];
                        }else{
                        }
                    }];
                    
                }else{
                    UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该手机号已经被注册！！" preferredStyle:UIAlertControllerStyleAlert];
                    [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:chooseAlert animated:YES completion:nil];
                
                }
            }else{
                NSLog(@"error");
                self.errorInfolabel.hidden = NO;
            }
            break;
        }
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.errorInfolabel.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}

//手机号验证
-(BOOL)vailMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length!=11) {
        return NO;
    }else{
        //移动正则表达式
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        //联通正则表达式
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        //电信正则表达式
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
