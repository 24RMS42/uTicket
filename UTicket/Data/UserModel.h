//
//  UserModel.h
//  UTicket
//
//  Created by matata on 1/3/18.
//  Copyright © 2018 matata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong ,nonatomic) NSString *user_id;
@property (strong ,nonatomic) NSString *email;
@property (strong ,nonatomic) NSString *can_login;
@property (strong ,nonatomic) NSString *role;

@end
