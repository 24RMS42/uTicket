//
//  AboutViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *VersionLabel;
- (IBAction)OnBackClicked:(id)sender;
@end
