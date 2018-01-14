//
//  Functions.m
//  UTicket
//
//  Created by matata on 11/23/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "Functions.h"
#import "UIAlertController+Window.h"

@implementation Functions

+ (Functions *)sharedInstance {
    static dispatch_once_t onceToken;
    static Functions *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Functions alloc] init];
    });
    return instance;
}

+(id)checkNullValueWithZero:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"0";
    }
    NSString * str =[NSString stringWithFormat:@"%@",value];
    
    return str;
}

+ (id)checkNullValue:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value==nil)
    {
        value = @"";
    }
    NSString * str =[NSString stringWithFormat:@"%@",value];
    
    return str;
}

+ (void)showAlert: (NSString*)title message:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [alert show];
}

+ (void)makeFloatingField: (JVFloatLabeledTextField*)textfield placeholder:(NSString*)placeholder
{
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    textfield.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    textfield.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:placeholder
                                    attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    textfield.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    textfield.floatingLabelTextColor = floatingLabelColor;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
}

+ (void)makeShadowLabel: (UILabel*)label
{
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 0.0;
    label.layer.shadowColor = [UIColor grayColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

+ (void)makeRoundShadowView: (UIView*)view
{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds = NO;
    
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
    
    view.layer.shadowOpacity = 1.0;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

+ (NSString*)getCurrentDateTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (void)configureButton: (UIButton*)button
{
    [button setBackgroundColor:[UIColor colorWithHex:COLOR_PRIMARY]];
    
    button.layer.shadowOpacity = 1.0;
    button.layer.shadowRadius = 2.0;
    button.layer.shadowColor = [UIColor grayColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0.5, 0.5);
}

+ (void)parseError: (NSError*)error
{
    NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData == nil || [errorData isKindOfClass:[NSNull class]]) {
        [Functions showAlert:@"Alert" message:NETWORK_ERROR];
    }
    else
    {
        id json = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
        if ([BUILD_MODE isEqualToString:@"LIVE"]) {
            [Functions showAlert:@"ERROR" message:ERROR_MSG];
        }
        else
            [Functions showAlert:@"ERROR" message:[json objectForKey:@"msg"]];
    }
}

+ (void)checkError:(id)responseObject
{
    if ([BUILD_MODE isEqualToString:@"LIVE"]) {
        [Functions showAlert:@"Error" message:ERROR_MSG];
    }
    else
        [Functions showAlert:@"Error" message:[responseObject valueForKey:@"msg"]];
}
@end
