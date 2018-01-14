//
//  ViewController.m
//  UTicket
//
//  Created by matata on 11/20/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <EAIntroDelegate> {
    UIView *rootView;
    EAIntroView *_intro;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.navigationController.view;
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    if ([[userInfo objectForKey:KEY_REMEMBER] isEqualToString:@"yes"]) {
        [self goHome:nil];
        [userInfo setObject:@"yes" forKey:KEY_LOGGEDIN];//Go home directly
    }else
        [self setLoginForm];
    
    if (![[userInfo objectForKey:KEY_LAUNCHED] isEqualToString:@"yes"]) {
        [self setIntroPage:nil];
    }
    [userInfo setObject:@"yes" forKey:KEY_LAUNCHED];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                     selector:@selector(didTapGoToRight:)
                                     name:@"SignupNotification"
                                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                     selector:@selector(didTapGoToLeft:)
                                     name:@"LoginNotification"
                                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                     selector:@selector(forgotPassword:)
                                     name:@"ForgotPwdNotification"
                                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                     selector:@selector(setIntroPage:)
                                     name:NOTIFICATION_QUESTION
                                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                     selector:@selector(goHome:)
                                     name:NOTIFICATION_GO_HOME
                                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loggedOut:)
                                                 name:NOTIFICATION_LOGOUT
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setIntroPage:(NSNotification *) notification{
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"intro1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"intro2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"intro3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"intro4"];
    
    UIView *viewForPage5 = [[UIView alloc] initWithFrame:self.view.bounds];
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnStart setFrame:CGRectMake(30, SCREEN_HEIGHT*0.75, SCREEN_WIDTH - 60, 100)];
    [btnStart setTitle:@"" forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(removeIntro:) forControlEvents:UIControlEventTouchUpInside];
    [viewForPage5 addSubview:btnStart];
    
    EAIntroPage *page5 = [EAIntroPage pageWithCustomView:viewForPage5];
    page5.bgImage = [UIImage imageNamed:@"intro5"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[btn setFrame:CGRectMake(0, 0, 360, 0)];
    [btn setTitle:@"    " forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    intro.skipButton = btn;
    intro.skipButtonY = SCREEN_HEIGHT - 30.0f;
    //intro.skipButtonAlignment = EAViewAlignmentRight;
    
    //intro.pageControlY = 42.f;
    [intro.pageControl setHidden:YES];
    
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
    _intro = intro;
}

- (void)removeIntro: (UIButton*)sender{
    [_intro removeFromSuperview];
}

- (void)setLoginForm
{
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    loginController.title = @"Log in";
    UIViewController *signupController = [self.storyboard instantiateViewControllerWithIdentifier:@"signup"];
    signupController.title = @"Sign Up";
    [controllerArray addObject:loginController];
    [controllerArray addObject:signupController];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithHex:COLOR_SECONDARY],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"Roboto-Regular" size:PageMenuOptionMenuItemFont],
                                 CAPSPageMenuOptionMenuHeight: @(PageMenuOptionMenuHeight),
                                 CAPSPageMenuOptionSelectionIndicatorHeight : @(PageMenuOptionSelectionIndicatorHeight),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pagemenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, _TopView.frame.origin.y + _TopView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pagemenu.view];
}

- (void)didTapGoToLeft :(NSNotification *) notification{
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    
    if (currentIndex > 0) {
        [_pagemenu moveToPage:currentIndex - 1];
    }
}

- (void)didTapGoToRight :(NSNotification *) notification{
    NSInteger currentIndex = _pagemenu.currentPageIndex;
    
    if (currentIndex < _pagemenu.controllerArray.count) {
        [_pagemenu moveToPage:currentIndex + 1];
    }
}

- (void)forgotPassword :(NSNotification *) notification{
    UIViewController *forgotController = [self.storyboard instantiateViewControllerWithIdentifier:@"forgotPwd"];
    [self.navigationController pushViewController:forgotController animated:YES];
}

- (void)goHome :(NSNotification *) notification{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sellertab"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loggedOut :(NSNotification *) notification{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    if ([[userInfo objectForKey:KEY_LOGGEDIN] isEqualToString:@"yes"]) {
        [userInfo setObject:@"no" forKey:KEY_LOGGEDIN];
        [self setLoginForm];
    }
}

- (IBAction)Test:(id)sender {
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SignupNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ForgotPwdNotification" object:nil];
//}

@end
