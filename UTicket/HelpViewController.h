//
//  HelpViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"

@interface HelpViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *WebView;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)OnTicketHelp:(id)sender;
- (IBAction)OnEventHelp:(id)sender;
- (IBAction)OnEventTips:(id)sender;
@end
