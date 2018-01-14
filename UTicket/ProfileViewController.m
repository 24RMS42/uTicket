//
//  ProfileViewController.m
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setForm
{
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    UIViewController *personalController = [self.storyboard instantiateViewControllerWithIdentifier:@"personal"];
    personalController.title = @"Personal";
    UIViewController *paymentController = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
    paymentController.title = @"Payment";
    [controllerArray addObject:personalController];
    [controllerArray addObject:paymentController];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithHex:COLOR_SECONDARY],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"Roboto-Regular" size:PageMenuOptionMenuItemFont],
                                 CAPSPageMenuOptionMenuHeight: @(PageMenuOptionMenuHeight),
                                 CAPSPageMenuOptionSelectionIndicatorHeight : @(PageMenuOptionSelectionIndicatorHeight),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, _TopView.frame.origin.y + _TopView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pagemenu.view];
}

- (IBAction)OnLogoutClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:self];
}
@end
