//
//  ScanBehaviourViewController.m
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "ScanBehaviourViewController.h"

#define mode_default @"Confirmed"
#define mode_fast    @"Fast"

@interface ScanBehaviourViewController ()

@end

@implementation ScanBehaviourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = [NSUserDefaults standardUserDefaults];
    originSetting = [userInfo objectForKey:KEY_QR_SCAN];
    if ([[userInfo objectForKey:KEY_QR_SCAN] isEqualToString:mode_default]) {
        [self OnDefaultClicked:nil];
    }
    else
        [self OnFastTrackClicked:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnDefaultClicked:(id)sender {
    [userInfo setObject:mode_default forKey:KEY_QR_SCAN];
    [_DefaultImage setImage:[UIImage imageNamed:@"radio_check"]];
    [_FastImage setImage:[UIImage imageNamed:@"radio_uncheck"]];
}

- (IBAction)OnFastTrackClicked:(id)sender {
    [userInfo setObject:mode_fast forKey:KEY_QR_SCAN];
    [_DefaultImage setImage:[UIImage imageNamed:@"radio_uncheck"]];
    [_FastImage setImage:[UIImage imageNamed:@"radio_check"]];
}

- (IBAction)OnBackClicked:(id)sender {
    
    if ([originSetting isEqualToString:[userInfo objectForKey:KEY_QR_SCAN]]) {
        NSLog(@"nothing changed");
    }
    else
    {
        [self actionUpdateProfile];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionUpdateProfile{
    
    [SVProgressHUD showWithStatus:@"Updating profile..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"qr_scan_mode":[userInfo objectForKey:KEY_QR_SCAN]};
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, PROFILE_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
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
@end
