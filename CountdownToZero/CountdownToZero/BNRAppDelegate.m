//
//  BNRAppDelegate.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRAppDelegate.h"

// Controllers
#import "BNRInfoVC.h"
#import "BNRPhotoVC.h"
#import "BNRHomeVC.h"
#import "BNRFactsVC.h"
#import "BNRAboutVC.h"

@implementation BNRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //0, 79. 119
    
    UIColor *blueColor = [UIColor colorWithRed:0 green:79/255.0 blue:119/255.0 alpha:1];
    
    [[UINavigationBar appearance] setTintColor:blueColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"HoeflerText-Regular" size:24]}];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    [[tbc tabBar] setTintColor:blueColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize: CGSizeMake(90.0f, 90.0f)];
    BNRPhotoVC *photosVC = [[BNRPhotoVC alloc] initWithCollectionViewLayout: flowLayout];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:photosVC];
    [nc2.tabBarItem setTitle:@"Photos"];
    
    BNRHomeVC *homeVC = [[BNRHomeVC alloc] init];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [nc3.tabBarItem setTitle:@"Home"];
    
    BNRFactsVC *factsVC = [[BNRFactsVC alloc] init];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:factsVC];
    [nc4.tabBarItem setTitle:@"Facts"];
    
    BNRAboutVC *aboutVC = [[BNRAboutVC alloc] init];
    UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [nc5.tabBarItem setTitle:@"About"];
    
    [tbc setViewControllers:@[nc3, nc2, nc4, nc5]];
    
    [self.window setRootViewController:tbc];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
