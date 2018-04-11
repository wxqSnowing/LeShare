//
//  HeaderKit.h
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/15.
//  Copyright © 2017年 wxq. All rights reserved.
//

#ifndef HeaderKit_h
#define HeaderKit_h

// 颜色
#define COLOR(r, g, b, al) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:al]
#define DefaultColor COLOR(255, 193, 193, 1)

// 尺寸
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
#define W_SCREEN [UIScreen mainScreen].bounds.size.width
#define H_SCREEN [UIScreen mainScreen].bounds.size.height
#define KBaseWidth 375
#define KBaseHeight 667

//状态栏的高度
#define StatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏的高度
#define NavHeight self.navigationController.navigationBar.frame.size.height

// 第三方
#import <AVOSCloud/AVOSCloud.h>

#import <SDWebImage/SDImageCache.h>
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <AFNetworking/UIImage+AFNetworking.h>
#import <SDCycleScrollView.h>
#import <FMDB.h>
#import <FSAudioStream.h>


#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "UpdatePWDViewController.h"
#import "LeTabBarViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
// 适配
#define Inline static inline

# define COUNTDOWN 30

Inline CGFloat AAdaptionWidth() {
    return W_SCREEN / KBaseWidth;
}

Inline CGFloat AAdaption(CGFloat x) {
    return x * AAdaptionWidth();
}

Inline CGRect AAdaptionRect(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    CGFloat newX = x * AAdaptionWidth();
    CGFloat newY = y * AAdaptionWidth();
    CGFloat newW = width * AAdaptionWidth();
    CGFloat newH = height * AAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}

Inline CGFloat AAdaptionY(CGFloat y){
    return y*(H_SCREEN/KBaseHeight);
}

Inline UIFont * AAFont(CGFloat font){
    return [UIFont systemFontOfSize:font * AAdaptionWidth()];
}



#endif /* HeaderKit_h */
