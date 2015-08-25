//
//  AppDelegate.m
//  RadialMenu
//
//  Created by Erika Hoffman on 8/19/15.
//  Copyright (c) 2015 Erika Hoffman. All rights reserved.
//

#import "AppDelegate.h"
#import "RadialMenuController.h"
#import "ScreenViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    RadialMenuController *menuViewController = [[RadialMenuController alloc] init];
    self.window.rootViewController = menuViewController;

    // Create the screens used in the app and add them as children to the radial menu controller so
    // it can switch between them.
    ScreenViewController *homeScreen = [[ScreenViewController alloc] init];
    homeScreen.title = @"H";
    ScreenViewController *screen1 = [[ScreenViewController alloc] init];
    screen1.title = @"1";
    ScreenViewController *screen2 = [[ScreenViewController alloc] init];
    screen2.title = @"2";
    ScreenViewController *screen3 = [[ScreenViewController alloc] init];
    screen3.title = @"3";

    [menuViewController addChildViewController:homeScreen];
    [menuViewController addChildViewController:screen1];
    [menuViewController addChildViewController:screen2];
    [menuViewController addChildViewController:screen3];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
