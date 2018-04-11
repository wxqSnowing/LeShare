//
//  UpdatePWDViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/16.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "UpdatePWDViewController.h"
#import "HeaderKit.h"
#import "PhoneCodeViewController.h"

@interface UpdatePWDViewController ()
@property(nonatomic,strong)UITextField *code;

@end

@implementation UpdatePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    tittleLabel.text = @"重置密码";
    tittleLabel.font = AAFont(20);
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    [tittleLabel setTextColor:[UIColor whiteColor]];
    [topView addSubview:tittleLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 70, 375-20, 30)];
    tipLabel.text = @"您可以通过绑定的手机号码重置密码";
    tipLabel.font = AAFont(15);
    [tipLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:tipLabel];
    
    self.code = [[UITextField alloc]initWithFrame:AAdaptionRect(10, 120, 375-20, 50)];
    self.code.placeholder = @"请输入手机号码";
    [self.view addSubview:self.code];
    
    UIView *line = [[UIView alloc]initWithFrame:AAdaptionRect(10, 170-1, 375-20, 1)];
    line.backgroundColor = DefaultColor;
    [self.view addSubview:line];
    
    UIButton * nextBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(10, 190, 375-20, 40)];
    nextBtn.backgroundColor = DefaultColor;
    [nextBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = AAdaption(5);
    nextBtn.tag = 11;
    [nextBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:nextBtn];
    
}

-(void)click:(UIButton *)btn{
    switch (btn.tag) {
        case 10:
        {
            LoginViewController *rVC = [LoginViewController alloc];
            [self presentViewController:rVC animated:NO completion:nil];
            break;
            
        }
        case 11:
        {
            //判断用户是否存在
            AVQuery *query = [AVQuery queryWithClassName:@"AllUser"];
            [query whereKey:@"phoneNumber" equalTo:self.code.text];
            if ([query getFirstObject]) {
                [AVUser requestPasswordResetWithPhoneNumber:self.code.text block:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        //succeed
                        PhoneCodeViewController *rVC = [PhoneCodeViewController alloc];
                        rVC.phoneNumber = self.code.text;
                        rVC.isRe = NO;
                        [self presentViewController:rVC animated:NO completion:nil];
                    }else{
                    }
                    
                }];
            }else{
                //失败
                UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不存在！！" preferredStyle:UIAlertControllerStyleAlert];
                [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:chooseAlert animated:YES completion:nil];
            }
            break;
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
