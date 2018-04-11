//
//  LoginViewController.h
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/16.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface LoginViewController : UIViewController

@property(nonatomic,strong)UITextField *txtUser;
@property(nonatomic,strong)UITextField *txtPwd;

@property(nonatomic,strong)User *user;


@end
