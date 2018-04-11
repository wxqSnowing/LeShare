//
//  MineViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/15.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "MineViewController.h"
#import "HeaderKit.h"
#import "WorkDetailViewController.h"
#import "MyCreateViewController.h"
#import "MyCollectionViewController.h"
#import "AboutViewController.h"
#import "MySelfViewController.h"
#import "UpInfoViewController.h"

@interface MineViewController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *myTableView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的资料";
    [self initUI];
}

-(void)click{
    //进入修改个人心的界面
    UpInfoViewController *uVC = [[UpInfoViewController alloc]init];
    [self.navigationController pushViewController:uVC animated:YES];
}

-(void)initUI{
    AVUser *currentUser = [AVUser currentUser];
    NSString *phone = [currentUser objectForKey:@"mobilePhoneNumber"];
    AVQuery *allUserQuery = [AVQuery queryWithClassName:@"AllUser"];
    [allUserQuery whereKey:@"phoneNumber" equalTo:phone];
    AVObject *aUser = [allUserQuery getFirstObject];
    NSString *name = [aUser objectForKey:@"userName"];
    NSURL *headUrl = [NSURL URLWithString:[aUser objectForKey:@"headUrl"]];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:AAdaptionRect(375/2-40, 5, 80, 80)];
    headImageView.backgroundColor = DefaultColor;
    headImageView.layer.cornerRadius = AAdaption(40);
    headImageView.layer.masksToBounds = YES;
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [headImageView addGestureRecognizer:singleTap];
    [headImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"head.jpg"]];
    [self.view addSubview:headImageView];
    
    UIImageView *gendleImageView = [[UIImageView alloc]initWithFrame:AAdaptionRect(375/2-40+28, 90+35, 20, 20)];
    NSString *gendle = [aUser objectForKey:@"Gendle"];
    if ([gendle isEqualToString:@"女"]) {
        gendleImageView.image = [UIImage imageNamed:@"female.png"];
    }else{
        gendleImageView.image = [UIImage imageNamed:@"male.png"];
    }
//    gendleImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:gendleImageView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(375/2-80, 95, 160, 30)];
//    nameLabel.backgroundColor = DefaultColor;
    nameLabel.text = name;
    nameLabel.font = AAFont(15);
    nameLabel.textColor = DefaultColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
 
    [self.view addSubview:self.myTableView];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:AAdaptionRect(0, 160, KBaseWidth, KBaseHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.scrollEnabled = NO;
        
        UIView *view = [[UIView alloc]initWithFrame:AAdaptionRect(0, 159, 375, 1)];
        view.backgroundColor = DefaultColor;
        [self.view addSubview:view];
        
    }
    return _myTableView;
}

#pragma mark - delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"tableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        UIView *view = [[UIView alloc]initWithFrame:AAdaptionRect(0, 59, 375, 1)];
        view.backgroundColor = DefaultColor;
        [cell addSubview:view];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"个人概览";
            break;
        case 1:
            cell.textLabel.text = @"我的发表";
            break;
        case 2:
            cell.textLabel.text = @"我的收藏";
            break;
        case 3:
            cell.textLabel.text = @"联系我们";
            break;
        case 4:
            cell.textLabel.text = @"退出";
            break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AAdaptionY(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"选中行，即将跳转");
    switch (indexPath.row) {
        case 0:
        {
            //个人信息页
            MySelfViewController *vc = [[MySelfViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
             break;
        }
        case 1:
        {
            //我的发表
            MyCreateViewController *mcVC = [[MyCreateViewController alloc]init];
            [self.navigationController pushViewController:mcVC animated:NO];
            break;
        }
        case 2:
        {
            //我的收藏
            MyCollectionViewController *mcVC = [[MyCollectionViewController alloc]init];
            [self.navigationController pushViewController:mcVC animated:NO];
            break;
        }
        case 3:
        {
            //关于我们
            AboutViewController *vc = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            break;
        }
        case 4:
        {
            //关于我们
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            break;
        }
        default:
            break;
    }

    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath;
}



-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    self.navigationController.hidesBottomBarWhenPushed = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    self.navigationController.hidesBottomBarWhenPushed = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
