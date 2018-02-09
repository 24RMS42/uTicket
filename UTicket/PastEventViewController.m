//
//  PastEventViewController.m
//  UTicket
//
//  Created by matata on 11/27/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "PastEventViewController.h"

@interface PastEventViewController ()

@end

@implementation PastEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [Functions configureButton:button];
    
    offset = 0;
    originArray = [[NSMutableArray alloc]init];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [_SearchField addTarget:self
                     action:@selector(textFieldDidChanged:)
           forControlEvents:UIControlEventEditingChanged];
    
    [self startSearch:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startSearch:)
                                                 name:NOTI_SEARCH_PAST_EVENT
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)refreshTable {
    
    _SearchField.text = @"";
    [_SearchButton setHidden:NO];
    [_CancelButton setHidden:YES];
    
    originArray = [[NSMutableArray alloc]init];
    offset = 0;
    _whileSearch = NO;
    
    [self searchEvents:NO];
}

- (void)startSearch:(NSNotification *) notification{
    originArray = [[NSMutableArray alloc]init];
    [self searchEvents : YES];
}

- (void)searchEvents : (BOOL)withStatusBar{
    
    if (withStatusBar) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@?own=1&before=%@&after=&limit=10&offset=%d&category_id=&tags=&venue_id=", BASE_URL, EVENT_SEARCH, [Functions getCurrentDateTime], offset];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        [refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        eventArray = [[NSMutableArray alloc]init];
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            
            [self parseEventArray:responseObject];
            
            [appDelegate.GEventArray addObjectsFromArray:eventArray];
            [originArray addObjectsFromArray:eventArray];
            
            eventArray = [[NSMutableArray alloc] init];
            [eventArray addObjectsFromArray:originArray];
            
            [self.tableView reloadData];
            
            if ([eventArray count] == 0) {
                [self.tableView setHidden:YES];
                [self.SearchView setHidden:YES];
            } else {
                [self.tableView setHidden:NO];
                [self.SearchView setHidden:NO];
            }
            
        }else
        {
            [Functions checkError:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)searchEventsByKeyword:(NSString*)keyword{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?own=1&before=%@&keyword2=%@", BASE_URL, EVENT_SEARCH, [Functions getCurrentDateTime], keyword];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        eventArray = [[NSMutableArray alloc]init];
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            
            if (_whileSearch == NO) {
                return;
            }
            
            [self parseEventArray:responseObject];
            
            [appDelegate.GEventArray addObjectsFromArray:eventArray];
            
            [self.tableView reloadData];
        }
        else
        {
            [Functions checkError:responseObject];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [Functions parseError:error];
    }];
}

- (void)parseEventArray: (id)responseObject
{
    NSArray* eventObject = [responseObject valueForKey:@"events"];
    for (NSDictionary *obj in eventObject) {
        Event *event = [[Event alloc]init];
        event.eventId =   [obj valueForKey:@"id"];
        event.name =      [obj valueForKey:@"name"];
        event.city =      [obj valueForKey:@"city"];
        event.venue =     [obj valueForKey:@"venue"];
        event.address_1 = [obj valueForKey:@"address_1"];
        event.quantity =  [obj valueForKey:@"quantity"];
        event.sold =      [Functions checkNullValueWithZero:[obj valueForKey:@"sold"]];
        
        //get event tickets
        event.tickets = [[NSMutableArray alloc]init];
        NSArray *ticketArray = [obj valueForKey:@"tickets"];
        for (NSDictionary *obj in ticketArray) {
            Ticket *ticket = [[Ticket alloc]init];
            ticket.ticketId =   [obj valueForKey:@"id"];
            ticket.event_id =   [obj valueForKey:@"event_id"];
            ticket.name     =   [obj valueForKey:@"name"];
            ticket.base_price = [obj valueForKey:@"base_price"];
            
            [event.tickets addObject:ticket];
        }
        
        /* get ticket checkin status */
        event.checkinStats = [[NSMutableArray alloc] init];
        NSArray *checkStatArray = [obj valueForKey:@"checkin_stats"];
        for (NSDictionary *obj in checkStatArray) {
            CheckStats *stats = [[CheckStats alloc] init];
            stats.checked_in_count = [obj valueForKey:@"checked_in_count"];
            stats.sold_count       = [obj valueForKey:@"sold_count"];
            stats.starts           = [obj valueForKey:@"starts"];
            stats.date_id          = [obj valueForKey:@"date_id"];
            
            [event.checkinStats addObject:stats];
        }
        
        [eventArray addObject:event];
    }
}

