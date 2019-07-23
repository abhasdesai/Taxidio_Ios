//
//  HomeScreenVC.h
//  Taxidio
//
//  Created by E-Intelligence on 07/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "MARKRangeSlider.h"
#import "UIColor+Demo.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "SignInPage.h"
#import "AutocompletionTableView.h"
#import "MultiCountryRecVCViewController.h"
#import "CityLocationSwipeVC.h"
#import "CitySwipeViewVC.h"
#import "BLMultiColorLoader.h"
#import "HMSegmentedControl.h"
#import "DestinationCell.h"

@class AutocompletionTableView;

@interface HomeScreenVC : UIViewController <UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
//    IBOutlet UIButton *btnRecommendation;
//    IBOutlet UIButton *btnSearch;
    IBOutlet UITabBar *tabBar;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *mainView;
    IBOutlet UIView *viewButtons;
    IBOutlet UIScrollView *scrollDestinations;
    IBOutlet UIView *viewStartingPoint;
    IBOutlet UIView *viewDomestic;
    IBOutlet UIView *viewInternational;
    IBOutlet UIView *viewDepartureDate;
    IBOutlet UIView *viewAccType;
    IBOutlet UIView *viewTravelTime;
    IBOutlet UIView *viewNoHrs;
    IBOutlet UIView *viewTemperature;
    IBOutlet UIView *viewBudgetNight;
    IBOutlet UIView *viewSearchTab;
    IBOutlet UIView *viewHeader;
    IBOutlet UITextField *txtStartingPoint;
    IBOutlet UILabel *lblDateDeparture,*lblAccomodationType;
    
    IBOutlet UIView *viewChooseDestinations;

    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    NSMutableArray *arrDestinationSearch,*arrDestination,*arrAccomodation;
    UIButton *btnDestination;
    UILabel *lblDestiName;
    int valTravelTime, valNoDays, ValTemperature, ValBudget;
    
    IBOutlet UIView *viewDatePicker;
    IBOutlet UIView *viewPickerAccomodation;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIPickerView *pickerAccomodation;
    
    IBOutlet UIView *viewRecommendation;
    IBOutlet UIView *viewSearch;
    
//    IBOutlet UIView *borderRecc;
//
//    IBOutlet UIView *borderSearch;
    IBOutlet UITextField *txtDestination;
    IBOutlet UILabel *lblDestiDepDate;
    IBOutlet UIView *MainViewSearch;
    IBOutlet UIScrollView *scrollSearchDesti;
    
    //IBOutlet UISegmentedControl *segmentChooseOpt;
    CALayer *bottomBorder;
    
    IBOutlet UIView *viewSearchDesti;
    IBOutlet UIView *viewSearchDate;
    IBOutlet UIView *viewSearchNoDays;
    
    NSMutableArray *arrNameStartingPoint,*arrNamesDestination;
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    NSString *strCountryCode,*strLocationSelected;
    NSString *strIsDomestic, *strTravelTime, *strNoDays, *strTemperature, *strBudget,*strDateDep,*strAccoType,*strTags;
    NSString *strSearchDate,*strSearchNoDays,*strSearchTags;
    NSMutableArray *arrSelectedTags,*arrSelectedTagsSearch;
    NSMutableDictionary *dictSearchData;
    
    BOOL isFromSearchData;
    IBOutlet UITableView *tblAccomodationType;
    IBOutlet UIButton *btnBeginYourJourney;
    IBOutlet UICollectionView *allcollectionView, *searchCollectionView;
    BOOL isFromSearch,sidebarMenuOpen;
    HMSegmentedControl *segmentedControl1;
}
@property (strong, nonatomic) UIWindow *statusWindow;
@property (nonatomic) NSInteger wsStatus;
@property (strong, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@property (nonatomic, strong) MARKRangeSlider *tempSlider;
@property (nonatomic, strong) UILabel *lblTemperature;

@property (nonatomic, strong) MARKRangeSlider *travelSlider;
@property (nonatomic, strong) UILabel *lblTravelTime;

@property (nonatomic, strong) MARKRangeSlider *budgetSlider;
@property (nonatomic, strong) UILabel *lblbudget;

@property (nonatomic, strong) IBOutlet UISlider *noOfDaysSlider;
@property (nonatomic, strong) IBOutlet UILabel *lblNoOfDays;

@property (nonatomic, strong) IBOutlet UISlider *noOfDaysSliderSearch;
@property (nonatomic, strong) IBOutlet UILabel *lblNoOfDaysSearch;

@property (nonatomic, strong) IBOutlet UISwitch *switchDomestic, *switchInter;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@property (nonatomic,strong) NSMutableArray *arrData;

- (IBAction)pressMenu:(id)sender;
- (IBAction)pressProfileBtn:(id)sender;
- (IBAction)pressRecommendation:(id)sender;
- (IBAction)pressSearchDestination:(id)sender;
- (IBAction)pressBeginJourney:(id)sender;
- (IBAction)setLabel:(UISlider *)sender;
- (IBAction)pressDoneDatePicker:(id)sender;
- (IBAction)pressDonePickerAccomodation:(id)sender;

@end
