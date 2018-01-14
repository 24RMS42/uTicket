//
//  MySalesViewController.h
//  UTicket
//
//  Created by matata on 11/24/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "SSBouncyButton.h"

@interface MySalesViewController : UIViewController
{
    NSString* nextEventID;
}

@property (weak, nonatomic) IBOutlet UILabel *EventCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *NextEventLabel;
@property (weak, nonatomic) IBOutlet SSBouncyButton *NextEventButton;
- (IBAction)OnLiveEventClicked:(id)sender;
- (IBAction)OnNextEventClicked:(id)sender;

@end
