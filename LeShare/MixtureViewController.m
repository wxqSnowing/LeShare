//
//  MixtureViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/15.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "MixtureViewController.h"
#import "HeaderKit.h"
#import "ShareTableViewCell.h"
#import "WorkDetailViewController.h"
#import "SelectTypeViewController.h"
#import "WebViewController.h"

@interface MixtureViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *allShareTable;     //tableView
@property (nonatomic, strong) NSMutableArray *imagesMArray; // 图片数组
@property(nonatomic,strong)UIScrollView *myScrollView;      //滚动视图，把所有的控件放在滑动视图之中
@property(nonatomic,strong)NSArray *dataArray;     //tableView中的数据的获取
@property(nonatomic,strong)NSArray *RandomArray;    //话题类型数组
@end
@implementation MixtureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getType];
    
    [self addView];
    
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getData];
    [self.allShareTable reloadData];
}

#pragma - 获取话题类型
-(void)getType{
    AVQuery *query = [AVQuery queryWithClassName:@"LeShareType"];
    [query whereKey:@"flag" equalTo:@"1"];
    NSArray *arry = [query findObjects];
    NSMutableArray *typeArray = [NSMutableArray array];
    for (int i=0; i<arry.count; i++) {
        AVObject *obj = arry[i];
        [typeArray addObject:[obj objectForKey:@"type"]];
    }
    self.RandomArray = [typeArray mutableCopy];
    
    self.RandomArray = [self.RandomArray sortedArrayUsingComparator:^NSComparisonResult(NSString *str1,NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        }else{
            return [str2 compare:str1];
        }
    }];
}

#pragma - 点击“换一批”按钮后话题类型随机生成
-(void)themeClick{
    [self getType];
    for (int i=30; i<38; i++) {
        UILabel *label = [self.view viewWithTag:i];
        label.text = self.RandomArray[i%30];
    }
}

#pragma - 获取网络数据
-(void)getData{
    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
    [query orderByDescending:@"goodNum"];      //结果按照goodNum排序
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.dataArray = [[NSArray alloc]initWithArray:objects];
        [self.allShareTable reloadData];
    }];
}

#pragma - 初始化滚动视图图片数组
- (NSMutableArray<UIImageView *> *)imagesMArray {
    if (!_imagesMArray) {
        _imagesMArray = [NSMutableArray array];
    }
    return _imagesMArray;
}

