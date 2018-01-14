//
//  LoginViewController.m
//  UTicket
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [Functions configureButton:button];
    
    [Functions makeFloatingField:_EmailField placeholder:@"Your Email"];
    [Functions makeFloatingField:_PasswordField placeholder:@"Your Password"];
    _PasswordField.clearButtonMode = UITextFieldViewModeNever;
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [_EmailField setText:[userInfo objectForKey:KEY_EMAIL]];
    [_PasswordField setText:[userInfo objectForKey:KEY_PASSWORD]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.PasswordField) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.EmailField) {
        [self.PasswordField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)isValid {
    
    NSString *_regex =@"\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _regex];
    
    if (_EmailField.text == nil || [_EmailField.text length] == 0 ||
        [[_EmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_EmailField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input email address"];
        return FALSE;
    }
    else if (![_predicate evaluateWithObject:_EmailField.text] == YES) {
        [_EmailField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input correct email address"];
        return FALSE;
    }
    else if (_PasswordField.text == nil || [_PasswordField.text length] == 0
        ||[[_PasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [_PasswordField becomeFirstResponder];
        [Functions showAlert:@"" message:@"Please input password"];
        return FALSE;
    }
                 
    return TRUE;
}

- (void)actionLogin{

    [SVProgressHUD showWithStatus:@"Logging in..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"email":_EmailField.text,
                              @"password":_PasswordField.text
                              };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_API];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [self getProfile];
        }else
        {
            [SVProgressHUD dismiss];
            [Functions showAlert:@"" message:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)getProfile{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, PROFILE_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            [userInfo setObject:[_RememberSwitch isOn] ? @"yes" : @"no" forKey:KEY_REMEMBER];
            [userInfo setObject:_PasswordField.text forKey:KEY_PASSWORD];
            
            id profileObject = [responseObject valueForKey:@"profile"];
            
            if (profileObject != [NSNull null]) {
                [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"name"]]    forKey:KEY_FIRSTNAME];
                [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"surname"]] forKey:KEY_LASTNAME];
                [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"email"]]   forKey:KEY_EMAIL];
                [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"phone"]]   forKey:KEY_PHONE];
                [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"address"]] forKey:KEY_ADDRESS];
                [userInfo setObject:[Functions checkNullValue:[profileObject valueForKey:@"eircode"]] forKey:KEY_EIRCODE];
                [userInfo setObject:[profileObject valueForKey:@"id"]      forKey:KEY_USERID];
                
                id accountObject = [profileObject valueForKey:@"account"];
                
                if (accountObject != [NSNull null]) {
                    [userInfo setObject:[Functions checkNullValue:[accountObject valueForKey:@"qr_scan_mode"]] forKey:KEY_QR_SCAN];
                    [userInfo setObject:[Functions checkNullValueWithZero:[accountObject valueForKey:@"use_stripe_connect"]] forKey:KEY_STRIPE_CON];
                    [userInfo setObject:[Functions checkNullValue:[accountObject valueForKey:@"iban"]]  forKey:KEY_IBAN];
                    [userInfo setObject:[Functions checkNullValue:[accountObject valueForKey:@"bic"]]   forKey:KEY_BIC];
                }
            }
            
            BOOL has_login_as = [[responseObject valueForKey:@"has_login_as"] boolValue];
            [userInfo setObject:has_login_as == YES ? @"1":@"0" forKey:KEY_SUPER_USER];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GO_HOME object:self];
        }else
            [Functions showAlert:@"" message:[responseObject valueForKey:@"msg"]];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (IBAction)OnLoginClicked:(id)sender {
    
    if ([self isValid]) {
        [self actionLogin];
    };
}

- (IBAction)OnForgotClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgotPwdNotification" object:self];
}

- (IBAction)OnSignupClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupNotification" object:self];
}

- (IBAction)OnPwdShowClicked:(id)sender {
    if (_passwordShown) {
        _passwordShown = NO;
        _PasswordField.secureTextEntry = YES;
        [_PwdToggleButton setTitle:@"Show" forState:UIControlStateNormal];
    }
    else
    {
        _passwordShown = YES;
        _PasswordField.secureTextEntry = NO;
        [_PwdToggleButton setTitle:@"Hide" forState:UIControlStateNormal];
    }
}

- (IBAction)OnQuestionClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_QUESTION object:self];
}
@end
