//
//  PlannedItineraryVC.h
//  Taxidio
//
//  Created by E-Intelligence on 12/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CellLeftItinerary.h"
#import "CellRightItinerary.h"
#import "Utilities.h"
#import "ForumListWithRatingVC.h"

@interface PlannedItineraryVC : UIViewController
{
    IBOutlet UILabel *lblCityName;
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UIView *viewBody;
    IBOutlet UIView *viewHeader;
    IBOutlet UITableView *tblViewItinerary;
    int noOfPage,total_page;
    NSMutableArray *arrCountryNames;
    IBOutlet UIView *viewCityWiseSorting;
    IBOutlet UITableView *tblCountrySort;
    BOOL isSortingDone;
    IBOutlet UIView *viewTripInfo;
    IBOutlet UILabel *lblTripNameInfoView;
    IBOutlet UILabel *lblTripCreatedByName;
    IBOutlet UILabel *lblTripDicussionInfoView;
    IBOutlet UITextView *txtViewDestiDetailsInfoView;
    NSString *strItineraryIdSelected;
    NSString *strTripSelected,*strTripOwnerId;
    NSMutableDictionary *dictData;
    BOOL isLastElement;
    NSString *strCountryIdSelected;
}
@property(nonatomic,retain)NSMutableArray *arrData;
@property(nonatomic,retain)NSString *strItineraryIdSelected;
@property (strong, nonatomic) UIWindow *statusWindow;

- (IBAction)pressUserProfile:(id)sender;
- (IBAction)pressMenuBtn:(id)sender;
- (IBAction)pressCloseInfoView:(id)sender;
-(IBAction)pressShowFilter:(id)sender;

@end
