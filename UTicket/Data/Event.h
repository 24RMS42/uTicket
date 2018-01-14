//
//  Event.h
//  UTicket
//
//  Created by matata on 11/28/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "EventDate.h"

@interface Event : NSObject

@property (strong ,nonatomic) NSString *eventId;
@property (strong ,nonatomic) NSString *name;
@property (strong ,nonatomic) NSString *logo_id;
@property (strong ,nonatomic) NSString *venue_id;
@property (strong ,nonatomic) NSString *category_id;
@property (strong ,nonatomic) NSString *topic_id;
@property (strong ,nonatomic) NSString *descriptionn;
@property (strong ,nonatomic) NSString *quantity;
@property (strong ,nonatomic) NSString *featured;
@property (strong ,nonatomic) NSString *publish;
@property (strong ,nonatomic) NSString *deleted;
@property (strong ,nonatomic) NSString *date_created;

@property (strong ,nonatomic) NSString *created_by;
@property (strong ,nonatomic) NSString *is_online;
@property (strong ,nonatomic) NSString *is_onsale;
@property (strong ,nonatomic) NSString *is_public;
@property (strong ,nonatomic) NSString *show_remaining_tickets;
@property (strong ,nonatomic) NSString *url;
@property (strong ,nonatomic) NSString *owned_by;
@property (strong ,nonatomic) NSString *status;
@property (strong ,nonatomic) NSString *email_note;
@property (strong ,nonatomic) NSString *currency;
@property (strong ,nonatomic) NSString *contact_full_name;
@property (strong ,nonatomic) NSString *category;

@property (strong ,nonatomic) NSString *venue;
@property (strong ,nonatomic) NSString *address_1;
@property (strong ,nonatomic) NSString *address_2;
@property (strong ,nonatomic) NSString *city;
@property (strong ,nonatomic) NSString *dates;
@property (strong ,nonatomic) NSString *allocated;
@property (strong ,nonatomic) NSString *invoice_id;
@property (strong ,nonatomic) NSString *totalsold;
@property (strong ,nonatomic) NSString *sold;

@property (strong ,nonatomic) NSMutableArray *tickets;
@property (strong ,nonatomic) NSMutableArray *checkinStats;
@property (strong ,nonatomic) EventDate *eventDate;

@end
