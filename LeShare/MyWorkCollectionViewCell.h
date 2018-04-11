//
//  MyWorkCollectionViewCell.h
//  LeShare
//
//  Created by 吴雪琴 on 2017/4/2.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVObject;

@interface MyWorkCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)AVObject *work;

@property(strong,nonatomic)UIImageView *mgV;
@property(nonatomic,strong)UILabel *titlelabel;

@property(nonatomic,strong)UIButton *seenBtn;//被浏览
@property(nonatomic,strong)UILabel *seenCountLabel;
@property(nonatomic,strong)UIButton *goodBtn;//赞
@property(nonatomic,strong)UILabel *goodCountLabel;

@end
