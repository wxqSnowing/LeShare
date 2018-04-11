//
//  RecommendViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/15.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "RecommendViewController.h"
#import "HeaderKit.h"
#import "PersonalInfoTableViewCell.h"
#import "WorkDetailViewController.h"

@interface RecommendViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSArray *dataArray;

@end
@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"推荐";
    [self.view addSubview:self.myTableView];
    
    [self getData];
}

-(void)getData{
    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
    [query orderByDescending:@"seenNum"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.dataArray = [[NSArray alloc]initWithArray:objects];
        [self.myTableView reloadData];
    }];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth, KBaseHeight-64-40) style:UITableViewStylePlain];
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
    AVObject * object = self.dataArray[indexPath.row];
    cell.objct = object;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AAdaptionY(100);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //数据回传操作设置阅读数量+1
    
    
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

-(void)viewWillAppear:(BOOL)animated{
    [self getData];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
