//
//  SelectTypeViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/3.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "HeaderKit.h"
#import "WorkDetailViewController.h"
#import "SelectTypeTableViewCell.h"

@interface SelectTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation SelectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = self.selectType;
    [self getData];
    [self.view addSubview:self.myTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self getData];
    [self.myTableView reloadData];
}

#pragma - 根据上一个页面点击的话题类型按钮获取本页的数据信息
-(void)getData{
    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
    [query whereKey:@"type" equalTo:self.selectType];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.dataArray = [[NSArray alloc]initWithArray:objects];
        [self.myTableView reloadData];
    }];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth, KBaseHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.separatorColor = [UIColor clearColor];
    }
    return _myTableView;
}

#pragma mark - 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"tableIdentifier";
    SelectTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[SelectTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    AVObject * object = self.dataArray[indexPath.row];
    cell.objct = object;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AAdaptionY(100);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath;
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
