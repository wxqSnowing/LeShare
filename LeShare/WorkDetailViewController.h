//
//  WorkDetailViewController.h
//  LeShare
//
//  Created by 吴雪琴 on 2017/5/1.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVObject;
@interface WorkDetailViewController : UIViewController
@property(nonatomic,strong)AVObject *objc;


@property(nonatomic,assign)BOOL haveMovie;
@property(nonatomic,assign)BOOL havcPic;
@property(nonatomic,assign)BOOL haveVoice;
@end
