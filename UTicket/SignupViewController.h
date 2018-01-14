//
//  SignupViewController.h
//  UTicket
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "Functions.h"

@interface SignupViewController : UIViewController

@property (nonatomic, assign) BOOL passwordShown;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *PasswordField;
@property (weak, nonatomic) IBOutlet UIButton *PwdToggleButton;

- (IBAction)OnSignupClicked:(id)sender;
- (IBAction)OnLoginClicked:(id)sender;
- (IBAction)OnShowPwdClicked:(id)sender;
- (IBAction)OnQuestionClicked:(id)sender;

@end
