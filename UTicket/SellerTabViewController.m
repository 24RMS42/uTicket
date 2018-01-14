//
//  SellerTabViewController.m
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "SellerTabViewController.h"

@interface SellerTabViewController ()

@property (nonatomic, assign) bool firstTime;
@property (nonatomic, strong) BATabBarController* vc;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end

@implementation SellerTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTime = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(goLogout:)
                                          name:NOTIFICATION_LOGOUT
                                          object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goSettings:)
                                                 name:NOTIFICATION_SETTINGS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goEventDashboard:)
                                                 name:NOTIFICATION_EVENT_DASHBOARD
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goEventTab:)
                                                 name:NOTIFICATION_VIEWEVENT
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    if(self.firstTime){
        
        BATabBarItem *tabBarItem, *tabBarItem2, *tabBarItem3;
        UIViewController *homeController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeseller"];
        UIViewController *eventController = [self.storyboard instantiateViewControllerWithIdentifier:@"event"];
        UIViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        
        NSMutableAttributedString *option1 = [[NSMutableAttributedString alloc] initWithString:@"Events"];
        [option1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000] range:NSMakeRange(0,option1.length)];
        tabBarItem = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"event"] selectedImage:[UIImage imageNamed:@"event_select"] title:option1];
        
        NSMutableAttributedString *option2 = [[NSMutableAttributedString alloc] initWithString:@"Home"];
        [option2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000] range:NSMakeRange(0,option2.length)];
        tabBarItem2 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"home_select"] title:option2];
        
        NSMutableAttributedString * option3 = [[NSMutableAttributedString alloc] initWithString:@"Profile"];
        [option3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000] range:NSMakeRange(0,option3.length)];
        tabBarItem3 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"profile"] selectedImage:[UIImage imageNamed:@"profile_select"] title:option3];
        
        self.vc = [[BATabBarController alloc] init];
        self.vc.tabBarBackgroundColor = [UIColor colorWithHex:COLOR_GRAY];
        self.vc.tabBarItemStrokeColor = [UIColor colorWithHex:COLOR_PRIMARY];
        self.vc.tabBarItemLineWidth = 1.5;
        
        //Hides the tab bar when true
        //        self.vc.hidesBottomBarWhenPushed = YES;
        //        self.vc.tabBar.hidden = YES;
        
        self.vc.viewControllers = @[homeController,eventController,profileController];
        self.vc.tabBarItems = @[tabBarItem2,tabBarItem,tabBarItem3];
        [self.vc setSelectedViewController:homeController animated:NO];
        
        self.vc.delegate = self;
        [self.view addSubview:self.vc.view];
        self.firstTime = NO;
    }
}

- (void)tabBarController:(BATabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)goLogout :(NSNotification *) notification{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:@"no" forKey:KEY_REMEMBER];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goSettings :(NSNotification *) notification{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goEventDashboard :(NSNotification *) notification{
    
    if ([[notification name] isEqualToString:NOTIFICATION_EVENT_DASHBOARD])
    {
        NSDictionary* info = notification.userInfo;
        NSString *eventID = [info valueForKey:@"eventID"];
        
        EventDashboardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"eventdashboard"];
        controller.eventID = eventID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)goEventTab :(NSNotification *) notification{
    [self.vc.tabBar selectedTabItem:1 animated:YES];
    [[self.vc.tabBarItems objectAtIndex:0] hideOutline];
}

@end
