//
//  AppDelegate.h
//  UTicket
//
//  Created by matata on 11/20/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *GEventArray;
@property (strong, nonatomic) NSMutableArray *UserArray;
@property (strong, nonatomic) NSMutableArray *UserEmailArray;
@property (nonatomic, strong) NSString *logAsUser;
@property (nonatomic, strong) NSString *logOriginUser;
@property (nonatomic, assign) BOOL isLogAs;

@end

