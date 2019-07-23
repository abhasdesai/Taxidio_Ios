//
//  CityLocationSwipeVC.h
//  Taxidio
//
//  Created by E-Intelligence on 28/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "cityLocationCell.h"
#import "Utilities.h"
#import "LocationReadMoreViewController.h"
#import "LocationData.h"
#import "AttractionListingVC.h"
#import "CitySwipeViewVC.h"
#import "HotelViewVC.h"
#import "CellAttractionList.h"
#import "LXReorderableCollectionViewFlowLayout.h"


@protocol PlaceSearchTextFieldDelegate;

static NSString* DequeueReusableCell = @"DequeueReusableCell";
@class I3DragBetweenHelper;

@interface CityLocationSwipeVC : UIViewController<MGLMapViewDelegate,UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate,PlaceSearchTextFieldDelegate,
            LXReorderableCollectionViewDataSource,LXReorderableCollectionViewDelegateFlowLayout>
{
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *MainView;
    IBOutlet UITableView *tblViewLocationListing;
    IBOutlet UIScrollView *scrollView;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    IBOutlet UIView *viewInnerDetails;
    NSMutableArray *arrData;
    IBOutlet UIView *viewAddNewLocation;
    IBOutlet UIView *lblAddNewLocation;
    IBOutlet UITextField *txtNewLocation;
    IBOutlet UILabel *lblLocationTitle;
    NSMutableArray *arrAttractionsList,*arrDataToShow;
    NSMutableArray *arrMapData;
    IBOutlet UILabel *lblCityNameTitle;
    double latOne,LongOne;
    
    IBOutlet UIView *viewAddMore;
    IBOutlet UILabel *lblAttractionName;
    IBOutlet UILabel *lblKnownFor;
    IBOutlet UIButton *btnReadMore;
    IBOutlet UIButton *btnBuyTicket;
    NSString *strCityIdForSelectedLocations;
    IBOutlet UIButton *btnSaveTrip;
    bool isViewAllTapped,isFromSwipe;
    IBOutlet UILabel *lblViewAll;
    IBOutlet UIButton *btnViewAll;
    NSMutableArray *arrViewAllData;
    NSString *strCityCountryId;
    IBOutlet UIView *viewViewAllAddLocation,*viewHotelAttraction;
    IBOutlet UICollectionView *collectionView;
    IBOutlet UIView *viewBottomBar;
    int repeatCnt;
}

@property (nonatomic, strong) I3DragBetweenHelper* helper;
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView* rightTable;
@property (assign, readwrite, nonatomic) BOOL showsUserLocation,isFromSearchData,isFromEditTrip;
@property (nonatomic, strong) NSMutableArray* leftData,*rightData,*arrData;
@property(nonatomic,strong) NSObject *objAttractionDataForReadMore;
@property(nonatomic,strong) NSString *strCityName,*strLongitude,*strLatitude,*strItineraryIdSelected,*strCountryId,*strTripType;
@property(nonatomic,strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong) NSString *strCityId,*strCitySlug;
@property(nonatomic,retain) NSMutableDictionary *dictSearchData;

@property(nonatomic,retain) NSMutableArray *arrDataToGetBack,*arrCountryDataForOptSelectedToGetBack;
@property (assign, readwrite, nonatomic) BOOL isSingleSelectedToGetBack;
@property(nonatomic,retain) NSMutableArray *arrCountryDataForOptSelected;

@property (strong, nonatomic) NSMutableArray *arrCountryData,*arrCityData,*arrMultiCountryData;
@property(nonatomic)BOOL isFirstTimeSaved;

- (IBAction)pressViewRecomm:(id)sender;
- (IBAction)pressAddLocation:(id)sender;
- (IBAction)pressAttractionTicket:(id)sender;
- (IBAction)pressHotellBookings:(id)sender;
- (IBAction)pressDeleteAddRow:(id)sender;
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressSaveTrip:(id)sender;
- (IBAction)pressAddNewLocation:(id)sender;
- (IBAction)pressCancelAddLocation:(id)sender;
- (IBAction)pressReadMore:(id)sender;
- (IBAction)pressBuyTicket:(id)sender;
- (IBAction)pressCloseReadMore:(id)sender;

@end
