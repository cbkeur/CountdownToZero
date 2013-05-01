//
//  BNRAppDelegate.m
//  CountdownToZero
//
//  Created by Christian Keur on 5/1/13.
//  Copyright (c) 2013 Christian Keur. All rights reserved.
//

#import "BNRAppDelegate.h"

#import "BNRHomeVC.h"

@implementation BNRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    BNRHomeVC *homeVC = [[BNRHomeVC alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [tbc setViewControllers:@[nc]];
    
    [self.window setRootViewController:tbc];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
