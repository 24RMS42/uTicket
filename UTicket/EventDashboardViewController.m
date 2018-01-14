//
//  EventDashboardViewController.m
//  UTicket
//
//  Created by matata on 11/29/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import "EventDashboardViewController.h"

@interface EventDashboardViewController ()

@end

@implementation EventDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1];
    [Functions configureButton:button];
    
    [Functions makeRoundShadowView:_ScanRoundView];
    [Functions makeShadowLabel:_SoldTicketLabel];
    [Functions makeShadowLabel:_TicketPriceLabel];
    
    _ScanOnView.layer.cornerRadius = _ScanOnView.frame.size.width/2;
    _ScanOnView.layer.masksToBounds = YES;
    
    [_DashboardButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [_ListButton      setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    [self updateData];
}

- (void)updateData
{
    NSInteger count = [appDelegate.GEventArray count];
    for (NSInteger i = count - 1; i >= 0; i--) {
        
        Event *itemObj = [appDelegate.GEventArray objectAtIndex:i];
        if ([itemObj.eventId isEqualToString:_eventID]) {
            _EventNameLabel.text = itemObj.name;
            _SoldTicketLabel.text = itemObj.sold;
            
            if ([itemObj.checkinStats count] != 0) {
                CheckStats *statsObj = [itemObj.checkinStats objectAtIndex:0];
                if (statsObj.sold_count.intValue == 0) {
                    _CheckedProgressBar.value = 0;
                }
                else
                {
                    CGFloat s = (CGFloat)statsObj.checked_in_count.intValue / statsObj.sold_count.intValue * 100;
                    _CheckedProgressBar.value = s;
                }
            }
            
            Ticket *ticketObj = [itemObj.tickets objectAtIndex:0];
            _TicketPriceLabel.text = [NSString stringWithFormat:@"€%@", ticketObj.base_price];
            
            break;
        }
    }
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];
    
    CGRect newFrame = content.view.frame;
    newFrame.size.height = self.ListContainerView.frame.size.height;
    [content.view setFrame:newFrame];
    
    [self.ListContainerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.scanner isScanning])
        [self stopScanning];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnScanClicked:(id)sender {
    [_DashboardButton setBackgroundImage:[UIImage imageNamed:@"analytics.png"] forState:UIControlStateNormal];
    [_DashboardLabel setTextColor:[UIColor blackColor]];
    
    [self.CameraView setHidden:NO];
    [self.ScanOnView setHidden:NO];
    [self.TorchButton setHidden:NO];
    
    if ([self.scanner isScanning] || self.captureIsFrozen) {
        [self stopScanning];
    } else {
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                [self startScanning];
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    }
}

