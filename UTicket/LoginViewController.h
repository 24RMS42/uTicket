//
//  LoginViewController.h
//  UTicket
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "Functions.h"

@interface LoginViewController : UIViewController

@property (nonatomic, assign) BOOL passwordShown;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *PasswordField;
@property (weak, nonatomic) IBOutlet UISwitch *RememberSwitch;
@property (weak, nonatomic) IBOutlet UIButton *PwdToggleButton;

- (IBAction)OnLoginClicked:(id)sender;
- (IBAction)OnForgotClicked:(id)sender;
- (IBAction)OnSignupClicked:(id)sender;
- (IBAction)OnPwdShowClicked:(id)sender;
- (IBAction)OnQuestionClicked:(id)sender;

@end
