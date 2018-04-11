//
//  MySelfViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/3.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "MySelfViewController.h"
#import "HeaderKit.h"
#import "WorkDetailViewController.h"
#import "PersonalInfoTableViewCell.h"

@interface MySelfViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *guanZhuBtn;
@property(nonatomic,strong)UIButton *dongtaiBtn;//动态
@property(nonatomic,strong)UIButton *fabiaoBtn;//个人发表
@property(nonatomic,strong)UIButton *shoucangBtn;//收藏
@property(nonatomic,strong)UIView *moveView;

@property(nonatomic,strong)UITableView *myTableView;

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *collectionIDArray;
@property(nonatomic,strong)NSString *headPicStr;

@end

@implementation MySelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    /////////////////////////////////////////////////////////////////////////////
    [self addView];
    
    
    AVUser *user = [AVUser currentUser];
    NSString *name = [user objectForKey:@"username"];
    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"auther" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.dataArray = [[NSArray alloc]initWithArray:objects];
        [self.myTableView reloadData];
        NSLog(@"-------%lu-------",(unsigned long)self.dataArray.count);
    }];
}

-(void)addView{
    self.imageV = [[UIImageView alloc]initWithFrame:AAdaptionRect(KBaseWidth/2-40,20, 80, 80)];
    self.imageV.image = [UIImage imageNamed:@"myLogo"];
    self.imageV.layer.cornerRadius = AAdaption(40);
    self.imageV.layer.masksToBounds = YES;
    [self.view addSubview:self.imageV];

    
    self.guanZhuBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth/2-30, 155-50, 60, 30)];
    self.guanZhuBtn.backgroundColor = DefaultColor;
    self.guanZhuBtn.tintColor = [UIColor whiteColor];
    self.guanZhuBtn.layer.cornerRadius = AAdaption(3);
    [self.guanZhuBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    self.guanZhuBtn.tag = 10;
    self.guanZhuBtn.titleLabel.font = AAFont(12);
    [self.guanZhuBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.guanZhuBtn];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:AAdaptionRect(0, 155+30+10-50, KBaseWidth, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    
    self.dongtaiBtn = [[UIButton alloc]initWithFrame:AAdaptionRect((KBaseWidth/5)*2-50, 210-50, 50, 30)];
    //    self.dongtaiBtn.backgroundColor = [UIColor blueColor];
    [self.dongtaiBtn setTitle:@"最近" forState:UIControlStateNormal];
    [self.dongtaiBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.dongtaiBtn setTitleColor:[UIColor lightGrayColor]];
    self.dongtaiBtn.tag = 11;
    [self.dongtaiBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dongtaiBtn];
    
    self.fabiaoBtn = [[UIButton alloc]initWithFrame:AAdaptionRect((KBaseWidth/5)*3-50, 210-50, 50, 30)];
    //    self.fabiaoBtn.backgroundColor = [UIColor redColor];
//    [self.fabiaoBtn setTitleColor:[UIColor lightGrayColor]];
    [self.self.fabiaoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.fabiaoBtn.tag = 12;
    [self.fabiaoBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.fabiaoBtn setTitle:@"作品" forState:UIControlStateNormal];
    [self.view addSubview:self.fabiaoBtn];
    
    self.shoucangBtn = [[UIButton alloc]initWithFrame:AAdaptionRect((KBaseWidth/5)*4-50, 210-50, 50, 30)];
    //    self.shoucangBtn.backgroundColor = [UIColor blueColor];
//    [self.shoucangBtn setTitleColor:[UIColor lightGrayColor]];
    [self.self.shoucangBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.shoucangBtn.tag = 13;
    [self.shoucangBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.shoucangBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.view addSubview:self.shoucangBtn];
    
    self.moveView = [[UIView alloc]initWithFrame:AAdaptionRect((KBaseWidth/5)*2-50, 247-50, 50, 3)];
    self.moveView.backgroundColor = DefaultColor;
    [self.view addSubview:self.moveView];
    [self.view addSubview:self.myTableView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:AAdaptionRect(0, 250-50, KBaseWidth, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    
}

-(void)click:(UIButton*)btn{
    switch (btn.tag) {
        case 10:
        {
            NSLog(@"10");
            NSLog(@"修改密码");
            UpdatePWDViewController *uVc = [[UpdatePWDViewController alloc]init];
            [self.navigationController pushViewController:uVc animated:NO];
            break;
        }
        case 11:
        {
            NSLog(@"最近");
            [self addMoveView:AAdaptionRect((KBaseWidth/5)*2-50, 247-50, 50, 3)];
            [self.view addSubview:self.myTableView];

            AVUser *user = [AVUser currentUser];
            NSString *name = [user objectForKey:@"username"];
            AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
            [query orderByDescending:@"updatedAt"];
            [query whereKey:@"auther" equalTo:name];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                self.dataArray = [[NSArray alloc]initWithArray:objects];
                [self.myTableView reloadData];
                NSLog(@"-------%lu-------",(unsigned long)self.dataArray.count);
            }];

            break;
        }
        case 12:
        {
            NSLog(@"我的作品");
            [self addMoveView:AAdaptionRect((KBaseWidth/5)*3-50, 247-50, 50, 3)];
            [self.view addSubview:self.myTableView];
            AVUser *user = [AVUser currentUser];
            NSString *name = [user objectForKey:@"username"];
            AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
            [query whereKey:@"auther" equalTo:name];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                self.dataArray = [[NSArray alloc]initWithArray:objects];
                [self.myTableView reloadData];
                NSLog(@"-------%lu-------",(unsigned long)self.dataArray.count);
            }];
            break;
        }
        case 13:
        {
            NSLog(@"我的收藏");
            [self addMoveView:AAdaptionRect((KBaseWidth/5)*4-50, 247-50, 50, 3)];
            [self.view addSubview:self.myTableView];
            
            AVUser *user = [AVUser currentUser];
            NSString *name = [user objectForKey:@"username"];
            
            AVQuery *qu = [AVQuery queryWithClassName:@"AllUser"];
            [qu whereKey:@"userName" equalTo:name];
            AVObject *bj = [qu getFirstObject];
            self.headPicStr = [bj objectForKey:@"picUrl"];
            
            AVQuery *query = [AVQuery queryWithClassName:@"Collection"];
            [query whereKey:@"user" equalTo:name];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                self.collectionIDArray = [[NSArray alloc]initWithArray:objects];
                NSLog(@"-------%lu-------",(unsigned long)self.collectionIDArray.count);
                
                NSMutableArray *arry = [NSMutableArray array];
                
                for (int i=0; i<self.collectionIDArray.count; i++) {
                    AVObject * obj = self.collectionIDArray[i];
                    NSString *workId = [obj objectForKey:@"workId"];
                    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
                    [query whereKey:@"objectId" equalTo:workId];
                    
                    AVObject *work = [query getFirstObject];
                    NSLog(@"---%@---",[work objectForKey:@"auther"]);
                    [arry addObject:work];
                }
                self.dataArray = [arry mutableCopy];
                [self.myTableView reloadData];
            }];
            break;
        }
        default:
            break;
    }
}

-(void)addMoveView:(CGRect)cgrect{
    [self.moveView removeFromSuperview];
    self.moveView = [[UIView alloc]initWithFrame:cgrect];
    self.moveView.backgroundColor = DefaultColor;
    [self.view addSubview:self.moveView];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:AAdaptionRect(0, 255-50, KBaseWidth, KBaseHeight-255+50) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.separatorColor = [UIColor clearColor];
    }
    return _myTableView;
}

#pragma mark - delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"tableIdentifier";
    PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[PersonalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    AVObject *obj = self.dataArray[indexPath.row];
    cell.objct = obj;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AAdaptionY(100);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WorkDetailViewController *wDVC = [[WorkDetailViewController alloc]init];
    wDVC.objc = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:wDVC animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath;
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
