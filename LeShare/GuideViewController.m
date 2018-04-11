//
//  GuideViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/4.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "HeaderKit.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;//分页控制器
    UIButton *_btn;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor cyanColor];
    
    UIScrollView *sv=[[UIScrollView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth, KBaseHeight)];
    
    for (int i=1; i<6;i++ ) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:AAdaptionRect(KBaseWidth*(i-1), 0, KBaseWidth, KBaseHeight)];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [sv addSubview:imageView];
        if (i==5) {
            _btn=[UIButton buttonWithType:UIButtonTypeCustom];
            _btn.frame=AAdaptionRect((KBaseWidth-141)/2, KBaseHeight-100, 141, 31);
            [_btn setBackgroundImage:[UIImage imageNamed:@"lijitiyan.png"] forState:UIControlStateNormal];
            [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            _btn.alpha=0;
            
            imageView.userInteractionEnabled=YES;   //让用户能点击
            [imageView addSubview:_btn];
        }
    }
    [self.view addSubview:sv];
    
    sv.contentSize=CGSizeMake(AAdaption(KBaseWidth*5), AAdaptionY(KBaseHeight));
    sv.pagingEnabled=YES;
    sv.bounces=YES;
    sv.showsHorizontalScrollIndicator=NO;
    sv.showsVerticalScrollIndicator=NO;
    sv.delegate=self;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:AAdaptionRect(10, KBaseHeight-40-10, KBaseWidth-20, 40)];
    _pageControl.numberOfPages=5;
    
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor]
    ;
    _pageControl.currentPageIndicatorTintColor=[UIColor magentaColor];
    [self.view addSubview:_pageControl];
    
    
}
//停止减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index=scrollView.contentOffset.x/AAdaption(KBaseWidth);
    _pageControl.currentPage=index;
    
    if (index==4) {
        [UIView animateWithDuration:1 animations:^{
            _btn.alpha=1;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//跳转
-(void) btnClick:(UIButton *)btn{
    // NSLog(@"1");
    LoginViewController *mtbc=[[LoginViewController alloc] init];
    mtbc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mtbc animated:YES completion:nil];
}

@end
