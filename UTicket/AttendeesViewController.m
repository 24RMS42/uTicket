//
//  AttendeesViewController.m
//  UTicket
//
//  Created by matata on 12/3/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "AttendeesViewController.h"

@interface AttendeesViewController ()

@end

@implementation AttendeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sectionTitles = [NSArray arrayWithObjects:@"PENDING", @"CHECKED IN ALREADY", nil];
    [self getAttendees:YES];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.TableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [_SearchField addTarget:self
                     action:@selector(textFieldDidChanged:)
           forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)startScanActionTimer {
    scanActionTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                       target:self
                                                     selector:@selector(forceScanAction)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)stopScanActionTimer {
    [scanActionTimer invalidate];
    scanActionTimer = nil;
}

- (void)forceScanAction {
    [SVProgressHUD dismiss];
    NSString *failMsg = @"Please move to a better coverage area to have the best experience";
    [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                          title:@"Fail"
                                       subtitle:failMsg
                                           type:TSMessageNotificationTypeWarning
                                       duration:3.0];
}

- (void)refreshTable {
    _SearchField.text = @"";
    [_SearchButton setHidden:NO];
    [_CancelButton setHidden:YES];
    [self getAttendees:NO];
}

- (void)getAttendees: (BOOL)withStatusBar{
    
    if (withStatusBar) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@?past=&upcoming=&sold=1&bought=&event_id=%@", BASE_URL, EVENT_TICKETS, _eventID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        [refreshControl endRefreshing];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            ticketPendingArray = [[NSMutableArray alloc] init];
            ticketCheckedArray = [[NSMutableArray alloc] init];
            originPendingArray = [[NSMutableArray alloc] init];
            originCheckedArray = [[NSMutableArray alloc] init];
            
            NSArray *ticketObject = [responseObject valueForKey:@"tickets"];
            
            for (NSDictionary *obj in ticketObject) {
                Ticket *ticket = [[Ticket alloc] init];
                ticket.ticketId = [obj valueForKey:@"id"];
                ticket.event_id = [obj valueForKey:@"event_id"];
                ticket.name =     [obj valueForKey:@"ticket"];
                ticket.starts =   [obj valueForKey:@"starts"];
                ticket.type =     [obj valueForKey:@"type"];
                ticket.code =     [obj valueForKey:@"code"];
                ticket.buyer =    [obj valueForKey:@"buyer"];
                ticket.created =  [obj valueForKey:@"created"];
                ticket.buyer_name =      [Functions checkNullValue:[obj valueForKey:@"buyer_name"]];
                ticket.buyer_last_name = [self getLastName:ticket.buyer_name];
                
                if ([[obj valueForKey:@"checked_by"] isKindOfClass:[NSNull class]]) {
                    [ticketPendingArray addObject:ticket];
                }
                else
                {
                    [ticketCheckedArray addObject:ticket];
                }
            }
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"buyer_last_name"
                                                         ascending:YES];
            NSArray *ticketChecked = [ticketCheckedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            NSArray *ticketPending = [ticketPendingArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            ticketCheckedArray = [NSMutableArray arrayWithArray:ticketChecked];
            ticketPendingArray = [NSMutableArray arrayWithArray:ticketPending];
            
            [originCheckedArray addObjectsFromArray:ticketCheckedArray];
            [originPendingArray addObjectsFromArray:ticketPendingArray];
            [self.TableView reloadData];
            
        }else
            [Functions checkError:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)checkinTicket: (NSString*)ticketID{
    
    [self startScanActionTimer];
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary * parameters=@{@"ticket[0][id]":ticketID,
                                @"ticket[0][checked]":@(1)
                                };
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, EVENT_CHECKEDIN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss];
        [self performSelectorOnMainThread:@selector(stopScanActionTimer) withObject:nil waitUntilDone:YES];
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            //[self getAttendees];
            [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                                  title:@"Success"
                                               subtitle:@"Checkin completed ok!"
                                                   type:TSMessageNotificationTypeSuccess
                                               duration:2.0];
            
            [self updateResult:ticketID];
        }else
        {
            [Functions checkError:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self performSelectorOnMainThread:@selector(stopScanActionTimer) withObject:nil waitUntilDone:YES];
        [Functions parseError:error];
    }];
}

/* UT-2546 */
- (void)updateEventCheckinCount : (NSUInteger)checkInCount
{
    NSInteger count = [appDelegate.GEventArray count];
    for (NSInteger i = count - 1; i >= 0; i--) {
        
        Event *itemObj = [appDelegate.GEventArray objectAtIndex:i];
        if ([itemObj.eventId isEqualToString:_eventID])
        {
            if ([itemObj.checkinStats count] != 0) {
                CheckStats *statsObj = [itemObj.checkinStats objectAtIndex:0];
                statsObj.checked_in_count = [NSString stringWithFormat:@"%lu", (unsigned long)checkInCount];
                [itemObj.checkinStats replaceObjectAtIndex:0 withObject:statsObj];
                [appDelegate.GEventArray replaceObjectAtIndex:i withObject:itemObj];
            }
            
            break;
        }
    }
}

- (NSString*)getLastName: (NSString*)fullName
{
    if ([fullName isEqualToString:@""]) {
        return @"";
    }
    else
    {
        NSArray *s = [fullName componentsSeparatedByString:@" "];
        if (s.count > 1) {
            return s[1];
        }
    }
    return @"";
}