- (void)getEventDetail:(NSString*)eventID{
    
    EventDate *eventDate = [[EventDate alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@?id=%@", BASE_URL, EVENT_DETAILS, eventID];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        int success = [[responseObject valueForKey:@"success"] intValue];
        if (success == 1) {
            id detailObject = [responseObject valueForKey:@"details"];
            NSArray *dateObject = [detailObject valueForKey:@"dates"];
            
            for (NSDictionary *obj in dateObject) {
                eventDate.dateId =     [obj valueForKey:@"id"];
                eventDate.event_id =   [obj valueForKey:@"event_id"];
                eventDate.starts =     [obj valueForKey:@"starts"];
                eventDate.start_date = [obj valueForKey:@"start_date"];
                eventDate.start_time = [obj valueForKey:@"start_time"];
            }
            
            for (int i = 0; i < [eventArray count]; i++) {
                Event *item = [eventArray objectAtIndex:i];
                if ([item.eventId isEqualToString:eventID]) {
                    item.eventDate = eventDate;
                    [eventArray replaceObjectAtIndex:i withObject:item];
                }
            }
            [appDelegate.GEventArray addObjectsFromArray:eventArray];
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([eventArray count] == 0) {
        return 0;
    }
    else
        return [eventArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    MBCircularProgressBarView *progressView = (MBCircularProgressBarView*)[cell viewWithTag:20];
    UILabel *namelbl = (UILabel*)[cell viewWithTag:21];
    UILabel *timelbl = (UILabel*)[cell viewWithTag:22];
    UILabel *locationlbl = (UILabel*)[cell viewWithTag:23];
    UILabel *statuslbl = (UILabel*)[cell viewWithTag:24];
    
    if ([eventArray count] > 0) {
        Event *itemObj = [eventArray objectAtIndex:indexPath.row];
        CGFloat s = (CGFloat)itemObj.sold.intValue / itemObj.quantity.intValue * 100;
        progressView.value = s;
        namelbl.text = itemObj.name;
        locationlbl.text = itemObj.venue;
        
        if ([itemObj.checkinStats count] != 0) {
            CheckStats *stats = [itemObj.checkinStats objectAtIndex:0];
            timelbl.text = stats.starts;
        }
        
        int remaining = itemObj.quantity.intValue - itemObj.sold.intValue;
        statuslbl.text = [NSString stringWithFormat:@"%d / %@ (%@ sold)", remaining, itemObj.quantity, itemObj.sold];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([eventArray count] > 0 && !_whileSearch) {
        if(indexPath.row >= (offset + 9) && indexPath.row == eventArray.count-1)
        {
            NSLog(@"row:%ld", (long)indexPath.row);
            offset += 10;
            [self searchEvents:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *itemObj = [eventArray objectAtIndex:indexPath.row];
    NSDictionary* info = @{@"eventID": itemObj.eventId};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EVENT_DASHBOARD object:self userInfo:info];
}

- (IBAction)OnUpEventClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPEVENT object:self];
}

- (IBAction)OnSearchClicked:(id)sender {
}

- (IBAction)OnCancelClicked:(id)sender {
    _SearchField.text = @"";
    [self textFieldDidChanged:_SearchField];
}

- (void)textFieldDidChanged: (UITextField*)textField
{
    eventArray = [[NSMutableArray alloc]init];
    
    if (_SearchField.text.length == 0) {
        _whileSearch = NO;
        [eventArray addObjectsFromArray:originArray];
        [_SearchButton setHidden:NO];
        [_CancelButton setHidden:YES];
    }
    else
    {
        /*NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", _SearchField.text];
        eventArray = [originArray filteredArrayUsingPredicate:resultPredicate];*/
        _whileSearch = YES;
        [self searchEventsByKeyword:_SearchField.text];
        [_SearchButton setHidden:YES];
        [_CancelButton setHidden:NO];
    }
    
    [self.tableView reloadData];
}
@end
