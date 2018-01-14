//
//  ViewController.h
//  UTicket
//
//  Created by matata on 11/20/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView/EAIntroView.h>
#import "macro.h"
#import "CAPSPageMenu.h"
#import "UIColor+ColorWithHex.h"

@interface ViewController : UIViewController

@property (nonatomic) CAPSPageMenu *pagemenu;
@property (weak, nonatomic) IBOutlet UIView *TopView;

- (IBAction)Test:(id)sender;

@end

