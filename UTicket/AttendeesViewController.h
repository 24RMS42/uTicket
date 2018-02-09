//
//  AttendeesViewController.h
//  UTicket
//
//  Created by matata on 12/3/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "Ticket.h"
#import "MGSwipeTableCell.h"
#import "UIColor+ColorWithHex.h"
#import "AppDelegate.h"
#import "Event.h"
#import "CheckStats.h"
#import "TSMessage.h"

@interface AttendeesViewController : UIViewController <MGSwipeTableCellDelegate>
{
    NSMutableArray *ticketPendingArray, *ticketCheckedArray;
    NSMutableArray *originPendingArray, *originCheckedArray;
    NSArray *sectionTitles;
    UIRefreshControl *refreshControl;
    NSTimer *scanActionTimer;
}

@property (nonatomic,strong) NSString *eventID;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UITextField *SearchField;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)OnSearchClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;

@end
