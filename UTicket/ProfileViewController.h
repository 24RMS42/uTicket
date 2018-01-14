//
//  ProfileViewController.h
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "CAPSPageMenu.h"
#import "UIColor+ColorWithHex.h"

@interface ProfileViewController : UIViewController

@property (nonatomic) CAPSPageMenu *pagemenu;

@property (weak, nonatomic) IBOutlet UIView *TopView;
- (IBAction)OnLogoutClicked:(id)sender;

@end
