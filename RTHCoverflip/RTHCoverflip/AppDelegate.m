//
//  AppDelegate.m
//  RTHCoverflip
//
//  Created by Ratsh on 24.11.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window                     = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor     = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController  = [MainViewController new];
    
    return YES;
}


@end