#pragma - 初始化无限轮播视图
-(void)initScrollPic{
    //滚动视图//////////////////////
    for (NSInteger index = 1; index < 6; index ++) {
        NSString *imageName = [NSString stringWithFormat:@"%ld.jpg", index+5];
        [self.imagesMArray addObject:imageName];
        }
    /*网络获取数据
     SDCycleScrollView *cycleScrollView = [cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:placeholderImage];
     cycleScrollView.imageURLStringsGroup = imagesURLStrings;
     */
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击点击！！！");
    WebViewController *vc = [[WebViewController alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
//
//    [[UIApplication sharedApplication]openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
//        
//        if (!success) {
//            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"不能完成跳转" message:@"请确认App已经安装" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleCancel handler:nil];
//            
//            [aler addAction:cancelAction];
//            
//            [self  presentViewController:aler animated:YES completion:nil];
//            
//        }
//    }];
    
}

#pragma - 添加视图，初始化操作
-(void)addView{
    //初始化滚动视图
    self.myScrollView = [[UIScrollView alloc]initWithFrame:AAdaptionRect(0, 0, 375, 667-64)];
    self.myScrollView.delegate = self;
    self.myScrollView.scrollEnabled = YES;
    self.myScrollView.canCancelContentTouches = NO;
    self.myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.myScrollView.clipsToBounds = YES;
    self.myScrollView.contentSize = CGSizeMake(0, 667*2);
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myScrollView];
    
    [self initScrollPic];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:AAdaptionRect(0, 0, 375, 200) imageNamesGroup:self.imagesMArray];
    cycleScrollView.autoScrollTimeInterval = 1;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.myScrollView addSubview:cycleScrollView];
    //-----------------添加按钮菜单----------160//
    UIView * btnsView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 200, KBaseWidth, 200)];
    btnsView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:btnsView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:AAdaptionRect(2, 5, 25, 37)];
    imageView.image = [UIImage imageNamed:@"theme.png"];
    [btnsView addSubview:imageView];
    
    UILabel *themeLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(35, 13, 80, 18)];
    themeLabel.text = @"热门专题";
    themeLabel.textColor = [UIColor lightGrayColor];
    themeLabel.font = AAFont(16);
    [btnsView addSubview:themeLabel];
    
    UIButton *RandomBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(280, 5, 90, 30)];
    [RandomBtn setImage:[UIImage imageNamed:@"刷新.png"] forState:UIControlStateNormal];
    [RandomBtn setTitle:@"换一批" forState:UIControlStateNormal];
    RandomBtn.titleLabel.font = AAFont(12);
    [RandomBtn setTitleColor:DefaultColor forState:UIControlStateNormal];
    RandomBtn.tag = 100;
    [RandomBtn addTarget:self action:@selector(themeClick) forControlEvents:UIControlEventTouchUpInside];
    [btnsView addSubview:RandomBtn];
    
    UIView *lView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 199, KBaseWidth, 0.5)];
    lView.backgroundColor = DefaultColor;
    [btnsView addSubview:lView];
    
    UIButton *foodBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37, 5+40, 50, 50)];
    foodBtn.backgroundColor = DefaultColor;
    foodBtn.tag = 20;
    [foodBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [foodBtn setImage:[UIImage imageNamed:@"food.png"] forState:UIControlStateNormal];
    foodBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:foodBtn];
    UILabel *foodLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37, 60+40, 50, 15)];
    foodLabel.text = self.RandomArray[foodBtn.tag%20];
    foodLabel.font = AAFont(10);
    foodLabel.tag = 30;
    foodLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:foodLabel];

    UIButton *movieBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37+50+37, 5+40, 50, 50)];
    movieBtn.backgroundColor = DefaultColor;
    movieBtn.tag = 21;
    [movieBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [movieBtn setImage:[UIImage imageNamed:@"movie.png"] forState:UIControlStateNormal];
    movieBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:movieBtn];
    UILabel *movieLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37+50+37, 60+40, 60, 15)];
    movieLabel.text = @"最新";
    movieLabel.text = self.RandomArray[movieBtn.tag%20];
    movieLabel.font = AAFont(10);
    movieLabel.tag = 31;
    movieLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:movieLabel];
    
    UIButton *yuleBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37+50+37+50+37, 5+40, 50, 50)];
    yuleBtn.backgroundColor = DefaultColor;
    yuleBtn.tag = 22;
    [yuleBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [yuleBtn setImage:[UIImage imageNamed:@"yule.png"] forState:UIControlStateNormal];
    yuleBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:yuleBtn];
    UILabel *yuleLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37+50+37+50+37, 60+40, 60, 15)];
    yuleLabel.text = @"最热";
    yuleLabel.tag = 32;
    yuleLabel.text = self.RandomArray[yuleBtn.tag%20];
    yuleLabel.font = AAFont(10);
    yuleLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:yuleLabel];
    
    UIButton *xzBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37+50+37+50+37+50+37, 5+40, 50, 50)];
    xzBtn.backgroundColor = DefaultColor;
    xzBtn.tag = 23;
    [xzBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [xzBtn setImage:[UIImage imageNamed:@"xingzuo.png"] forState:UIControlStateNormal];
    xzBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:xzBtn];
    UILabel *xzLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37+50+37+50+37+50+37, 60+40, 60, 15)];
    xzLabel.text = @"唯美";
    xzLabel.text = self.RandomArray[xzBtn.tag%20];
    xzLabel.font = AAFont(10);
    xzLabel.tag = 33;
    xzLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:xzLabel];
    
    UIButton *kjBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37, 85+40, 50, 50)];
    kjBtn.backgroundColor = DefaultColor;
    kjBtn.tag = 24;
    [kjBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [kjBtn setImage:[UIImage imageNamed:@"yule.png"] forState:UIControlStateNormal];
    kjBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:kjBtn];
    UILabel *kjLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37, 85+50+5+40, 50, 15)];
    kjLabel.text = @"青春";
    kjLabel.text = self.RandomArray[kjBtn.tag%20];
    kjLabel.font = AAFont(10);
    kjLabel.tag = 34;
    kjLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:kjLabel];
    
    UIButton *dmBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37+50+37, 85+40, 50, 50)];
    dmBtn.backgroundColor = DefaultColor;
    dmBtn.tag = 25;
    [dmBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [dmBtn setImage:[UIImage imageNamed:@"xingzuo.png"] forState:UIControlStateNormal];
    dmBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:dmBtn];
    UILabel *dmLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37+50+37, 85+50+5+40, 50, 15)];
    dmLabel.text = @"科技";
    dmLabel.text = self.RandomArray[dmBtn.tag%20];
    dmLabel.font = AAFont(10);
    dmLabel.tag = 35;
    dmLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:dmLabel];

    UIButton *yxBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37+50+37+50+37, 85+40, 50, 50)];
    yxBtn.backgroundColor = DefaultColor;
    yxBtn.tag = 26;
    [yxBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [yxBtn setImage:[UIImage imageNamed:@"movie.png"] forState:UIControlStateNormal];
    yxBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:yxBtn];
    UILabel *yxLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37+50+37+50+37, 85+50+5+40, 50, 15)];
    yxLabel.text = @"书籍";
    yxLabel.text = self.RandomArray[yxBtn.tag%20];
    yxLabel.font = AAFont(10);
    yxLabel.tag = 36;
    yxLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:yxLabel];
    
    UIButton *yyBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(37+50+37+50+37+50+37, 85+40, 50, 50)];
    yyBtn.backgroundColor = DefaultColor;
    yyBtn.tag = 27;
    [yyBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [yyBtn setImage:[UIImage imageNamed:@"food.png"] forState:UIControlStateNormal];
    yyBtn.layer.cornerRadius = AAdaption(25);
    [btnsView addSubview:yyBtn];
    UILabel *yyLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(37+50+37+50+37+50+37, 85+50+5+40, 50, 15)];
    yyLabel.text = @"二次元";
    yyLabel.text = self.RandomArray[yyBtn.tag%20];
    yyLabel.font = AAFont(10);
    yyLabel.tag = 37;
    yyLabel.textAlignment = NSTextAlignmentCenter;
    [btnsView addSubview:yyLabel];
    //------------------------------------------------//
    UIImageView *imageViewnew = [[UIImageView alloc]initWithFrame:AAdaptionRect(2, 403, 25, 37)];
    imageViewnew.image = [UIImage imageNamed:@"theme.png"];
    [self.myScrollView addSubview:imageViewnew];
    
    UILabel *themeLabelnew = [[UILabel alloc]initWithFrame:AAdaptionRect(35, 402+9, 80, 18)];
    themeLabelnew.text = @"热门分享";
    themeLabelnew.textColor = [UIColor lightGrayColor];
    themeLabelnew.font = AAFont(16);
    [self.myScrollView addSubview:themeLabelnew];

    [self.myScrollView addSubview:self.allShareTable];
}