/* UT-2561 */
- (void)updateResult: (NSString*)ticketID
{
    originPendingArray = [[NSMutableArray alloc] init];
    originCheckedArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [ticketPendingArray count]; i++) {
        Ticket *ticketObj = [ticketPendingArray objectAtIndex:i];
        if ([ticketObj.ticketId isEqualToString:ticketID]) {
            [ticketPendingArray removeObjectAtIndex:i];
            [ticketCheckedArray addObject:ticketObj];
            
            [self updateEventCheckinCount: ticketCheckedArray.count];
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"buyer_last_name"
                                                         ascending:YES];
            NSArray *ticketChecked = [ticketCheckedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            ticketCheckedArray = [NSMutableArray arrayWithArray:ticketChecked];
            
            [originCheckedArray addObjectsFromArray:ticketCheckedArray];
            [originPendingArray addObjectsFromArray:ticketPendingArray];
            [self.TableView reloadData];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [ticketPendingArray count] == 0 ? 1 : [ticketPendingArray count];
    }
    if (section == 1) {
        return [ticketCheckedArray count] == 0 ? 1 : [ticketCheckedArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
//        return 0;
//    } else {
//        return 35;
//    }//commented out this line as need to show something even if section is empty
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.TableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITableViewCell *defaultcell = [self.TableView dequeueReusableCellWithIdentifier:@"default"];
    if (defaultcell == nil) {
        defaultcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    if (indexPath.section == 0) {
        if ([ticketPendingArray count] == 0) {
            defaultcell.text = @"No tickets pending";
            return defaultcell;
        }
    }
    else
    {
        if ([ticketCheckedArray count] == 0) {
            defaultcell.text = @"No tickets checked in";
            return defaultcell;
        }
    }
    
    static NSString *simpleTableIdentifier = @"AttendeeCell";
    
    MGSwipeTableCell *cell = [self.TableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *namelbl = (UILabel*)[cell viewWithTag:20];
    UILabel *nolbl = (UILabel*)[cell viewWithTag:21];
    UILabel *timelbl = (UILabel*)[cell viewWithTag:22];
    UIImageView *handImg = (UIImageView*)[cell viewWithTag:23];
    UIImageView *noteImg = (UIImageView*)[cell viewWithTag:24];
    UIImageView *checkedinImg = (UIImageView*)[cell viewWithTag:25];
    
    Ticket *ticketObj = [[Ticket alloc] init];
    if (indexPath.section == 0) {
        ticketObj = [ticketPendingArray objectAtIndex:indexPath.row];
        
        [noteImg setImage:[UIImage imageNamed:@"note_select.png"]];
        [handImg setHidden:NO];
        [checkedinImg setHidden:YES];
        
        /*UISwipeGestureRecognizer* sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
        [sgr setDirection:UISwipeGestureRecognizerDirectionRight];
        [cell addGestureRecognizer:sgr];*/
        
        //configure left buttons
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" backgroundColor:[UIColor colorWithHex:COLOR_SECONDARY] callback:^BOOL(MGSwipeTableCell * sender){
            
            Ticket *ticketObj = [[Ticket alloc] init];
            ticketObj = [ticketPendingArray objectAtIndex:indexPath.row];
            [self checkinTicket:ticketObj.ticketId];
            return YES;
        }];
        cell.leftButtons = @[button];
        cell.leftSwipeSettings.transition = MGSwipeTransition3D;
        cell.delegate = self;
    }
    if (indexPath.section == 1) {
        ticketObj = [ticketCheckedArray objectAtIndex:indexPath.row];
        
        [noteImg setImage:[UIImage imageNamed:@"note.png"]];
        [handImg setHidden:YES];
        [checkedinImg setHidden:NO];
        
        //configure left buttons
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" backgroundColor:[UIColor colorWithHex:COLOR_SECONDARY]]];
        cell.leftSwipeSettings.transition = MGSwipeTransition3D;
        cell.delegate = nil;
    }
    
    NSString *ticketNO = [NSString stringWithFormat:@"Ticket No. %@ - %@", ticketObj.code, ticketObj.type];
    nolbl.text = ticketNO;
    namelbl.text = ticketObj.buyer_name;
    timelbl.text = ticketObj.created;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point
{
    return YES;
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive
{
    if (state == MGSwipeStateSwipingLeftToRight) {
        NSIndexPath* indexPath = [self.TableView indexPathForCell:cell];
        
        Ticket *ticketObj = [[Ticket alloc] init];
        ticketObj = [ticketPendingArray objectAtIndex:indexPath.row];
        [self checkinTicket:ticketObj.ticketId];
    }
}

- (void)cellSwiped:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        UITableViewCell *cell = (UITableViewCell *)gestureRecognizer.view;
        NSIndexPath* indexPath = [self.TableView indexPathForCell:cell];
        
        Ticket *ticketObj = [[Ticket alloc] init];
        ticketObj = [ticketPendingArray objectAtIndex:indexPath.row];
        [self checkinTicket:ticketObj.ticketId];
    }
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnSearchClicked:(id)sender {
}

- (void)textFieldDidChanged: (UITextField*)textField
{
    ticketCheckedArray = [[NSMutableArray alloc] init];
    ticketPendingArray = [[NSMutableArray alloc] init];
    
    if (_SearchField.text.length == 0) {
        [ticketCheckedArray addObjectsFromArray:originCheckedArray];
        [ticketPendingArray addObjectsFromArray:originPendingArray];
        [_SearchButton setHidden:NO];
        [_CancelButton setHidden:YES];
    }
    else
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"buyer_name CONTAINS[c] %@", _SearchField.text];
        ticketCheckedArray = [originCheckedArray filteredArrayUsingPredicate:resultPredicate];
        ticketPendingArray = [originPendingArray filteredArrayUsingPredicate:resultPredicate];
        [_SearchButton setHidden:YES];
        [_CancelButton setHidden:NO];
    }
    
    [self.TableView reloadData];
}

- (IBAction)OnCancelClicked:(id)sender {
    _SearchField.text = @"";
    [self textFieldDidChanged:_SearchField];
}

@end
