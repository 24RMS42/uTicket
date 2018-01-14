//
//  HomeSellerViewController.m
//  UTicket
//
//  Created by matata on 11/23/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "HomeSellerViewController.h"

@interface HomeSellerViewController ()

@end

@implementation HomeSellerViewController

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
    
    UIViewController *mysalesController = [self.storyboard instantiateViewControllerWithIdentifier:@"mysales"];
    mysalesController.title = @"My Sales";
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.title = @"My Orders";
    [controllerArray addObject:mysalesController];
    [controllerArray addObject:vc1];
    
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

- (IBAction)OnSettingsClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SETTINGS object:self];
}
@end
