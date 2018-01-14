//
//  ScanBehaviourViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"

@interface ScanBehaviourViewController : UIViewController
{
    NSUserDefaults *userInfo;
    NSString *originSetting;
}

@property (weak, nonatomic) IBOutlet UIImageView *DefaultImage;
@property (weak, nonatomic) IBOutlet UIImageView *FastImage;

- (IBAction)OnDefaultClicked:(id)sender;
- (IBAction)OnFastTrackClicked:(id)sender;
- (IBAction)OnBackClicked:(id)sender;

@end
