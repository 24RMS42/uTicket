//
//  SettingsViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "NIDropDown.h"
#import "AppDelegate.h"
#import "UserModel.h"

@interface SettingsViewController : UIViewController<NIDropDownDelegate>
{
    NSUserDefaults *userInfo;
}

@property (nonatomic, strong) NIDropDown *menuDrop;
@property (weak, nonatomic) IBOutlet UIView *UserMngView;
@property (weak, nonatomic) IBOutlet UIButton *UserMngButton;
@property (weak, nonatomic) IBOutlet UIButton *LogBackButton;


- (IBAction)OnBackClicked:(id)sender;
- (IBAction)OnScanBehaviourClicked:(id)sender;
- (IBAction)OnAboutClicked:(id)sender;
- (IBAction)OnHelpClicked:(id)sender;
- (IBAction)OnUserMngClicked:(id)sender;
- (IBAction)OnLogBackClicked:(id)sender;


@end
