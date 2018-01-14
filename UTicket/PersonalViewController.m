//
//  PersonalViewController.m
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [Functions configureButton:button];
    
    [Functions makeFloatingField:_FirstNameField placeholder:@"First Name"];
    [Functions makeFloatingField:_LastNameField placeholder:@"Last Name"];
    [Functions makeFloatingField:_EmailField placeholder:@"Email"];
    [Functions makeFloatingField:_PhoneField placeholder:@"Phone"];
    [Functions makeFloatingField:_AddressField placeholder:@"Address"];
    [Functions makeFloatingField:_ZipcodeField placeholder:@"Eircode"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fillProfileData:)
                                                 name:NOTI_UPDATE_PROFILE
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [self fillProfileData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)fillProfileData:(NSNotification *)notification {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [_FirstNameField setText:[userInfo objectForKey:KEY_FIRSTNAME]];
    [_LastNameField  setText:[userInfo objectForKey:KEY_LASTNAME]];
    [_EmailField     setText:[userInfo objectForKey:KEY_EMAIL]];
    [_PhoneField     setText:[userInfo objectForKey:KEY_PHONE]];
    [_AddressField   setText:[userInfo objectForKey:KEY_ADDRESS]];
    [_ZipcodeField   setText:[userInfo objectForKey:KEY_EIRCODE]];
}

- (void)actionUpdateProfile{
    
    [SVProgressHUD showWithStatus:@"Updating profile..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"email":_EmailField.text,
                                @"name":_FirstNameField.text,
                                @"surname":_LastNameField.text,
                                @"phone":_PhoneField.text,
                                @"address":_AddressField.text,
                                @"eircode":_ZipcodeField.text
                                };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, PROFILE_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            [userInfo setObject:_FirstNameField.text forKey:KEY_FIRSTNAME];
            [userInfo setObject:_LastNameField.text  forKey:KEY_LASTNAME];
            [userInfo setObject:_EmailField.text     forKey:KEY_EMAIL];
            [userInfo setObject:_PhoneField.text     forKey:KEY_PHONE];
            [userInfo setObject:_AddressField.text   forKey:KEY_ADDRESS];
            [userInfo setObject:_ZipcodeField.text   forKey:KEY_EIRCODE];
            
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
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSDictionary * parameters=@{@"email":_EmailField.text,
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

- (IBAction)OnClickUpdateProfile:(id)sender {
    [self actionUpdateProfile];
}
@end
