//
//  InvitedTripsViewController.h
//  Taxidio
//
//  Created by Jitesh Keswani on 03/10/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import "TripObject.h"
#import "CitySwipeViewVC.h"
#import "CityLocationSwipeVC.h"
#import "CoTravellerDataViewController.h"

@interface InvitedTripsViewController : UIViewController
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewMainView;
    IBOutlet UIView *viewForTable;
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewEditTripDetails;
    IBOutlet UIView *viewEditTripMain;
    IBOutlet UITextField *txtEditTripName;
    IBOutlet UILabel *lblEditTripStartDate;
    IBOutlet UILabel *lblEditTripEndDate;
    IBOutlet UILabel *lblEditTripTitle;
    BOOL isPrivate;
    IBOutlet UIButton *btnPrivate, *btnPublic;
    IBOutlet UIButton *btnDone;
    UIDatePicker *datePicker;
    UIView *viewDate;
    IBOutlet UIView *viewDialogTripDetailsSelected;
    IBOutlet UILabel *lblTripNameEdit;
    IBOutlet UIScrollView *scrollCityListEdit;
    IBOutlet UILabel *lblDateEdit;
    int noOfPage,total_page;
    NSString *strEditTripId;
    NSMutableDictionary *dictData;
    BOOL isFromSearchData;
    IBOutlet UITextView *txtComment;
    IBOutlet UIView *viewNoRecords;
    IBOutlet UILabel *lblNoRecords;
    BOOL isLastElement;
    UIRefreshControl *refreshController;
    NSMutableArray *arrCoTravellerDetails;
}

@property(nonatomic,retain)NSMutableArray *arrData;
@property(nonatomic,retain)NSMutableArray *arrUpcomingTrips,*arrCurrentTrips,*arrCompletedTrips;
@property(nonatomic,retain)NSString *strItineraryIdSelected;

- (IBAction) pressUserProfile:(id)sender;
- (IBAction) pressMenuBtn:(id)sender;
- (IBAction) btnCancelEditTrip:(id)sender;
- (IBAction) btnSaveEditTrip:(id)sender;

@end
