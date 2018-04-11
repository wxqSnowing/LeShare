//
//  UpInfoViewController.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/12.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "UpInfoViewController.h"
#import "HeaderKit.h"

@interface UpInfoViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UITextField *nameTf;

@property(nonatomic,strong)UILabel *gendleLabel;
//@property(nonatomic,strong)UITextField *gendleTf;

@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UIImageView *headImv;
@property(nonatomic,strong)UITextField *picStrTf;
@property(nonatomic,strong)UIButton *borwerBtn;

@property(nonatomic,strong)UIButton *upBtn;

@property(nonatomic,strong)UIImage *selectImage;
@property(nonatomic,strong)NSString *picStr;

@property(nonatomic,strong)UILabel *qianmingLabel;
@property(nonatomic,strong)UITextField *qianmingTf;

@property(nonatomic,strong)NSString *urlStr;

@property(nonatomic,strong)NSString *genStr;
@property(nonatomic,strong)UIButton *aBtn;
@property(nonatomic,strong)UIButton *vBtn;

@end

@implementation UpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, AAdaptionY(-60)) forBarMetrics:UIBarMetricsDefault];// 设置返回键
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改navigationItem的tittle的颜色
    self.navigationItem.title = @"修改资料";
    [self addView];
}

-(void)chooseGendle:(UIButton *)btn{
    if (btn.tag == 101) {
        self.genStr = @"男";
        self.aBtn.backgroundColor = DefaultColor;
        self.vBtn.backgroundColor = [UIColor whiteColor];
        
    }else{
        self.genStr = @"女";
        self.vBtn.backgroundColor = DefaultColor;
        self.aBtn.backgroundColor = [UIColor whiteColor];
    }
}

-(void)addView{
    self.nameLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 30, 60, 30)];
//    self.nameLabel.backgroundColor = DefaultColor;
    self.nameLabel.text = @"昵称:";
    self.nameLabel.textColor = DefaultColor;
    [self.view addSubview:self.nameLabel];
    
    self.nameTf = [[UITextField alloc]initWithFrame:AAdaptionRect(60, 30, 240, 30)];
//    self.nameTf.backgroundColor = [UIColor lightGrayColor];
    self.nameTf.delegate = self;
    AVObject *obj = [AVUser currentUser];
    self.nameTf.text = [obj objectForKey:@"username"];
    [self.nameTf setUserInteractionEnabled:NO];
//    self.nameTf.layer.cornerRadius = AAdaption(2);
//    self.nameTf.layer.borderWidth = AAdaption(1);
//    self.nameTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.nameTf];
    
    
    self.gendleLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 60+20+10, 60, 30)];
//    self.gendleLabel.backgroundColor = [UIColor blueColor];
    self.gendleLabel.text = @"性别:";
    self.gendleLabel.textColor = DefaultColor;
    [self.view addSubview:self.gendleLabel];
    
    UILabel *aLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(70, 90, 30, 30)];
    aLabel.text = @"男";
    aLabel.font = AAFont(15);
    [self.view addSubview:aLabel];
    
    self.aBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(100, 90+5, 20, 20)];
//    self.aBtn.backgroundColor = [UIColor yellowColor];
    self.aBtn.tag = 101;
    self.aBtn.layer.cornerRadius = AAdaption(10);
    self.aBtn.layer.borderWidth = AAdaption(1);
    self.aBtn.layer.borderColor = DefaultColor.CGColor;
    [self.aBtn addTarget:self action:@selector(chooseGendle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.aBtn];
    
    UILabel *vLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(240, 90, 30, 30)];
    vLabel.text = @"女";
    vLabel.font = AAFont(15);
    [self.view addSubview:vLabel];
    
    self.vBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(270, 90+5, 20, 20)];
//    self.vBtn.backgroundColor = [UIColor redColor];
    self.vBtn.tag = 102;
    self.vBtn.layer.borderWidth = AAdaption(1);
    self.vBtn.layer.borderColor = DefaultColor.CGColor;
    [self.vBtn addTarget:self action:@selector(chooseGendle:) forControlEvents:UIControlEventTouchUpInside];
    self.vBtn.layer.cornerRadius = AAdaption(10);
    [self.view addSubview:self.vBtn];
    
    
    self.headLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 90+20+20+20, 60, 30)];