#pragma - 点击话题按钮进入话题详情
-(void)click:(UIButton *)btn{
    NSString *selectedType = self.RandomArray[btn.tag%20];
    SelectTypeViewController *sTVC = [[SelectTypeViewController alloc]init];
    sTVC.selectType = selectedType;
    [self.navigationController pushViewController:sTVC animated:NO];
}

#pragma - tableView视图的初始化操作
-(UITableView *)allShareTable{
    if (!_allShareTable) {
          _allShareTable = [[UITableView alloc]initWithFrame:AAdaptionRect(0, 200+200+40, 375, 667) style:UITableViewStylePlain];
        _allShareTable.separatorColor = [UIColor clearColor];
        _allShareTable.delegate = self;
        _allShareTable.dataSource = self;
    }
    return _allShareTable;
}

#pragma - tableView的代理方法
#pragma 分区
- (NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}
#pragma 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
#pragma 设置tableView的Cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier = @"tableIdentifier";
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[ShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    cell.work = self.dataArray[indexPath.row];
    return cell;
}
#pragma 设置每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AAdaptionY(190);
}
#pragma 选择点击一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"选中行");
    
    NSString *obId = [self.dataArray[indexPath.row] objectForKey:@"objectId"];
    
    AVObject *theTodo = [AVObject objectWithClassName:@"ShareWork" objectId:obId];
    
    NSInteger newSeenNum = [[self.dataArray[indexPath.row] objectForKey:@"seenNum"] integerValue]+1;
    NSLog(@"%ld",(long)newSeenNum);
    NSNumber *number = [NSNumber numberWithInteger:newSeenNum];
    [theTodo setObject:number forKey:@"seenNum"];

    [theTodo saveInBackground];
    WorkDetailViewController *wDVC = [[WorkDetailViewController alloc]init];
    wDVC.objc = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:wDVC animated:YES];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
