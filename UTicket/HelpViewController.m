//
//  HelpViewController.m
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:HELP_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_WebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openURl:(NSString*)url{
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:url] /*options:@{} completionHandler:nil*/];
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnTicketHelp:(id)sender {
    [self openURl:@"https://uticket.ie/ticket-buyer-help"];
}

- (IBAction)OnEventHelp:(id)sender {
    [self openURl:@"https://uticket.ie/event-organiser-help"];
}

- (IBAction)OnEventTips:(id)sender {
    [self openURl:@"https://uticket.ie/event-organiser-tips"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}
@end
