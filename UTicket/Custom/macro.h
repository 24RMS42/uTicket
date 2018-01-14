//
//  macro.h
//
//  Created by matata on 9/2/15.
//  Copyright (c) 2015 matata. All rights reserved.
//

#ifndef travel_macro_h

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define showAlert(title,msg,target) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:target cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define getScreen_Height (NSString*) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? @"regular" : @"long")

#define kBgQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SCREEN_HEIGHT   self.view.frame.size.height
#define SCREEN_WIDTH    self.view.frame.size.width

#define BUILD_MODE      @"UAT"
#define BASE_URL        @"http://uticket.websitecms.ie/api/"
//#define BASE_URL        @"http://uticket.websitecms.test/api/"
#define LOGIN_API       @"user/login"
#define SIGNUP_API      @"user/register"
#define FORGOTPWD_API   @"user/forgotpw"
#define PROFILE_API     @"user/profile"
#define EVENT_DASHBOARD_API @"events/dashboard"
#define EVENT_SEARCH        @"events/search"
#define EVENT_DETAILS       @"events/details"
#define EVENT_TICKETS       @"events/tickets"
#define EVENT_CHECKEDIN     @"events/checkin"
#define EVENT_QRSCAN        @"events/qrcode_scan"
#define STRIPE_BEGIN_API    @"user/stripe_connect_begin"
#define STRIPE_COMPLETE_API @"user/stripe_connect_complete"
#define STRIPE_DISCONNECT   @"user/stripe_disconnect"
#define USER_LIST           @"user/list"
#define USER_LOGINAS        @"user/login_as"
#define USER_LOGINBACK      @"user/login_back"
#define CREATE_EVENT_URL    @"http://uticket.websitecms.ie/admin/events/edit_event/new"
#define HELP_URL            @"http://uticket.websitecms.ie/support"

#define ERROR_MSG       @"An error occurred. Please try again later"
#define NETWORK_ERROR   @"Please check your network status"
#define KEY_LOGGEDIN    @"loggedin"
#define KEY_LAUNCHED    @"launched"
#define KEY_REMEMBER    @"rememberme"
#define KEY_USERID      @"userid"
#define KEY_EMAIL       @"email"
#define KEY_PASSWORD    @"password"
#define KEY_FIRSTNAME   @"firstname"
#define KEY_LASTNAME    @"lastname"
#define KEY_PHONE       @"phone"
#define KEY_ADDRESS     @"address"
#define KEY_EIRCODE     @"eircode"
#define KEY_QR_SCAN     @"qr_scan_mode"
#define KEY_STRIPE_CON  @"use_stripe_connect"
#define KEY_IBAN        @"iban"
#define KEY_BIC         @"bic"
#define KEY_SUPER_USER  @"super_user"

#define NOTIFICATION_QUESTION  @"QuestionNotification"
#define NOTIFICATION_GO_HOME   @"GoHomeNotification"
#define NOTIFICATION_LOGOUT    @"LogoutNotification"
#define NOTIFICATION_SETTINGS  @"SettingsNotification"
#define NOTIFICATION_UPEVENT   @"ViewUpEventNotification"
#define NOTIFICATION_EVENT_DASHBOARD   @"EventDashboardNotification"
#define NOTIFICATION_VIEWEVENT @"ViewEventNotification"
#define NOTIFICATION_STRIPE    @"StripeNotification"
#define NOTIFICATION_SEARCH_EVENT @"SearchEventNotification"
#define NOTIFICATION_LOGINAS   @"LoginAsNotification"
#define NOTI_UPDATE_PROFILE    @"UpdateProfile"

#define kJVFieldFontSize 16.0f
#define kJVFieldFloatingLabelFontSize 11.0f
#define PageMenuOptionSelectionIndicatorHeight 7
#define PageMenuOptionMenuItemFont 18.0f
#define PageMenuOptionMenuHeight 45.0

#define COLOR_SECONDARY  0x31ceb4
#define COLOR_PRIMARY    0xF62A74
#define COLOR_GRAY       0xebebeb
#define COLOR_FONT       0x303030

#endif
