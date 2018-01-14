//
//  EventViewController.m
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setForm];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewUpEvent:)
                                                 name:NOTIFICATION_UPEVENT
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setForm
{
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    UIViewController *upController = [self.storyboard instantiateViewControllerWithIdentifier:@"upevent"];
    upController.title = @"Upcoming events";
    UIViewController *pastController = [self.storyboard instantiateViewControllerWithIdentifier:@"pastevent"];
    pastController.title = @"Past events";
    [controllerArray addObject:upController];
    [controllerArray addObject:pastController];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithHex:COLOR_SECONDARY],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"Roboto-Regular" size:17],
                                 CAPSPageMenuOptionMenuHeight: @(PageMenuOptionMenuHeight),
                                 CAPSPageMenuOptionSelectionIndicatorHeight : @(PageMenuOptionSelectionIndicatorHeight),
                                 CAPSPageMenuOptionMenuItemWidth: @(SCREEN_WIDTH/2 - 25),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor]
                                 };
    
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, _TopView.frame.origin.y + _TopView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pagemenu.view];
}

- (void)viewUpEvent :(NSNotification *) notification{
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    
    if (currentIndex > 0) {
        [_pagemenu moveToPage:currentIndex - 1];
    }
}

@end
