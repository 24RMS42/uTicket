//
//  EventDashboardViewController.h
//  UTicket
//
//  Created by matata on 11/29/17.
//  Copyright © 2017 matata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>
#import "UIColor+ColorWithHex.h"
#import "AppDelegate.h"
#import "Functions.h"
#import "Event.h"
#import "CheckStats.h"
#import "MTBBarcodeScanner.h"
#import "AttendeesViewController.h"
#import "UIButton+Extensions.h"

@interface EventDashboardViewController : UIViewController
{
    NSTimer *scanActionTimer;
}
@property (nonatomic, assign) bool listLoaded;
@property (nonatomic,strong) MTBBarcodeScanner *scanner;
@property (nonatomic, assign) BOOL captureIsFrozen;
@property (nonatomic, strong) NSMutableArray *uniqueCodes;

@property (nonatomic,strong) NSString *eventID;
@property (weak, nonatomic) IBOutlet UILabel *EventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *SoldTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel *TicketPriceLabel;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *CheckedProgressBar;

@property (weak, nonatomic) IBOutlet UIView *ScanRoundView;
@property (weak, nonatomic) IBOutlet UIView *ScanOnView;
@property (weak, nonatomic) IBOutlet UIView *BottomMenuContainer;
@property (weak, nonatomic) IBOutlet UIView *CameraView;
@property (weak, nonatomic) IBOutlet UIButton *TorchButton;
@property (weak, nonatomic) IBOutlet UIView *SuccessView;
@property (weak, nonatomic) IBOutlet UIView *FailView;
@property (weak, nonatomic) IBOutlet UIView *ListContainerView;
@property (weak, nonatomic) IBOutlet UIButton *DashboardButton;
@property (weak, nonatomic) IBOutlet UIButton *ListButton;
@property (weak, nonatomic) IBOutlet UILabel *ScanTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel *DashboardLabel;
@property (weak, nonatomic) IBOutlet UILabel *ListLabel;
@property (weak, nonatomic) IBOutlet UILabel *FailMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *TopScanButton;
@property (weak, nonatomic) IBOutlet UIButton *ReOKButton;
@property (weak, nonatomic) IBOutlet UIButton *ReDismissButton;
@property (weak, nonatomic) IBOutlet UIView *ViewOfInterest;

- (IBAction)OnBackClicked:(id)sender;
- (IBAction)OnScanClicked:(id)sender;
- (IBAction)OnTorchClicked:(id)sender;
- (IBAction)OnScanOKClicked:(id)sender;
- (IBAction)OnAttendeesClicked:(id)sender;
- (IBAction)OnListClicked:(id)sender;
- (IBAction)OnDashBoardClicked:(id)sender;
- (IBAction)OnTopScanClicked:(id)sender;

@end
