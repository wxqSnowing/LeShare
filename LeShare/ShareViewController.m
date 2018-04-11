//
//  ShareViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/15.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "ShareViewController.h"
#import "HeaderKit.h"
#import "ShareTableViewCell.h"
#import "AddViewController.h"
#import "MyCreateViewController.h"
#import "WorkDetailViewController.h"
#import "MyCollectionViewController.h"

@interface ShareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *allShareTable;

@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation ShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    [self getData];
    [self.view addSubview:self.allShareTable];
}
-(void)click:(UIButton *)btn{
    switch (btn.tag) {
        case 100:
        {
            //添加
            AddViewController *adVC = [[AddViewController alloc]init];
            self.navigationController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:adVC animated:YES];
            break;
        }
        case 101:
        {
            //收藏
            MyCollectionViewController *adVC = [[MyCollectionViewController alloc]init];
            self.navigationController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:adVC animated:YES];
            break;
        }
        case 102:
        {
            //个人创作
            MyCreateViewController *adVC = [[MyCreateViewController alloc]init];
            self.navigationController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:adVC animated:YES];
            break;
        }
        default:
            break;
    }

}
-(void)getData{
    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.dataArray = [[NSArray alloc]initWithArray:objects];
        NSLog(@"#####%@",self.dataArray);
        [self.allShareTable reloadData];
    }];
}
-(void)addView{
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W_SCREEN, H_SCREEN/4)];
//    imgV.image = [UIImage imageNamed:@"bg.jpg"];
    imgV.backgroundColor = DefaultColor;
    [self.view addSubview:imgV];
    
    UIButton *headBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(6, 20*5-6, 70, 70)];
    headBtn.layer.cornerRadius = AAdaption(70)/2.0;
    headBtn.layer.masksToBounds = YES;
    [headBtn setImage:[UIImage imageNamed:@"head.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:headBtn];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth-35, 30, 32, 32)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    addBtn.tag = 100;
    [addBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    ////////////////
    UIButton *myCollectBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth-40, 120+7, 25, 25)];
    [myCollectBtn setBackgroundImage:[UIImage imageNamed:@"myCollect.png"] forState:UIControlStateNormal];
    myCollectBtn.tag = 101;
    [myCollectBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCollectBtn];
    UILabel *colLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(KBaseWidth-40, 120+20+7, 30, 18)];
//    colLabel.backgroundColor = [UIColor whiteColor];
    [colLabel setText:@"个人收藏"];
    [colLabel setFont:AAFont(7)];
    [colLabel setTextColor:[UIColor lightGrayColor]];
    [colLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:colLabel];
    /////////////
    UIButton *myShareBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth-80, 120+7, 25, 25)];
    [myShareBtn setBackgroundImage:[UIImage imageNamed:@"mywork"] forState:UIControlStateNormal];
    myShareBtn.tag = 102;
    [myShareBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myShareBtn];
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(KBaseWidth-83, 120+20+7, 30, 18)];
    [shareLabel setText:@"个人作品"];
    [shareLabel setFont:AAFont(7)];
    [shareLabel setTextColor:[UIColor lightGrayColor]];
//    shareLabel.backgroundColor = [UIColor yellowColor];
    [shareLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:shareLabel];

}
/////////////////////////////////////////////////////////////////////////////////////////////////
-(UITableView *)allShareTable{
    if (!_allShareTable) {
        _allShareTable = [[UITableView alloc]initWithFrame:AAdaptionRect(0, KBaseHeight/4, KBaseWidth, KBaseHeight-KBaseHeight/4-40) style:UITableViewStylePlain];
        _allShareTable.separatorColor = [UIColor clearColor];
        _allShareTable.delegate = self;
        _allShareTable.dataSource = self;
//        _allShareTable.backgroundColor = [UIColor purpleColor];
    }
    return _allShareTable;
}
//分区
- (NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}
//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier = @"tableIdentifier";
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[ShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    cell.work = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AAdaptionY(190);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
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
    //NSInteger row = [indexPath row];
    return indexPath;
}

-(void)viewWillAppear:(BOOL)animated{
    [self getData];
    [self.allShareTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self.allShareTable removeFromSuperview];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
