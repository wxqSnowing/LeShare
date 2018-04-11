//
//  ShareTableViewCell.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/18.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "HeaderKit.h"
@implementation ShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setWork:(AVObject *)work{
    _work = work;
    if (_work) {
        _titlelabel.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"tittle"]];
        
        NSString *urlStr = [work objectForKey:@"picUrl"];//解析结果
        NSURL *urlMiddle = [NSURL URLWithString:urlStr];
        [_middleImageV sd_setImageWithURL:urlMiddle placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        
        _desTextView.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"content"]];
        
        NSString *auther = [work objectForKey:@"auther"];//需要查询的作者
        
        AVQuery *queryWork = [AVQuery queryWithClassName:@"AllUser"];//在File表中查询
        [queryWork whereKey:@"userName" equalTo:auther];//查询
        AVObject *resultWork = [queryWork getFirstObject];//获取结果
        NSString *picHeadName = [resultWork objectForKey:@"headUrl"];//解析结果
        NSURL *headUrl = [NSURL URLWithString:picHeadName];
        [_autherImageV sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
        
        _auther.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"auther"]];
        
        _seenCountLabel.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"seenNum"]];
        
        _goodCountLabel.text = [NSString stringWithFormat:@"%@",[work objectForKey:@"goodNum"]];
//        NSDictionary
    }

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self loadContactViews];
    return self;
}

-(void)loadContactViews{
    
    self.middleImageV = [[UIImageView alloc]initWithFrame:AAdaptionRect(10, 10, 160, 160)];
    self.middleImageV.layer.cornerRadius = AAdaption(10);
    self.middleImageV.layer.masksToBounds = YES;
    self.middleImageV.image = [UIImage imageNamed:@"bg.jpg"];
    [self addSubview:self.middleImageV];
    
    self.titlelabel = [[UILabel alloc]initWithFrame:AAdaptionRect(225, 2, 375-222, 30)];
//        self.titlelabel.backgroundColor = [UIColor redColor];
    self.titlelabel.textAlignment = NSTextAlignmentLeft;
    self.titlelabel.text = @"沁园春～雪";
    self.titlelabel.textColor = DefaultColor;
    self.titlelabel.font = AAFont(15);
    [self addSubview:self.titlelabel];
    //
    
    self.desTextView = [[UITextView alloc]initWithFrame:AAdaptionRect(225, 35, 375-222, 80)];
//        self.desTextView.backgroundColor = [UIColor greenColor];
    self.desTextView.text = @"jsdbhsdgfsgfsdvfgsdvfgsdvfgsdfvsdgvfgsdfvdgsvfsgvgsdcgdfsdgvsdgvsgfvsdgfsvgsdgvsfvsfv";
    self.desTextView.font = AAFont(12);
    self.desTextView.userInteractionEnabled = NO;
    [self addSubview:self.desTextView];
    
    self.autherImageV = [[UIImageView alloc]initWithFrame:AAdaptionRect(225, 130, 35, 35)];
    self.autherImageV.backgroundColor = [UIColor yellowColor];
    self.autherImageV.image = [UIImage imageNamed:@"testHead.jpg"];
    self.autherImageV.layer.cornerRadius = AAdaption(35/2.0);
    self.autherImageV.layer.masksToBounds = YES;
    self.auther.font = AAFont(10);
    [self addSubview:self.autherImageV];
    
    self.auther = [[UILabel alloc]initWithFrame:AAdaptionRect(225, 165, 60, 15)];
    self.auther.textAlignment = NSTextAlignmentLeft;
//    self.auther.backgroundColor = [UIColor greenColor];
    self.auther.text = @"abc";
    self.auther.font = AAFont(10);
    [self addSubview:self.auther];
    
    self.seenBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(320, 145, 15, 15)];
//            self.seenBtn.backgroundColor = [UIColor grayColor];
    [self.seenBtn setImage:[UIImage imageNamed:@"see.png"] forState:UIControlStateNormal];
    [self addSubview:self.seenBtn];
    
    self.seenCountLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(320, 170, 310+25-225-20, 10)];
    self.seenCountLabel.text = @"11123次";
    self.seenCountLabel.textAlignment = NSTextAlignmentLeft;
//  self.seenCountLabel.backgroundColor = [UIColor blueColor];
    self.seenCountLabel.font = AAFont(10);
    self.seenCountLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.seenCountLabel];
    
    self.goodBtn = [[UIButton alloc]initWithFrame:AAdaptionRect(350, 140, 20, 20)];
//            self.goodBtn.backgroundColor = [UIColor purpleColor];
    [self.goodBtn setImage:[UIImage imageNamed:@"good.png"] forState:UIControlStateNormal];
    [self addSubview:self.goodBtn];
    
    self.goodCountLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(350, 170, 310+25-225-20, 10)];
    self.goodCountLabel.text = @"123";
    self.goodCountLabel.textAlignment = NSTextAlignmentLeft;
    self.goodCountLabel.font = AAFont(10);
    self.goodCountLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.goodCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:AAdaptionRect(0, 189, 375, 0.5)];
    lineView.backgroundColor = DefaultColor;
    [self addSubview:lineView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
