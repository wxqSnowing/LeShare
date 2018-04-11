//
//  MCCollectionViewCell.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/4/2.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "MCCollectionViewCell.h"
#import "HeaderKit.h"

@implementation MCCollectionViewCell

-(void)setWork:(AVObject *)work{
    _work = work;
    if (_work) {
        NSURL *midUrl = [NSURL URLWithString:[work objectForKey:@"picUrl"]];
        [self.mgV sd_setImageWithURL:midUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        self.titlelabel.text = [NSString stringWithFormat:@"《%@》",[work objectForKey:@"tittle"] ];
        
        self.typeLabel.text = [work objectForKey:@"type"];
        
        NSString *name = [work objectForKey:@"auther"];
        AVQuery *query = [AVQuery queryWithClassName:@"AllUser"];
        [query whereKey:@"userName" equalTo:name];
        AVObject *result = [query getFirstObject];
        NSString *headStr = [result objectForKey:@"headUrl"];
//        NSString *headStr = @"http://ac-yla0dwuu.clouddn.com/8649d42cfc5e71089d10.jpg";
        NSLog(@"--------!!!%@!!!!---------",headStr);
        NSURL *headUrl = [NSURL URLWithString:headStr];
        [self.headImV sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mgV = [[UIImageView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth/2-25, 150)];
//        self.mgV.backgroundColor = [UIColor blueColor];
        self.mgV.image = [UIImage imageNamed:@"test2.jpg"];
        self.mgV.layer.cornerRadius = AAdaption(10);
        self.mgV.layer.masksToBounds = YES;
        [self addSubview:self.mgV];
        
        self.headImV = [[UIImageView alloc]initWithFrame:AAdaptionRect(5, 150+5+2+15+5, 30, 30)];
        self.headImV.backgroundColor = [UIColor redColor];
//        self.headImV.image = [UIImage imageNamed:@"headIMV.jpg"];
        self.headImV.layer.cornerRadius = AAdaption(15);
        self.headImV.layer.masksToBounds = YES;
        [self addSubview:self.headImV];
        
        self.titlelabel = [[UILabel alloc]initWithFrame:AAdaptionRect(0, 150, KBaseWidth/2-25, 30)];
//        self.titlelabel.backgroundColor = [UIColor greenColor];
        self.titlelabel.text = @"那年夏天风";
        self.titlelabel.font = AAFont(15);
        self.titlelabel.textColor = DefaultColor;
        [self addSubview:self.titlelabel];
        
        
        UIImageView *v = [[UIImageView alloc]initWithFrame:AAdaptionRect(50,180+5, 30, 30)];
        v.image = [UIImage imageNamed:@"type.png"];
        [self addSubview:v];
        
        self.typeLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(50+20+KBaseWidth/2-25-80-45, 180+5, KBaseWidth/2-25-30-80, 20)];
//        self.typeLabel.backgroundColor = [UIColor blueColor];
        self.typeLabel.text = @"二次元";
        self.typeLabel.layer.borderWidth = AAdaption(1);
        self.typeLabel.layer.borderColor = DefaultColor.CGColor;
        self.typeLabel.layer.cornerRadius = AAdaption(2);
        self.typeLabel.backgroundColor = DefaultColor;
        self.typeLabel.font = AAFont(10);
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.typeLabel];
        
//        self.goShareBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(50+20+KBaseWidth/2-25-30-80, 180, 30, 30)];
//        [self.goShareBtn setImage:[UIImage imageNamed:@"goshare.png"] forState:UIControlStateNormal];
//        [self addSubview:self.goShareBtn];
//        
////                self.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

@end
