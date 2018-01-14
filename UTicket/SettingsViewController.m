//
//  SettingsViewController.m
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = [NSUserDefaults standardUserDefaults];
    if ([[userInfo objectForKey:KEY_SUPER_USER] isEqualToString:@"1"]) {
        [_UserMngView setHidden:NO];
    } else
        [_UserMngView setHidden:YES];
    
    [self toggleUserMngView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleUserMngView {
    if (appDelegate.isLogAs) {
        [_UserMngButton setTitle:appDelegate.logAsUser forState:UIControlStateNormal];
        [_UserMngButton setEnabled:NO];
        [_LogBackButton setHidden:NO];
        [_LogBackButton setTitle:[NSString stringWithFormat:@"Login back as %@", appDelegate.logOriginUser] forState:UIControlStateNormal];
    } else {
        [_LogBackButton setHidden:YES];
        [_UserMngButton setTitle:@"User Management" forState:UIControlStateNormal];
        [_UserMngButton setEnabled:YES];
    }
}

- (void)actionLoginAs:(NSString*)userId {
    
    [SVProgressHUD showWithStatus:@"Logging in..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"user_id":userId};
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, USER_LOGINAS];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [self getProfile];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINAS object:self];
            
            appDelegate.isLogAs = YES;
            appDelegate.logAsUser = _UserMngButton.titleLabel.text;
            appDelegate.logOriginUser = [responseObject valueForKey:@"login_as_return_email"];
            
            [self toggleUserMngView];
        } else {
            [Functions checkError:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)actionLoginBack {
    
    //[SVProgressHUD showWithStatus:@"Log back..."];
    //[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, USER_LOGINBACK];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [self getProfile];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINAS object:self];
            
            appDelegate.isLogAs = NO;
            [self toggleUserMngView];
        } else {
            [Functions checkError:responseObject];
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
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UPDATE_PROFILE object:self];
            }
        }else
            [Functions showAlert:@"" message:[responseObject valueForKey:@"msg"]];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)getUserList {
    
    [SVProgressHUD showWithStatus:@"Listing users..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, USER_LIST];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [self parseUserArray:responseObject];
        } else {
            [Functions checkError:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)parseUserArray:(id)responseObject {
    NSArray* userObject = [responseObject valueForKey:@"users"];
    for (NSDictionary *obj in userObject) {
        UserModel *userModel = [[UserModel alloc] init];
        userModel.user_id = [obj valueForKey:@"id"];
        userModel.email = [obj valueForKey:@"email"];
        userModel.can_login = [obj valueForKey:@"can_login"];
        userModel.role = [obj valueForKey:@"role"];
        
        [appDelegate.UserArray addObject:userModel];
        [appDelegate.UserEmailArray addObject:[obj valueForKey:@"email"]];
    }
    
    [self showUserList];
}

- (void)showUserList {
    if(_menuDrop == nil) {
        CGFloat f = 224;
        _menuDrop = [[NIDropDown alloc] showDropDown:_UserMngButton :&f :appDelegate.UserEmailArray :nil :@"down"];
        _menuDrop.delegate = self;
    }
    else {
        [_menuDrop hideDropDown:_UserMngButton];
        _menuDrop = nil;
    }
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnScanBehaviourClicked:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"scanbehaviour"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)OnAboutClicked:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)OnHelpClicked:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"help"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)OnUserMngClicked:(id)sender {
    if (appDelegate.UserArray.count == 0) {
        [self getUserList];
    } else {
        [self showUserList];
    }
}

- (IBAction)OnLogBackClicked:(id)sender {
    [self actionLoginBack];
}

#pragma mark - NIDropDelegates
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selectedIndex:(NSInteger)selectedIndex{
    _menuDrop = nil;
    UserModel *userObj = [appDelegate.UserArray objectAtIndex:selectedIndex];
    [self actionLoginAs:userObj.user_id];
}
@end
