//
//  AppDelegate.m
//  UTicket
//
//  Created by matata on 11/20/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "AppDelegate.h"
@import HockeySDK;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _GEventArray = [[NSMutableArray alloc]init];
    _UserArray = [[NSMutableArray alloc]init];
    _UserEmailArray = [[NSMutableArray alloc]init];
    
//    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
//    if ([[userInfo objectForKey:KEY_REMEMBER] isEqualToString:@"yes"]) {
//        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"sellertab"];
//    }
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"7349f5cb8d6848b5951048b59f6d03bb"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
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

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSString *urlStr = url.absoluteString;
    // url is supposed like uticket://scope=aaaa&code=bbbb (or error=cccc)
    if ([urlStr rangeOfString:@"code"].location == NSNotFound) {
        NSArray *items = [urlStr componentsSeparatedByString:@"error="];
        [Functions showAlert:@"" message:items[1]];
    } else {
        NSArray *items = [urlStr componentsSeparatedByString:@"://"];
        NSDictionary* notificationInfo = @{@"code": items[1]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STRIPE object:self userInfo:notificationInfo];
    }
    
    return YES;
}

@end
