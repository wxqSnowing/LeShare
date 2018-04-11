//
//  MCCollectionViewCell.h
//  LeShare
//
//  Created by 吴雪琴 on 2017/4/2.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVObject;

@interface MCCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)AVObject *work;

@property(strong,nonatomic)UIImageView *mgV;
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIImageView *headImV;

@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UIButton *goShareBtn;

@end
