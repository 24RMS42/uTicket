//
//  SignupViewController.m
//  UTicket
//
//  Created by matata on 11/21/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [Functions configureButton:button];
    
    [Functions makeFloatingField:_EmailField placeholder:@"Your Email"];
    [Functions makeFloatingField:_PasswordField placeholder:@"Your Password"];
    _PasswordField.clearButtonMode = UITextFieldViewModeNever;
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

- (void)actionSignup{
    
    [SVProgressHUD showWithStatus:@"Registering..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"email":_EmailField.text,
                              @"password":_PasswordField.text,
                              @"mpassword":_PasswordField.text
                              };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, SIGNUP_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [Functions showAlert:@"" message:@"Thanks for signing up. Please verify your email address"];
        }else
            [Functions showAlert:@"" message:[responseObject valueForKey:@"msg"]];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (IBAction)OnSignupClicked:(id)sender {
    
    if ([self isValid])
    {
        [self actionSignup];
    }
}

- (IBAction)OnLoginClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:self];
}

- (IBAction)OnShowPwdClicked:(id)sender {
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
