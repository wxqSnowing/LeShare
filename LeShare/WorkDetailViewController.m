//
//  WorkDetailViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/1.
//  Copyright © 2017年 wxq. All rights reserved.
//
#import "WorkDetailViewController.h"
#import "HeaderKit.h"

@interface WorkDetailViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;//显示内容添加到滑动视图中

@property(nonatomic,strong)UIView *myview;
//@property(nonatomic,strong)FSAudioStream *audioStream;
@property(nonatomic,strong)UIButton *voiceBtn;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *layer;

@property(nonatomic,strong)NSURL *picUrl;
@property(nonatomic,strong)NSURL *voiceUrl;
@property(nonatomic,strong)NSURL *movieUrl;
@property(nonatomic,strong)NSURL *headPicUrl;
@property(nonatomic,strong)NSString *auther;
@property(nonatomic,strong)NSString *tittle;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *content;

@property(nonatomic,strong)UIImageView *playerImV;
@property(nonatomic,strong)UIButton *playBtn;


@property(nonatomic,strong)NSString *collectObjectId;

@property(nonatomic,assign)BOOL isPlay;

@property(nonatomic,assign)BOOL isOn;   //录音开关
@property(nonatomic,assign)NSInteger isCollect;   //是否收藏-1,0,1

//@property (retain, nonatomic) AVAudioPlayer *player;
@property (retain, nonatomic) AVAudioPlayer *voicePlayer;

@property(nonatomic,strong)NSData *filedata;;
@end

@implementation WorkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = @"详情";
    self.isCollect = NO;
    [self initValue];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self initValue];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setHidden:NO];
    self.player = nil;
}

