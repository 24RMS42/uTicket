//
//  Venue.h
//  UTicket
//
//  Created by matata on 11/28/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (strong ,nonatomic) NSString *venueId;
@property (strong ,nonatomic) NSString *name;
@property (strong ,nonatomic) NSString *city;
@property (strong ,nonatomic) NSString *eircode;
@property (strong ,nonatomic) NSString *date_created;
@property (strong ,nonatomic) NSString *created_by;
@property (strong ,nonatomic) NSString *address_1;
@property (strong ,nonatomic) NSString *address_2;

@end
