//
//  AppDelegate.m
//  LeShare
//
//  Created by 吴雪琴 on 2017/3/18.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "AppDelegate.h"
#import "HeaderKit.h"
#import <AVOSCloud/AVOSCloud.h>
#import "GuideViewController.h"
#import "LeTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化sdk
    [AVOSCloud setApplicationId:@"yLA0dWUUgdtb3uVCQWpFI1NT-gzGzoHsz" clientKey:@"gAv1ioCNLTSGU94OK3xRDcG9"];
    
    UIWindow *window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window = window;//存入appDelegate
    _window.backgroundColor = [UIColor whiteColor];
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isfirst"]) {
        _window.rootViewController = [[LoginViewController alloc]init];
//_window.rootViewController = [[LeTabBarViewController alloc]init];
    }else{
        _window.rootViewController = [[GuideViewController alloc]init];;
    }
    [_window makeKeyAndVisible];//授权
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