-(void)addMyView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:AAdaptionRect(0, 0, 375, 667-64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(0, 667*2);
    [self.view addSubview:self.scrollView];
    
    UIImageView *headIMV = [[UIImageView alloc]initWithFrame:AAdaptionRect(10, 10, 60, 60)];
    headIMV.layer.cornerRadius = AAdaption(30);
    headIMV.layer.masksToBounds = YES;
    [headIMV sd_setImageWithURL:self.headPicUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
    [self.scrollView addSubview:headIMV];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(80, 40, 100, 30)];
    nameLabel.text = self.auther;
    nameLabel.font = AAFont(15);
    [self.scrollView addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 80, 200, 20)];
    dateLabel.text = self.date;
    dateLabel.font = AAFont(10);
    [self.scrollView addSubview:dateLabel];
    
    UIButton *collectionBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(300, 50, 50, 50)];
    if (self.isCollect==1) {
        [collectionBtn setImage:[UIImage imageNamed:@"collecting.png"] forState:UIControlStateNormal];
    }else if (self.isCollect==-1){
        [collectionBtn setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    }else{
        collectionBtn.hidden = YES;
    
    }
    collectionBtn.tag = 50;
    [collectionBtn addTarget:self action:@selector(addCollectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:collectionBtn];
    
    self.myview = [[UIView alloc]initWithFrame:AAdaptionRect(5, 100, 365, 667)];
    UILabel *tittleLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(40, 0, 365-80, 40)];
    tittleLabel.text = self.tittle;
    tittleLabel.font = AAFont(30);
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    //    tittleLabel.backgroundColor = [UIColor greenColor];
    [self.myview addSubview:tittleLabel];
    
    if (self.haveVoice) {
        self.voiceBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(310, 12, 25, 25)];
        [self.voiceBtn setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
        self.voiceBtn.tag = 10;
        [self.voiceBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.myview addSubview:self.voiceBtn];
    }
//    self.haveMovie = NO;
    if (self.haveMovie) {
        [self player];
        [self.myview.layer addSublayer:self.layer];
//        [_player play];
        [_player pause];
        self.isPlay = NO;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 10;
    UIFont *font = AAFont(15);
    [attr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.content.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attr boundingRectWithSize:CGSizeMake(AAdaption(355), CGFLOAT_MAX) options:options context:nil];
    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    UITextView *contentView;
    if (self.haveMovie) {
        contentView = [[UITextView alloc]initWithFrame:CGRectMake(AAdaption(5), AAdaption(250),AAdaption(355) ,rect.size.height+AAdaptionY(30))];
    }else{
        contentView = [[UITextView alloc]initWithFrame:CGRectMake(AAdaption(5), AAdaption(37),AAdaption(355) ,rect.size.height+AAdaptionY(30))];
    }
    contentView.userInteractionEnabled = NO;
    contentView.font = font;
    contentView.text = self.content;
    [self.myview addSubview:contentView];
    
    if (self.havcPic) {
        UIImageView *middleView = [[UIImageView alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y+contentView.frame.size.height, AAdaption(355), AAdaption(355))];
        [middleView sd_setImageWithURL:self.picUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        [self.myview addSubview:middleView];
    }
    [self.scrollView addSubview:self.myview];
    
    
    if (self.haveMovie){
        self.playerImV = [[UIImageView alloc]init];
        self.playerImV.backgroundColor = [UIColor blackColor];
        self.playerImV.frame = CGRectMake(9, 142, 375-18,205);
        self.playerImV.alpha = 0.2;
        self.playBtn = [[UIButton alloc]initWithFrame:AAdaptionRect((355 - 60 )/ 2, (180 - 60) / 2 , 60, 60)];
        [self.playBtn setImage:[UIImage imageNamed:@"开始播放"] forState:UIControlStateNormal];
        self.playerImV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopVideo)];
        [self.playerImV addGestureRecognizer:tap];
        [self.scrollView addSubview:self.playerImV];
        [self.playBtn addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
        [self.playerImV addSubview:self.playBtn];
    }
 
}
- (void)stopVideo{
    if (self.isPlay) {
        [_player pause];
        self.isPlay = NO;
        self.playerImV.alpha = 0.2;
        [self.playBtn setHidden:NO];
    }
}

-(void)clickPlay{
    if (!self.isPlay) {
        [_player play];
        self.isPlay = YES;
        self.playerImV.alpha = 0.1;
        [self.playBtn setHidden:YES];
       
    }else{
        [_player pause];
        self.isPlay = NO;
        self.playerImV.alpha = 0.2;
        [self.playBtn setHidden:NO];
  
    }
    
}

-(void)initValue{
    NSString *name = [self.objc objectForKey:@"auther"];
    self.auther = name;

    AVQuery *userQuery = [AVQuery queryWithClassName:@"AllUser"];
    [userQuery whereKey:@"userName" equalTo:name];
    AVObject *result = [userQuery getFirstObject];
    NSString *headImgStr = [result objectForKey:@"headUrl"];
    self.headPicUrl = [NSURL URLWithString:headImgStr];
    
    self.date = [[NSString stringWithFormat:@"%@", [self.objc objectForKey:@"createdAt"]] substringToIndex:16];
    self.tittle = [self.objc objectForKey:@"tittle"];
    self.content = [self.objc objectForKey:@"content"];
    
    self.havcPic = NO;
    self.haveVoice = NO;
    self.haveMovie = NO;
    
    NSString *picStr = [self.objc objectForKey:@"picUrl"];//需要查询的作者
    if (picStr!=nil) {
        self.picUrl = [NSURL URLWithString:picStr];
        self.havcPic = YES;
    }
    NSString *voiceStr = [self.objc objectForKey:@"voiceUrl"];
    if (voiceStr!=nil) {
        self.voiceUrl = [NSURL URLWithString:voiceStr];
        self.haveVoice = YES;
    }
    NSString *movieStr = [self.objc objectForKey:@"movieUrl"];
    if (movieStr!=nil) {
        self.movieUrl = [NSURL URLWithString:movieStr];
        self.haveMovie = YES;
    }
    
    //该用户是否收藏该作品
    AVObject *currentUser = [AVUser currentUser];
    NSString *loginUser = [currentUser objectForKey:@"username"];
    
    AVQuery *autherQuery = [AVQuery queryWithClassName:@"Collection"];
    [autherQuery whereKey:@"user" equalTo:loginUser];
    AVQuery *workIdQuery = [AVQuery queryWithClassName:@"Collection"];
    NSString *workId = [self.objc objectForKey:@"objectId"];
    [workIdQuery whereKey:@"workId" equalTo:workId];
    NSArray *array = @[workId,loginUser];
    
    AVObject *currentUser1 = [AVUser currentUser];
    NSString *loginUser1 = [currentUser1 objectForKey:@"username"];

    if (![[self.objc objectForKey:@"auther"] isEqualToString:loginUser1])
    {
        //当前用户不是作品的作者
        NSLog(@"当前用户不是作品的作者");
        self.isCollect = -1 ;//初始化为没有收藏
        //查询是否收藏
        [AVQuery doCloudQueryInBackgroundWithCQL:@"select * from Collection where workId=? and user =?" pvalues:array callback:^(AVCloudQueryResult * _Nullable result, NSError * _Nullable error) {
            if (error == nil) {
                if(result.results.count > 0){
                    NSLog(@"+++++该用户收藏了该作品+++++++");
                    AVObject *obj = result.results[0];
                    self.collectObjectId = [obj objectForKey:@"objectId"];
                    NSLog(@"~~~~~~~%@~~~~~~~",self.collectObjectId);
                    self.isCollect = 1;
                }
            }else{
                NSLog(@"该用户没有收藏2，查询出错");
            }
            [self addMyView];
        }];

    }
    else
    {
        NSLog(@"当前用户是作品的作者");
        self.isCollect = 0;
        [self addMyView];
    }

}

-(void)addCollectionClick:(UIButton *)btn{

    if (btn.tag==50) {
        if (self.isCollect==1)
        {
            self.isCollect = -1;
            [btn setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
            //修改数据,删除
            NSLog(@"-----------收藏编号:%@-------------------",self.collectObjectId);
            NSArray *array = @[self.collectObjectId];
            [AVQuery doCloudQueryInBackgroundWithCQL:@"delete from Collection where objectId=?" pvalues:array callback:^(AVCloudQueryResult * _Nullable result, NSError * _Nullable error) {
                if(error == nil)
                {
                    NSLog(@"取消收藏成功");
                    self.isCollect = -1;
                }else
                {
                    NSLog(@"取消收藏失败");
                    self.isCollect = 1;
                }
            }];
        }
        else
        {
            self.isCollect = 1;
            [btn setImage:[UIImage imageNamed:@"collecting.png"] forState:UIControlStateNormal];
            //修改数据，添加
            AVObject *user = [AVUser currentUser];
            NSArray *array = @[[self.objc objectForKey:@"objectId"],[user objectForKey:@"username"]];
            [AVQuery doCloudQueryInBackgroundWithCQL:@"insert into Collection(workId,user) values(?,?)" pvalues:array callback:^(AVCloudQueryResult * _Nullable result, NSError * _Nullable error) {
                if(error==nil){
                    NSLog(@"添加收藏成功");
                    self.isCollect = 1;
                }else{
                    NSLog(@"添加收藏失败");
                    self.isCollect = -1;
                }
            }];
        }
    }
}

-(void)click:(UIButton *)btn{
    
    switch (btn.tag) {
        case 10:
        {
            if (!self.isOn) {
                
                
                NSLog(@"%@",self.voiceUrl);
              
                
                AVFile *file = [AVFile fileWithURL:[NSString stringWithFormat:@"%@", self.voiceUrl]];
                
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (error==nil) {
                        NSString *pathOfSearch = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        NSString *filePath = [NSString stringWithFormat:@"%@/currentPlayer", pathOfSearch];
                        
                        _filedata = data;
                         [data writeToFile:filePath atomically:YES];
                        NSError *error = nil;
                        
                        self.voicePlayer = [[AVAudioPlayer alloc]initWithData:_filedata error:&error];
                        
                        if (error) {
                            NSLog(@"initialize audio player failed with error message '%@'.", [error localizedDescription]);
                        }
                        
                        if (data) {
                            // 取出文件内容
                            NSData *data = [NSData dataWithContentsOfFile:filePath];
                            _voicePlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
                            _voicePlayer.delegate = self; // 代理
                            _voicePlayer.numberOfLoops = 1; // 循环次数 放一遍
                            [_voicePlayer prepareToPlay]; // 准备播放
                        
                            [_voicePlayer play];
                        self.isOn = YES;
                        }
                        
                        
                    }
                    NSLog(@"开始下载");
                    // data 就是文件的数据流
                    
                } progressBlock:^(NSInteger percentDone) {
                    NSLog(@"----%ld-----",(long)percentDone);
                    //下载的进度数据，percentDone 介于 0 和 100。
                    if (percentDone==100) {
                        
                        NSLog(@"下载完成");
                   

                    }
                }];
            

            }else{
                [_voicePlayer stop];
                self.isOn = NO;
            }
            break;
        }
        default:
            break;
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
}
-(AVPlayer *)player{
    if (_player == nil) {
        AVPlayerItem *itenm = [AVPlayerItem playerItemWithURL:self.movieUrl];
        _player = [AVPlayer playerWithPlayerItem:itenm];
        self.layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.layer.frame = AAdaptionRect(5, -30, 355, 350);
        self.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
       
    }
    return _player;
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
