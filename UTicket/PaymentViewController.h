//
//  PaymentViewController.h
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "Functions.h"
#import "SSBouncyButton.h"

@interface PaymentViewController : UIViewController<NIDropDownDelegate> {
    NSUserDefaults *userInfo;
}

@property (nonatomic, strong) NIDropDown *menuDrop;
@property (weak, nonatomic) IBOutlet UIButton *SelectButton;
@property (weak, nonatomic) IBOutlet UIView *BankView;
@property (weak, nonatomic) IBOutlet UIView *ConStripeView;
@property (weak, nonatomic) IBOutlet UIView *DisStripeView;
@property (weak, nonatomic) IBOutlet UITextField *IBANLabel;
@property (weak, nonatomic) IBOutlet UITextField *BICLabel;
@property (weak, nonatomic) IBOutlet SSBouncyButton *DisconnectButton;

- (IBAction)OnSelectClicked:(id)sender;
- (IBAction)OnConStripeClicked:(id)sender;
- (IBAction)OnUpdateProfileClicked:(id)sender;
- (IBAction)OnDisconnectClicked:(id)sender;

@end
