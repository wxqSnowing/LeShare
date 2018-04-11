//
//  AboutViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/3.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "AboutViewController.h"
#import "HeaderKit.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    /////////////////////////////////////////////////////////////////////////////
    
    UIImageView *imV = [[UIImageView alloc]initWithFrame:AAdaptionRect(KBaseWidth/2-75, 10, 150, 150)];
    imV.image = [UIImage imageNamed:@"myLogo.png"];
    [self.view addSubview:imV];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(KBaseWidth/2-100, 165, 200, 20)];
    versionLabel.text = @"乐分享版本号 : V-0.5";
    versionLabel.font = AAFont(15);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(15, 230, 375-10, 20)];
    contactLabel.text = @"1. 客服热线:028-5616621";
    contactLabel.font = AAFont(18);
    [self.view addSubview:contactLabel];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    //    [self.tabBarController.view addSubview:bottomView];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setHidden:NO];
    //    [bottomView removeFromSuperview];
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
