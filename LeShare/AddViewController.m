//
//  AddViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/19.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "AddViewController.h"
#import "TypeTableViewCell.h"
#import "HeaderKit.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "ShareViewController.h"
static NSString *defaultUrlStr = @"";

@interface AddViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
    UIView *bottomView;
    UILabel *contentPlaceholderLabel;
//    NSTimer *_timer; //定时器
//    NSInteger countDown;  //倒计时
//    NSString *filePath;
}
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)UIView *myview;
@property(nonatomic,strong)UIView *shareView;
@property(nonatomic,strong)UITableView *typeTableView;
@property(nonatomic,strong)NSString *typeStr;

@property(nonatomic,strong)UIImage *selectImage;

@property(nonatomic,strong)NSData *movieData;

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址
@property(nonatomic,assign)BOOL isRecord;

@property(nonatomic,strong)NSMutableArray *dataArry;

@property(nonatomic,strong)UITextField *tittle;
@property(nonatomic,strong)UITextView *contentTextView;

@property(nonatomic,strong)NSString *picUrlStr;
@property(nonatomic,strong)NSString *voiceUrlStr;
@property(nonatomic,strong)NSString *movieUrlStr;

@property(nonatomic,strong)UIView *whenUpView;


@end

@implementation AddViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = @"添加分享";
    /////////////////////////////////////////////////////////////////////////////
    
    [self getType];
    [self addMyView];
    self.shareView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth, KBaseHeight-64-49)];
    self.shareView.userInteractionEnabled = YES;
    [self.view addSubview:self.shareView];
    [self addMiddleView];
    [self addBottomView];
    
    self.isRecord = NO;
}
#pragma - 添加视图
-(void)addMyView{
    self.myview = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, 375, 667-64)];
    self.myview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myview];
}
-(void)addMiddleView{
    self.tittle = [[UITextField alloc]initWithFrame:AAdaptionRect(5, 0, KBaseWidth-5, 30)];
    self.tittle.placeholder = @"添加标题";
    [self.shareView addSubview:self.tittle];
    
    UIView *lineView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 35, KBaseWidth, 0.5)];
    lineView.backgroundColor = DefaultColor;
    [self.shareView addSubview:lineView];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:AAdaptionRect(0, 40, KBaseWidth, KBaseHeight-64-49-40)];
    self.contentTextView.delegate = self;
    contentPlaceholderLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(5, 0, 200, 30)];
    contentPlaceholderLabel.enabled = NO;
    contentPlaceholderLabel.text = @"添加内容";
    contentPlaceholderLabel.font = AAFont(15);
    contentPlaceholderLabel.textColor = [UIColor lightGrayColor];
    [self.contentTextView addSubview:contentPlaceholderLabel];
    [self.shareView addSubview:self.contentTextView];
    
    self.whenUpView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth, KBaseHeight)];
    self.whenUpView.alpha = AAdaption(0.5);
//    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:AAdaptionRect(100, 200, 60, 60)];
//    myImageView.image = [UIImage imageNamed:@"上传中.png"];
//    [self.whenUpView addSubview:myImageView];
    UILabel *label = [[UILabel alloc]initWithFrame:AAdaptionRect(50, 200, 325, 40)];
    label.textColor = DefaultColor;
    label.text = @"上传中，请等待...";
    label.textAlignment = NSTextAlignmentCenter;
    [self.whenUpView addSubview:label];
    self.whenUpView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.whenUpView];

}
-(void)addBottomView{
    bottomView = [[UIView alloc]initWithFrame:AAdaptionRect(0, KBaseHeight-49, KBaseWidth, 49)];
//    bottomView.backgroundColor = [UIColor yellowColor];
    bottomView.layer.borderColor = DefaultColor.CGColor;
    bottomView.userInteractionEnabled = YES;
    
    bottomView.layer.borderWidth = AAdaption(0.3);
    [self.view addSubview:bottomView];
    //在bottomView上添加控件
    
    //添加图片按钮
    UIButton *addImageBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(2, 2, 65, 45)];
//    addImageBtn.backgroundColor = [UIColor blueColor];
    [addImageBtn setImage:[UIImage imageNamed:@"addImages.png"] forState:UIControlStateNormal];
    addImageBtn.tag = 10;
    [addImageBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addImageBtn];
    
    //添加声音按钮
    UIButton *addVoiceBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(75+5, 2, 65, 45)];
//    addVoiceBtn.backgroundColor = [UIColor redColor];
    [addVoiceBtn setImage:[UIImage imageNamed:@"addVoice.png"] forState:UIControlStateNormal];
    addVoiceBtn.tag = 11;
    [addVoiceBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addVoiceBtn];
    
    //添加视频按钮
    UIButton *addVideoBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(75*2+5, 2, 65, 45)];
