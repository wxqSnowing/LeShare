//
//  SelectTypeTableViewCell.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/3.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "SelectTypeTableViewCell.h"

#import "HeaderKit.h"

#import <SDWebImage/SDImageCache.h>
#import <AFNetworking.h>

@implementation SelectTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setObjct:(AVObject *)objct{
    _objct = objct;
    if (_objct) {
        NSString *picStr = [objct objectForKey:@"picUrl"];//需要查询的图片的名字
        NSURL *picUrl = [NSURL URLWithString:picStr];
        [_imageV sd_setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"test2.jpg"]];
    
        _dateLabel.text = [NSString stringWithFormat:@"%@",[objct objectForKey:@"createdAt"]];
        
        _tittleLabel.text = [NSString stringWithFormat:@"%@",[objct objectForKey:@"tittle"]];
        
        NSString *str = [NSString stringWithFormat:@"阅读%@ * 收藏%@ * 点赞%@", [NSString stringWithFormat:@"%@",[objct objectForKey:@"seenNum"]],[NSString stringWithFormat:@"%@",[objct objectForKey:@"collectedNum"]],[NSString stringWithFormat:@"%@",[objct objectForKey:@"goodNum"]]];
        _infoLabel.text = str;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addViews];
    }
    return self;
}

-(void)addViews{
    self.dateLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 18, 260, 15)];
    self.dateLabel.text = @"04.01 13:32";
    self.dateLabel.font = AAFont(12);
    self.dateLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.dateLabel];
    
    self.tittleLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 38, 260, 30)];
    self.tittleLabel.text = @"从4张牌让你看懂中美博弈";
    [self addSubview:self.tittleLabel];
    
    self.infoLabel = [[UILabel alloc]initWithFrame:AAdaptionRect(10, 70, 260, 20)];
    self.infoLabel.font = AAFont(12);
    self.infoLabel.textColor = [UIColor lightGrayColor];
    self.infoLabel.text = @"阅读1462 * 收藏11 * 点赞100";
    [self addSubview:self.infoLabel];
    
    self.imageV = [[UIImageView alloc]initWithFrame:AAdaptionRect(270, 10, 90, 90)];
    self.imageV.layer.cornerRadius = AAdaption(10);
    self.imageV.layer.masksToBounds = YES;
    self.imageV.image = [UIImage imageNamed:@"test2.jpg"];
    [self addSubview:self.imageV];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
