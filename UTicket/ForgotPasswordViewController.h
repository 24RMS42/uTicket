//
//  ForgotPasswordViewController.h
//  UTicket
//
//  Created by matata on 11/22/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "Functions.h"

@interface ForgotPasswordViewController : UIViewController<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet UIView *ConfirmView;

- (IBAction)OnClickSendEmail:(id)sender;
- (IBAction)OnClickBack:(id)sender;
- (IBAction)OnClickReturnLogin:(id)sender;

@end
