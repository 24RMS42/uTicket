//
//  HomeSellerViewController.h
//  UTicket
//
//  Created by matata on 11/23/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "CAPSPageMenu.h"
#import "UIColor+ColorWithHex.h"

@interface HomeSellerViewController : UIViewController

@property (nonatomic) CAPSPageMenu *pagemenu;
@property (weak, nonatomic) IBOutlet UIView *TopView;

- (IBAction)OnSettingsClicked:(id)sender;
@end
