//
//  PaymentViewController.m
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "PaymentViewController.h"

#define option_bank   @"Bank transfer(1st working day after event)"
#define option_stripe @"Stripe (as tickets are sold)"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:3];
    [Functions configureButton:button];
    [Functions configureButton:button2];
    [Functions configureButton:button3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completStripeConnect:)
                                                 name:NOTIFICATION_STRIPE
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    userInfo = [NSUserDefaults standardUserDefaults];
    [_IBANLabel setText:[userInfo objectForKey:KEY_IBAN]];
    [_BICLabel setText:[userInfo objectForKey:KEY_BIC]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)changeStripeStatus
{
    if ([[userInfo objectForKey:KEY_STRIPE_CON] isEqualToString:@"1"]) {
        [_ConStripeView setHidden:YES];
        [_DisStripeView setHidden:NO];
    }
    else if ([[userInfo objectForKey:KEY_STRIPE_CON] isEqualToString:@"0"])
    {
        [_ConStripeView setHidden:NO];
        [_DisStripeView setHidden:YES];
    }
}

- (void)actionUpdateProfile{
    
    [SVProgressHUD showWithStatus:@"Updating profile..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"iban":_IBANLabel.text,
                                @"bic":_BICLabel.text
                                };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, PROFILE_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [userInfo setObject:_IBANLabel.text forKey:KEY_IBAN];
            [userInfo setObject:_BICLabel.text  forKey:KEY_BIC];
            
            [self tryLogin];
        }else
        {
            [SVProgressHUD dismiss];
            [Functions checkError:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)tryLogin{
    
    NSDictionary * parameters=@{@"email":[userInfo objectForKey:KEY_EMAIL],
                                @"password":[userInfo objectForKey:KEY_PASSWORD]
                                };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            
        }else
            [Functions checkError:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)connectStripeBegin{
    
    [SVProgressHUD showWithStatus:@"Connecting..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, STRIPE_BEGIN_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            NSString *goToUrl = [responseObject valueForKey:@"goto_url"];
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:goToUrl] /*options:@{} completionHandler:nil*/];
        }else
            [Functions checkError:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)completStripeConnect:(NSNotification *) notification {
    if ([notification.name isEqualToString:NOTIFICATION_STRIPE]) {
        NSDictionary *notificationInfo = notification.userInfo;
        NSString *code = notificationInfo[@"code"];
        
        [SVProgressHUD showWithStatus:@"Completing..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        NSString *url = [NSString stringWithFormat:@"%@%@?%@", BASE_URL, STRIPE_COMPLETE_API, code];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            int success = [[responseObject valueForKey:@"success"] intValue];
            
            if (success == 1) {
                [userInfo setObject:@"1" forKey:KEY_STRIPE_CON];
            } else {
                [userInfo setObject:@"0" forKey:KEY_STRIPE_CON];
                [Functions checkError:responseObject];
            }
            
            [self changeStripeStatus];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD dismiss];
            [Functions parseError:error];
        }];
    }
}

- (IBAction)OnSelectClicked:(id)sender {
    
    if(_menuDrop == nil) {
        CGFloat f = 80;
        NSArray *banks = [NSArray arrayWithObjects:option_bank, option_stripe, nil];
        _menuDrop = [[NIDropDown alloc]showDropDown:sender :&f :banks :nil :@"down"];
        _menuDrop.delegate = self;
     }
     else {
         [_menuDrop hideDropDown:sender];
         _menuDrop = nil;
     }
}

- (IBAction)OnConStripeClicked:(id)sender {
    [self connectStripeBegin];
}

- (IBAction)OnUpdateProfileClicked:(id)sender {
    [self actionUpdateProfile];
}

- (IBAction)OnDisconnectClicked:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Disconnecting..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, STRIPE_DISCONNECT];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        
        if (success == 1) {
            [userInfo setObject:@"0" forKey:KEY_STRIPE_CON];
            [self changeStripeStatus];
        } else
            [Functions checkError:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

#pragma mark - NIDropDelegates
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selectedIndex:(NSInteger)selectedIndex{
    _menuDrop = nil;
    
    if (selectedIndex == 0) {
        [_BankView setHidden:NO];
        [_ConStripeView setHidden:YES];
        [_DisStripeView setHidden:YES];
    }
    else
    {
        [_BankView setHidden:YES];
        [_ConStripeView setHidden:NO];
        
        [self changeStripeStatus];
    }
}

@end
