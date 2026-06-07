//
//  TTGAppDelegate.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 12/11/2015.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//
//  App entry; main UI is built in code.

#import "TTGAppDelegate.h"
#import "Demos/TTGDemoListViewController.h"

@implementation TTGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    TTGDemoListViewController *rootViewController = [TTGDemoListViewController new];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