//    addVideoBtn.backgroundColor = [UIColor yellowColor];
    [addVideoBtn setImage:[UIImage imageNamed:@"addVideo.png"] forState:UIControlStateNormal];
    addVideoBtn.tag = 12;
    [addVideoBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addVideoBtn];
    
    
    //添加标签按钮
    UIButton *typeBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(75*3+5, 2, 65, 45)];
//    typeBtn.backgroundColor = [UIColor blueColor];
    [typeBtn setImage:[UIImage imageNamed:@"addType.png"] forState:UIControlStateNormal];
    typeBtn.userInteractionEnabled = YES;
    typeBtn.tag = 13;
    [typeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:typeBtn];
    
    //提交按钮
    UIButton *addCommitBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(75*4+5, 2, 65, 45)];
    [addCommitBtn setImage:[UIImage imageNamed:@"addCommit.png"] forState:UIControlStateNormal];
//    addCommitBtn.backgroundColor = [UIColor redColor];
    addCommitBtn.tag = 14;
    [addCommitBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addCommitBtn];

}
#pragma - 发布上传处理
-(void)upAll{
    
    [self.view addSubview:self.whenUpView];
    
    AVObject *object = [[AVObject alloc]initWithClassName:@"ShareWork"];
    AVUser *user = [AVUser currentUser];
    [object setObject:[user objectForKey:@"username"] forKey:@"auther"];
    [object setObject:self.tittle.text forKey:@"tittle"];
    [object setObject:self.contentTextView.text forKey:@"content"];
    [object setObject:self.typeStr forKey:@"type"];
    
    dispatch_semaphore_t a = dispatch_semaphore_create(0);
    dispatch_semaphore_t b = dispatch_semaphore_create(0);
    dispatch_semaphore_t c = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"a开始");
        if (self.selectImage!=nil) {
            UIImage *image = self.selectImage;
            NSData *imageData;
            if (UIImagePNGRepresentation(image)) { // 如果是png格式
                imageData = UIImagePNGRepresentation(image);
            }else {
                imageData = UIImageJPEGRepresentation(image, 1.0);// 返回为JPEG图像。
            }
            AVFile *imageFile = [AVFile fileWithName:@"headImage.png" data:imageData];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    self.picUrlStr = imageFile.url;
                    [object setObject:self.picUrlStr forKey:@"picUrl"];
                    NSLog(@"a结束");
                    dispatch_semaphore_signal(a);
                }else {
                    NSLog(@"上传失败");
                }
            }progressBlock:^(NSInteger percentDone) {
                if ((long)percentDone==100){NSLog(@"图片上传完毕");}
            }];
        }else{
            NSLog(@"a结束");
            dispatch_semaphore_signal(a);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"b开始");
        if (self.movieData!=nil) {
            AVFile *file = [AVFile fileWithData:self.movieData];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"%@",file.url);
                    self.movieUrlStr = file.url;
                    [object setObject:self.movieUrlStr forKey:@"movieUrl"];
                    NSLog(@"b结束");
                    dispatch_semaphore_signal(b);
                }else {
                    NSLog(@"shangcshibai");
                }
            }progressBlock:^(NSInteger percentDone) {
                NSLog(@"movie!!!!----%ld---!!!!",(long)percentDone);
            }];
        }else{
            NSLog(@"b结束");
            dispatch_semaphore_signal(b);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"c开始");
        if (_filePath!=nil) {
            AVFile *file = [AVFile fileWithName:@"1.caf" contentsAtPath:_filePath];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                //
                if (succeeded) {
                    NSLog(@"%@",file.url);
                    self.voiceUrlStr = file.url;
                    [object setObject:self.voiceUrlStr forKey:@"voiceUrl"];
                    NSLog(@"c结束");
                    dispatch_semaphore_signal(c);
                    
                }else{
                }
            }progressBlock:^(NSInteger percentDone) {
                NSLog(@"voice!!!!----%ld---!!!!",(long)percentDone);
            }];
        }else{
            NSLog(@"c结束");
            dispatch_semaphore_signal(c);
        }
    });
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(a, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(b, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(c, DISPATCH_TIME_FOREVER);
        
        NSLog(@"d开始");
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                //shangchuanchengg
                NSLog(@"d结束");
                NSLog(@"提交成功");
                [self.whenUpView removeFromSuperview];
                UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发表成功！！" preferredStyle:UIAlertControllerStyleAlert];
                [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    ShareViewController *sVC = [[ShareViewController alloc]init];
                    [self.navigationController pushViewController:sVC animated:NO];
                    
                }]];
                [self presentViewController:chooseAlert animated:YES completion:nil];
            }else{
                NSLog(@"提交失败");
                
                UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交失败！！" preferredStyle:UIAlertControllerStyleAlert];
                [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:chooseAlert animated:YES completion:nil];
            }
        }];
        
    });
}

