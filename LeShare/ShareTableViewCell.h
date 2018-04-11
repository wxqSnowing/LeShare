//
//  ShareTableViewCell.h
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/18.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVObject;
@interface ShareTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIImageView *middleImageV;
//@property(nonatomic,strong)UILabel *descibLabel;
@property(nonatomic,strong)UITextView *desTextView;
@property(nonatomic,strong)UIImageView *autherImageV;
@property(nonatomic,strong)UILabel *auther;

@property(nonatomic,strong)UIButton *seenBtn;//被浏览
@property(nonatomic,strong)UILabel *seenCountLabel;
@property(nonatomic,strong)UIButton *goodBtn;//赞
@property(nonatomic,strong)UILabel *goodCountLabel;


@property(nonatomic,strong)AVObject *work;

@end