- (IBAction)OnTorchClicked:(id)sender {
    
    if (self.scanner.torchMode == MTBTorchModeOff) {
        self.scanner.torchMode = MTBTorchModeOn;
        [_TorchButton setBackgroundImage:[UIImage imageNamed:@"flash.png"] forState:UIControlStateNormal];
    } else {
        self.scanner.torchMode = MTBTorchModeOff;
        [_TorchButton setBackgroundImage:[UIImage imageNamed:@"flash_inactive.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)OnScanOKClicked:(id)sender {
    //[self startScanning];
    self.uniqueCodes = [[NSMutableArray alloc] init];
    [self.SuccessView setHidden:YES];
    [self.FailView setHidden:YES];
}

- (IBAction)OnAttendeesClicked:(id)sender {
    [_TopScanButton setHidden:NO];
    [self.ListContainerView setHidden:NO];
    [_DashboardButton setBackgroundImage:[UIImage imageNamed:@"analytics.png"] forState:UIControlStateNormal];
    [_ListButton setBackgroundImage:[UIImage imageNamed:@"list_select.png"] forState:UIControlStateNormal];
    [_DashboardLabel setTextColor:[UIColor blackColor]];
    [_ListLabel setTextColor:[UIColor colorWithHex:COLOR_PRIMARY]];
    [_ScanTicketLabel setHidden:YES];
    [_ScanRoundView setHidden:YES];
    
    if (self.listLoaded == NO) {
        AttendeesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"attendees"];
        controller.eventID = _eventID;
        [self displayContentController:controller];
        self.listLoaded = YES;
    }
}

- (IBAction)OnListClicked:(id)sender {

    [self removeCameraView];
    [self OnAttendeesClicked:nil];
}

- (IBAction)OnDashBoardClicked:(id)sender {
    [_DashboardButton setBackgroundImage:[UIImage imageNamed:@"analytics_select.png"] forState:UIControlStateNormal];
    [_ListButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [_DashboardLabel setTextColor:[UIColor colorWithHex:COLOR_PRIMARY]];
    [_ListLabel setTextColor:[UIColor blackColor]];
    [_ScanTicketLabel setHidden:NO];
    [_ScanRoundView setHidden:NO];
    [self.ListContainerView setHidden:YES];
    [_TopScanButton setHidden:YES];
    [self removeCameraView];
    
    [self updateData];
}

- (IBAction)OnTopScanClicked:(id)sender {
    [self.ListContainerView setHidden:YES];
    [_TopScanButton setHidden:YES];
    [_ListButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [_ListLabel setTextColor:[UIColor blackColor]];
    [self OnScanClicked:nil];
}

- (void)removeCameraView
{
    [self.CameraView setHidden:YES];
    [self.ScanOnView setHidden:YES];
    [self.TorchButton setHidden:YES];
    [self.SuccessView setHidden:YES];
    [self.FailView setHidden:YES];
    if ([self.scanner isScanning])
        [self stopScanning];
}

- (void)removeResultView
{
    [_SuccessView setHidden:YES];
    [_FailView setHidden:YES];
    [_ReOKButton setHidden:NO];
    [_ReDismissButton setHidden:NO];
    
    self.uniqueCodes = [[NSMutableArray alloc] init];
}

- (void)startTimer
{
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(removeResultView)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)actionScan: (NSString*)code{
    
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSDictionary * parameters=@{@"ticket":code};
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_URL, EVENT_QRSCAN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"qr scan result:%@", responseObject);
        [SVProgressHUD dismiss];
        int success = [[responseObject valueForKey:@"success"] intValue];
        
        if (success == 1) {
            [self.SuccessView setHidden:NO];
            
            if ([[userInfo objectForKey:KEY_QR_SCAN] isEqualToString:@"Fast"]) {
                [_ReOKButton setHidden:YES];
                [self startTimer];
            }
        }
        else
        {
            NSString *failMsg = @"This ticket has been checked in already";
            _FailMsgLabel.text = failMsg;
            [self.FailView setHidden:NO];
            
            if ([[userInfo objectForKey:KEY_QR_SCAN] isEqualToString:@"Fast"]) {
                [_ReDismissButton setHidden:YES];
                [self startTimer];
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSString *failMsg = @"An error occurred. Please try scanning the ticket again";
        _FailMsgLabel.text = failMsg;
        [self.FailView setHidden:NO];
    }];
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.CameraView];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
    self.uniqueCodes = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                NSLog(@"qr result: %@", code.stringValue);
                [self.uniqueCodes addObject:code.stringValue];
                NSArray *scanResult = [code.stringValue componentsSeparatedByString:@"ticket/"];
                //[self stopScanning];
                
                if ([scanResult count] > 1) {
                    [self actionScan:scanResult[1]];
                }
                else
                {
                    NSString *failMsg = @"We do not have a ticket that matches this qr code";
                    _FailMsgLabel.text = failMsg;
                    [self.FailView setHidden:NO];
                }
            }
        }
    } error:&error];
    
    if (error) {
        NSLog(@"An error occurred: %@", error.localizedDescription);
        NSString *failMsg = @"An error occurred. Please try scanning the ticket again";
        _FailMsgLabel.text = failMsg;
        [self.FailView setHidden:NO];
    }
    
}

- (void)stopScanning {
    [self.scanner stopScanning];
    self.captureIsFrozen = NO;
}

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
    } else {
        message = @"An unknown error occurred.";
    }
    
    [Functions showAlert:@"" message:message];
}
@end