-(void)getType{
    AVQuery *query = [AVQuery queryWithClassName:@"LeShareType"];
    [query whereKey:@"flag" equalTo:@"1"];
    NSArray *arry = [query findObjects];
    self.dataArry = [NSMutableArray array];
    for (int i=0; i<arry.count; i++) {
        AVObject *obj = arry[i];
        //        NSLog(@"%@",[obj objectForKey:@"type"]);
        [self.dataArry addObject:[obj objectForKey:@"type"]];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image=info[UIImagePickerControllerEditedImage];
        self.selectImage=image;//将图片放到视图上
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType]isEqualToString:(NSString *)kUTTypeMovie]){
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.movieData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];//通过控制器返回上一页
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma - 底部按钮选择点击事件
-(void)click:(UIButton *)btn{
    switch (btn.tag) {
        case 10:
        {
            NSLog(@"addImages.png");
            //相机
            UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片来源" preferredStyle:UIAlertControllerStyleAlert];
            [chooseAlert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"相机");
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置为访问照相机
                picker.delegate=self;
                picker.allowsEditing=YES;
                picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
                [self presentViewController:picker animated:YES completion:nil];
            }]];
            //相册
            [chooseAlert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"相册");
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];//直接构造相册对象
                picker.delegate=self;
                picker.allowsEditing=YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                [self presentViewController:picker animated:YES completion:nil];
            }]];
            [self presentViewController:chooseAlert animated:YES completion:nil];
            break;
        }
        case 11:
        {
            [self addRecode];
            break;
        }
        case 12:
        {
            NSLog(@"addVideo.png");
            //摄像机
            UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择视频来源" preferredStyle:UIAlertControllerStyleAlert];
            [chooseAlert addAction:[UIAlertAction actionWithTitle:@"摄像机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"摄像机");
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置为访问照相机
                picker.delegate=self;
                picker.allowsEditing=YES;
                picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
                picker.videoQuality = UIImagePickerControllerQualityTypeLow;
                [self presentViewController:picker animated:YES completion:nil];
            }]];
            //本地视频
            [chooseAlert addAction:[UIAlertAction actionWithTitle:@"本地视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"本地视频");
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];//直接构造相册对象
                picker.delegate=self;
                picker.allowsEditing=YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                [self presentViewController:picker animated:YES completion:nil];
            }]];
            [self presentViewController:chooseAlert animated:YES completion:nil];
            break;
        }
        case 13:
            NSLog(@"addType.png");
            [self.shareView addSubview:self.typeTableView];
            [self.typeTableView setHidden:NO];
//            self.isSelectType = NO;
            break;
        case 14:
            NSLog(@"addCommit.png");
            //开始上传操作
            [self upAll];
            break;
        default:
            break;
    }
//    NSLog(@"请选择");
}

-(void)addRecode{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *outPutPath = [documentDirectory stringByAppendingPathComponent:@"recordOutput.caf"];
    NSURL *outPutURL = [NSURL fileURLWithPath:outPutPath];
    NSError *error = nil;
    // 初始化录音器
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outPutURL
                                                settings:[self getAudioSetting]
                                                   error:&error];
    if (error) {
        NSLog(@"failed to initialze recoder with error message '%@'.", [error localizedDescription]);
    }
    [_recorder prepareToRecord];
    [_recorder record];
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"录音" message:@"正在录音中" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * overAction = [UIAlertAction actionWithTitle:@"结束保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //开始播放
        // 停止录制
        [_recorder stop];
//        
//        // 播放录制的音频文件
//        NSError *error = nil;
//        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url
//                                                             error:&error];
//        if (error) {
//            NSLog(@"initialize audio player failed with error message '%@'.", [error localizedDescription]);
//        }
//        [_player prepareToPlay];
//        [_player play];
        
    }];
    
    [alertController addAction:action];
    [alertController addAction:overAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    _filePath =outPutPath;

}

-(NSDictionary *)getAudioSetting{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.view addSubview:bottomView];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:DefaultColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [bottomView removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [contentPlaceholderLabel setHidden:NO];
    }else{
        [contentPlaceholderLabel setHidden:YES];
    }
}

-(UITableView *)typeTableView{
    if (!_typeTableView) {
        _typeTableView = [[UITableView alloc]initWithFrame:AAdaptionRect(75*3+5+5+5, 667-64-160, 50, 120) style:UITableViewStylePlain];
        _typeTableView.separatorColor = [UIColor lightGrayColor];
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
        
    }
    return _typeTableView;
}

- (NSInteger)numberOfSectionInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier = @"tableIdentifier";
    TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[TypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    cell.typelabel.text = _dataArry[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AAdaptionY(30);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"选中行");
    TypeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.typeStr = cell.typelabel.text;
    [self.typeTableView setHidden:YES];
//    [self removeFromParentViewController];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.contentTextView resignFirstResponder];

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return indexPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
