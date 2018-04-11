//
//  TypeTableViewCell.m
//  中华诗词文韵
//
//  Created by 吴雪琴 on 2017/4/2.
//  Copyright © 2017年 杨思思. All rights reserved.
//

#import "TypeTableViewCell.h"
#import "HeaderKit.h"

@implementation TypeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self loadContactViews];
    return self;
}

-(void)loadContactViews{
    self.typelabel = [[UILabel alloc]initWithFrame:AAdaptionRect(0, 3, 50, 30)];
    self.typelabel.font = AAFont(12);
    self.typelabel.textAlignment = NSTextAlignmentCenter;
    self.typelabel.backgroundColor = DefaultColor;
    self.typelabel.textColor = [UIColor whiteColor];
    [self addSubview:self.typelabel];
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    self.isSelectType = YES;
//    self.typeStr = self.typelabel.text;
//    // Configure the view for the selected state
//}


@end
