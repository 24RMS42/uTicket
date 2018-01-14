//
//  AppDelegate.m
//  UTicket
//
//  Created by matata on 11/20/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "AppDelegate.h"

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
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = url.absoluteString;
    // url is supposed like uticket://success=0
    if (urlStr.length > 18) {
        NSString *result = [urlStr substringWithRange:NSMakeRange(18, 1)];
        
        if ([result isEqualToString:@"1"]) {
            [userInfo setObject:result forKey:KEY_STRIPE_CON];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STRIPE object:self];
        }
        else
            [userInfo setObject:@"0" forKey:KEY_STRIPE_CON];
    }
    
    return YES;
}

@end
