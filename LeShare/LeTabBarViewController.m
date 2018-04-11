//
//  LeTabBarViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/15.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "LeTabBarViewController.h"
#import "RootViewController.h"
#import "HeaderKit.h"
@interface LeTabBarViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) NSMutableArray <UIViewController *> *childVCArray; // 控制器数组
@end

@implementation LeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数组
    self.childVCArray = [NSMutableArray array];
    self.tabBar.tintColor = DefaultColor;
    self.tabBar.translucent = NO;
    // 添加视图控制器，初始化标签控制器
    [self addChildVC];
}

- (void)addChildVC {
    [self addChildVCWithTitle:@"大杂烩" withClassName:@"MixtureViewController" withNormalImageName:@"mixture" withSelectedImageName:@"mixture_selected"];
    
    [self addChildVCWithTitle:@"推荐" withClassName:@"RecommendViewController" withNormalImageName:@"recommend" withSelectedImageName:@"recommend_selected"];
    
    [self addChildVCWithTitle:@"去分享" withClassName:@"ShareViewController" withNormalImageName:@"share" withSelectedImageName:@"share_selected"];
    
    [self addChildVCWithTitle:@"我的" withClassName:@"MineViewController" withNormalImageName:@"mine" withSelectedImageName:@"mine_selected"];
}

- (void)addChildVCWithTitle:(NSString *)title withClassName:(NSString *)className withNormalImageName:(NSString *)normalImageName withSelectedImageName:(NSString *)selectedImageName {
    // 视图控制器
    UIViewController *vc = [[NSClassFromString(className) alloc]init];
    vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    // 导航控制器
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    // 背景色
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    // 前景色
    nav.navigationBar.tintColor = [UIColor blackColor];
    // 透明度
    nav.navigationBar.translucent = NO;
    // 去掉导航栏颜色分界颜色
    //    [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    nav.navigationBar.shadowImage = [[UIImage alloc] init];
    // 设置标题颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    vc.title = title;
    
    vc.view.backgroundColor = [UIColor whiteColor];
    // 添加到数组
    [self.childVCArray addObject:nav];
    self.viewControllers = self.childVCArray;
    nav.navigationBarHidden = YES;
    
}

@end

