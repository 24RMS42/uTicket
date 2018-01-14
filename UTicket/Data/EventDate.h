//
//  EventDate.h
//  UTicket
//
//  Created by matata on 11/28/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDate : NSObject

@property (strong ,nonatomic) NSString *dateId;
@property (strong ,nonatomic) NSString *event_id;
@property (strong ,nonatomic) NSString *starts;
@property (strong ,nonatomic) NSString *start_date;
@property (strong ,nonatomic) NSString *start_time;

@end
