//
//  PastEventViewController.h
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
#import "Event.h"
#import "EventDate.h"
#import "CheckStats.h"
#import <MBCircularProgressBar/MBCircularProgressBarView.h>
#import "AppDelegate.h"

@interface PastEventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *eventArray, *originArray;
    UIRefreshControl *refreshControl;
    int offset;
}
@property (nonatomic, assign) bool whileSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UITextField *SearchField;
@property (weak, nonatomic) IBOutlet UIView *SearchView;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;

- (IBAction)OnUpEventClicked:(id)sender;
- (IBAction)OnSearchClicked:(id)sender;
- (IBAction)OnCancelClicked:(id)sender;
@end
