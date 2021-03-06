//
//  MyCreateViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/4/2.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "MyCreateViewController.h"
#import "HeaderKit.h"
#import "MyWorkCollectionViewCell.h"
#import "WorkDetailViewController.h"

@interface MyCreateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIView *myview;
@property(nonatomic,strong)UICollectionView *myWorkCollectionView;
//@property (nonatomic, strong) NSMutableArray *works;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation MyCreateViewController

//- (NSMutableArray *)works{
//    if (!_works) {
//        _works = [NSMutableArray array];
//    }
//    return _works;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = @"我的作品";
    self.view.backgroundColor = [UIColor yellowColor];
    /////////////////////////////////////////////////////////////////////////////
    [self getData];
    
    [self addMyView];
}

-(void)addMyView{
    self.myview = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth, KBaseHeight-64)];
    self.myview.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.myview];
    [self addCollectionView];
}

-(void)getData{
    AVUser *user = [AVUser currentUser];
    NSString *name = [user objectForKey:@"username"];
    AVQuery *query = [AVQuery queryWithClassName:@"ShareWork"];
    [query whereKey:@"auther" equalTo:name];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.dataArray = [[NSArray alloc]initWithArray:objects];
        [self.myWorkCollectionView reloadData];
        NSLog(@"-------%lu-------",(unsigned long)self.dataArray.count);
    }];
    
}

-(void)addCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.myWorkCollectionView = [[UICollectionView alloc] initWithFrame:AAdaptionRect(0, 0, 375, 667) collectionViewLayout:flowLayout];
    [self.myWorkCollectionView registerClass:[MyWorkCollectionViewCell class] forCellWithReuseIdentifier:@"AllProCollectionViewCell"];
    
    self.myWorkCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myWorkCollectionView];
    
    self.myWorkCollectionView.dataSource = self;
    self.myWorkCollectionView.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (2*(section+1)>self.dataArray.count) {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (self.dataArray.count+1)/2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllProCollectionViewCell" forIndexPath:indexPath];
    cell.work = self.dataArray[2*indexPath.section+indexPath.row];
    return cell;
}

//点击CELL
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择cell");
    WorkDetailViewController *workDetailVC = [[WorkDetailViewController alloc]init];
    workDetailVC.objc = self.dataArray[indexPath.row+2*indexPath.section];
    [self.navigationController pushViewController:workDetailVC animated:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((375 - 50) / 2, (375 - 80) / 2 + 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(15, 15, 0, 15);
    return UIEdgeInsetsMake(AAdaption(15), AAdaption(15), 0, AAdaption(15));
    //(上，左，下，右)
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
