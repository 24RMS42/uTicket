//
//  EventViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "CAPSPageMenu.h"
#import "UIColor+ColorWithHex.h"

@interface EventViewController : UIViewController

@property (nonatomic) CAPSPageMenu *pagemenu;
@property (weak, nonatomic) IBOutlet UIView *TopView;

@end