//    self.headLabel.backgroundColor = [UIColor yellowColor];
    self.headLabel.text = @"头像:";
    self.headLabel.textColor = DefaultColor;
    [self.view addSubview:self.headLabel];
    
    self.picStrTf = [[UITextField alloc]initWithFrame:AAdaptionRect(60, 90+20+20+20, 240, 30)];
//    self.picStrTf.backgroundColor = [UIColor greenColor];
    self.picStrTf.text = self.picStr;
    self.picStrTf.layer.cornerRadius = AAdaption(2);
    self.picStrTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.picStrTf.layer.borderWidth = AAdaption(1);
    self.picStrTf.font = AAFont(10);
    [self.view addSubview:self.picStrTf];
    
    self.borwerBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(315, 90+20+20+20, 40, 30)];
    self.borwerBtn.backgroundColor = DefaultColor;
    [self.borwerBtn setTitle:@"浏览" forState:UIControlStateNormal];
    self.borwerBtn.tag = 10;
    self.borwerBtn.layer.cornerRadius = AAdaption(2);
    [self.borwerBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.borwerBtn];
    
    self.qianmingLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 200+10, 60, 30)];
    self.qianmingLabel.textColor = DefaultColor;
//    self.qianmingLabel.backgroundColor = [UIColor greenColor];
    self.qianmingLabel.text = @"签名:";
    [self.view addSubview:self.qianmingLabel];
    
    
    self.qianmingTf = [[UITextField alloc]initWithFrame:AAdaptionRect(60, 200+10, 240, 30)];
    self.qianmingTf.layer.cornerRadius = AAdaption(2);
    self.qianmingTf.layer.borderWidth = AAdaption(1);
    self.qianmingTf.font = AAFont(10);
    self.qianmingTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.qianmingTf];
    
    
    self.upBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(KBaseWidth/2-80, 130+20+20+30+30+20+20+20, 160, 40)];
    self.upBtn.backgroundColor = DefaultColor;
    [self.upBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.upBtn.tag = 11;
    [self.upBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.upBtn.layer.cornerRadius = AAdaption(2);
    [self.view addSubview:self.upBtn];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderColor = DefaultColor.CGColor;

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)click:(UIButton *)btn{
    if (btn.tag == 10) {
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
        
        
    }else{
        //数据上传操作

        AVObject *user = [AVUser currentUser];
        NSString *name = [user objectForKey:@"username"];
        
        
        //修改AllUser表中的数据,修改_User表中的数据
        //先上传文件到_File表；
        //再往AllUser表中添加数据；
        AVQuery *query = [AVQuery queryWithClassName:@"AllUser"];
        [query whereKey:@"userName" equalTo:name];
        AVObject *resultObj = [query getFirstObject];
        NSString *objId = [resultObj objectForKey:@"objectId"];
        AVObject *todo = [AVObject objectWithClassName:@"AllUser" objectId:objId];
        
        dispatch_semaphore_t a = dispatch_semaphore_create(0);
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
                        self.urlStr = imageFile.url;
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
            dispatch_semaphore_wait(a, DISPATCH_TIME_FOREVER);
            
            if (self.genStr!=nil) {
                [todo setObject:self.genStr forKey:@"Gendle"];
                
            }
            if (self.picStrTf.text!=nil) {
                //先上传
                [todo setObject:self.urlStr forKey:@"headUrl"];
                
            }
            if (self.qianmingTf.text!=nil) {
                [todo setObject:self.qianmingTf.text forKey:@"qianMing"];
            }
            [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"ok");
                    UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
                    [chooseAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:chooseAlert animated:YES completion:nil];
                    
                }
            }];
            
            
            //男

        });
        

    }
    
   
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image=info[UIImagePickerControllerEditedImage];
        self.selectImage=image;//将图片放到视图上
        self.picStr = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSLog(@"--info----%@-----",[info objectForKey:UIImagePickerControllerReferenceURL]);
        self.picStrTf.text = [NSString stringWithFormat:@"%@",self.picStr];
//        self.picStrTf.text = @"123";
    }
    [picker dismissViewControllerAnimated:YES completion:nil];//通过控制器返回上一页
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
