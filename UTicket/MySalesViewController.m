//
//  MySalesViewController.m
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "MySalesViewController.h"

@interface MySalesViewController ()

@end

@implementation MySalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    [Functions configureButton:button];
    [Functions configureButton:button2];
    
    [Functions makeShadowLabel:_EventCountLabel];
    [self actionLogin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getEvents:)
                                                 name:NOTIFICATION_LOGINAS
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getEvents:(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEARCH_EVENT object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SEARCH_PAST_EVENT object:self];
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, EVENT_DASHBOARD_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            int live_event_count = [[responseObject valueForKey:@"events_on_sale_count"] intValue];
            id next_event = [responseObject valueForKey:@"events_on_sale_next"];
            if (next_event != [NSNull null]) {
                _NextEventLabel.text = [next_event valueForKey:@"name"];
                nextEventID = [next_event valueForKey:@"id"];
            }
            else
                [_NextEventButton setEnabled:NO];
            
            _EventCountLabel.text = [NSString stringWithFormat:@"%d", live_event_count];
            
        }else
            [Functions checkError:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)actionLogin{
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSDictionary * parameters=@{@"email":[userInfo objectForKey:KEY_EMAIL],
                                @"password":[userInfo objectForKey:KEY_PASSWORD]
                                };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_API];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            [self getEvents:nil];
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

- (IBAction)OnLiveEventClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEWEVENT object:self];
}

- (IBAction)OnNextEventClicked:(id)sender {
    NSDictionary* info = @{@"eventID": nextEventID};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EVENT_DASHBOARD object:self userInfo:info];
}
@end
