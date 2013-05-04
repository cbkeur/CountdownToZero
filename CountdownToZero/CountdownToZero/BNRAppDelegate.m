//
//  BNRAppDelegate.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRAppDelegate.h"

// Controllers
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
    [[tbc tabBar] setSelectedImageTintColor:[UIColor colorWithRed:205/255.0 green:67/255.0 blue:22/255.0 alpha:1]];
    
    //UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //[flowLayout setItemSize: CGSizeMake(90.0f, 90.0f)];
    //BNRPhotoVC *photosVC = [[BNRPhotoVC alloc] initWithCollectionViewLayout: flowLayout];
    BNRPhotoVC *photosVC = [[BNRPhotoVC alloc] init];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:photosVC];
    [nc2.tabBarItem setTitle:@"Photos"];
    [nc2.tabBarItem setImage:[UIImage imageNamed:@"landscape"]];
    
    BNRHomeVC *homeVC = [[BNRHomeVC alloc] init];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [nc3.tabBarItem setTitle:@"Home"];
    [nc3.tabBarItem setImage:[UIImage imageNamed:@"head"]];
    
    BNRFactsVC *factsVC = [[BNRFactsVC alloc] init];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:factsVC];
    [nc4.tabBarItem setTitle:@"Facts"];
    [nc4.tabBarItem setImage:[UIImage imageNamed:@"notepad"]];
    
    BNRAboutVC *aboutVC = [[BNRAboutVC alloc] init];
    UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [nc5.tabBarItem setTitle:@"About"];
    [nc5.tabBarItem setImage:[UIImage imageNamed:@"idcard"]];
    
    [tbc setViewControllers:@[nc3, nc2, nc4, nc5]];
    
    [self.window setRootViewController:tbc];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
