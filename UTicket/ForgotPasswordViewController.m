//
//  ForgotPasswordViewController.m
//  UTicket
//
//  Created by matata on 11/22/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [Functions configureButton:button];
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    _EmailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _EmailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Email"
                                                            attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _EmailField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _EmailField.floatingLabelTextColor = floatingLabelColor;
    _EmailField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
    
    return TRUE;
}

- (void)actionSendEmail{
    
    [SVProgressHUD showWithStatus:@"Sending..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"email":_EmailField.text};
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, FORGOTPWD_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [_ConfirmView setHidden:NO];
            [self viewSlideInFromRightToLeft:_ConfirmView];
        }else
            [Functions showAlert:@"" message:[responseObject valueForKey:@"msg"]];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

-(void)viewSlideInFromRightToLeft:(UIView *)views
{
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}

- (IBAction)OnClickSendEmail:(id)sender {
    
    if ([self isValid]) {
        [self actionSendEmail];
    }
}

- (IBAction)OnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnClickReturnLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
