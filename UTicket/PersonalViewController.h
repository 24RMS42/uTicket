//
//  PersonalViewController.h
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "Functions.h"

@interface PersonalViewController : UIViewController

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *FirstNameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *LastNameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *EmailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *PhoneField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *AddressField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *ZipcodeField;

- (IBAction)OnClickUpdateProfile:(id)sender;

@end
