//
//  Functions.h
//  UTicket
//
//  Created by matata on 11/23/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "JVFloatLabeledTextField.h"
#import "macro.h"
#import <AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+ColorWithHex.h"

@interface Functions : NSObject

+ (Functions *)sharedInstance;
+ (id)checkNullValueWithZero:(id)value;
+ (id)checkNullValue:(id)value;
+ (void)showAlert: (NSString*)title message:(NSString*)message;
+ (void)makeFloatingField: (JVFloatLabeledTextField*)textfield placeholder:(NSString*)placeholder;
+ (void)makeShadowLabel: (UILabel*)label;
+ (void)makeRoundShadowView: (UIView*)view;
+ (NSString*)getCurrentDateTime;
+ (void)configureButton: (UIButton*)button;

+ (void)parseError: (NSError*)error;
+ (void)checkError: (id)responseObject;

@end
