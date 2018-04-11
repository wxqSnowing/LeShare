//
//  MyWorkCollectionViewCell.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/4/2.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "MyWorkCollectionViewCell.h"
#import "HeaderKit.h"

@implementation MyWorkCollectionViewCell

-(void)setWork:(AVObject *)work{
    _work = work;
    if (_work) {
        NSURL *headUrl = [NSURL URLWithString:[work objectForKey:@"picUrl"]];
        [self.mgV sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        self.titlelabel.text = [NSString stringWithFormat:@"《%@》",[work objectForKey:@"tittle"]];
        [NSString stringWithFormat:@"《%@》",[work objectForKey:@"tittle"]];
        self.seenCountLabel.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"seenNum"]];
        ;
        self.goodCountLabel.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"goodNum"]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mgV = [[UIImageView alloc]initWithFrame:AAdaptionRect(0, 0, KBaseWidth/2-25, 140)];
//        self.mgV.backgroundColor = [UIColor blueColor];
        self.mgV.image = [UIImage imageNamed:@"test1.jpg"];
        self.mgV.layer.cornerRadius = AAdaption(10);
        self.mgV.layer.masksToBounds = YES;
        [self addSubview:self.mgV];
        
        self.titlelabel = [[UILabel alloc]initWithFrame:AAdaptionRect(0, 140, KBaseWidth/2-25, 30)];
//        self.titlelabel.backgroundColor = [UIColor greenColor];
        self.titlelabel.text = @"春风吹又生";
        self.titlelabel.textColor = DefaultColor;
        [self addSubview:self.titlelabel];
        
        self.seenBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(5, 180, 15, 15)];
//        self.seenBtn.backgroundColor = [UIColor yellowColor];
        [self.seenBtn setImage:[UIImage imageNamed:@"see.png"] forState:UIControlStateNormal];
        [self addSubview:self.seenBtn];
        self.seenCountLabel = [[UILabel alloc]initWithFrame:AAdaptionRect((KBaseWidth/2-25)/2/2-13, 180, (KBaseWidth/2-25)/2/2-5, 15)];
//        self.seenCountLabel.backgroundColor = [UIColor purpleColor];
        self.seenCountLabel.text = @"123";
        [self.seenCountLabel setFont:AAFont(10)];
        self.seenCountLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.seenCountLabel];
        
        self.goodBtn = [[UIButton alloc]initWithFrame:AAdaptionRect((KBaseWidth/2-25)/2, 180, 15, 15)];
//        self.goodBtn.backgroundColor = [UIColor redColor];
        [self.goodBtn setImage:[UIImage imageNamed:@"good.png"] forState:UIControlStateNormal];
        [self addSubview:self.goodBtn];
        self.goodCountLabel = [[UILabel alloc]initWithFrame:AAdaptionRect((KBaseWidth/2-25)/2+(KBaseWidth/2-25)/2/2-15, 180, (KBaseWidth/2-25)/2/2-5, 15)];
//        self.goodCountLabel.backgroundColor = [UIColor yellowColor];
        self.goodCountLabel.text = @"100";
        [self.goodCountLabel setFont:AAFont(10)];
        self.goodCountLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.goodCountLabel];
        
//        self.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

@end
