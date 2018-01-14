//
//  Ticket.h
//  UTicket
//
//  Created by matata on 11/28/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property (strong ,nonatomic) NSString *ticketId;
@property (strong ,nonatomic) NSString *event_id;
@property (strong ,nonatomic) NSString *type;
@property (strong ,nonatomic) NSString *name;
@property (strong ,nonatomic) NSString *descriptionn;
@property (strong ,nonatomic) NSString *show_description;
@property (strong ,nonatomic) NSString *created;
@property (strong ,nonatomic) NSString *created_by;
@property (strong ,nonatomic) NSString *base_price;

@property (strong ,nonatomic) NSString *starts;
@property (strong ,nonatomic) NSString *checked;
@property (strong ,nonatomic) NSString *code;
@property (strong ,nonatomic) NSString *buyer;
@property (strong ,nonatomic) NSString *buyer_name;
@property (strong ,nonatomic) NSString *buyer_last_name;

@end
