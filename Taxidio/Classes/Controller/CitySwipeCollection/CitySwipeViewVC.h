//
//  CitySwipeViewVC.h
//  Taxidio
//
//  Created by E-Intelligence on 28/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "LXReorderableCollectionViewFlowLayout.h"
#import "CitySwipeCollectionCell.h"
#import "Utilities.h"
#import "CityLocationSwipeVC.h"
#import "singleCity.h"
#import "CountryIdWithCitiesObject.h"
#import "MyTripsVC.h"

@interface CitySwipeViewVC : UIViewController<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
{
    int indexForCountrySelected;
    NSMutableArray *arrCountryData,*arrCountryDataForOptSelected,*arrCityData;
    NSMutableArray *arrData;
    IBOutlet UIView *viewHeader;
    IBOutlet UICollectionView *collectionView;
    IBOutlet UILabel *lblCountryName;
    IBOutlet UITextView *txtCountryDetails;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenwidth;
    NSString *strCountryName,*strCountryDescr;
    IBOutlet UIButton *btnAddCity,*btnSaveChanges;
    IBOutlet UIView *viewCountryScroll;
    IBOutlet UIScrollView *scrollCountryList;
    NSArray *arrCountryListData;
    UIButton *btnCountryName;
    IBOutlet UIImageView *imgViewCoutryImage;
    NSArray *arrDataMultiCountryCityData;
    NSString *strCityList;
    BOOL isFirstTimeSaved;
    
    IBOutlet UIView *viewAddCityView;
    
    IBOutlet UITableView *tblAddCity;
    NSArray *arrAddCityNames;
    NSMutableArray *arrDistanceBetweenCities;
    NSString *strCityIdSelected,*strCityNameSelected,*strCountryId;
    NSString *strLatitudeCitySelected,*strLongitudeCitySelected;

    IBOutlet UIView *ViewAddExtraCityForSearch;
    IBOutlet UIImageView *imgSearchCity;
    IBOutlet UIButton *btnNextCitySearch;
    IBOutlet UIButton *btnPreviousCitySearch;
    IBOutlet UILabel *lblCityNameSearch;
    IBOutlet UILabel *lblCityDaysSearch;
    IBOutlet UIButton *btnAddCitySearch;
    int indexForExtraCityList;
    IBOutlet UIButton *btnNextCity, *btnPreviousCity;
    NSMutableArray *arrDataforCity;
    int repeatCnt;
}

@property(nonatomic)BOOL isSingleSelected,isFromSearchData,isFromEditTrip,isFirstTimeSaved;
@property(nonatomic,retain) NSMutableArray *arrCountryData,*arrCountryDataForOptSelected,*arrDistanceBetweenCities;
@property(nonatomic,retain) NSMutableArray *arrExtraCountryList, *arrEditTripData;
@property(nonatomic,retain) NSMutableArray *arrData;
@property(nonatomic,retain) NSMutableArray *arrAttractionData;
@property(nonatomic,retain) NSString *strCountryName,*strCountryDescr,*strCountryId;
@property(nonatomic,retain) NSMutableDictionary *dictSearchData;
@property(nonatomic,retain) NSString *strLatitudeCitySelected,*strLongitudeCitySelected;
@property(nonatomic,retain)NSString *strCityIdSelected,*strCityNameSelected,*strCitySlugSelected;
@property(nonatomic,retain)NSString *strItineraryIdSelected,*strTripType;

@property(nonatomic,retain) NSMutableDictionary *dictDataFromLocationView;
@property (assign, readwrite, nonatomic) BOOL isFromAttractionListing;

@property (nonatomic, retain) NSMutableArray *arrMultiCountryData;

- (IBAction)pressCloseAddCity:(id)sender;
- (IBAction)pressAddCity:(id)sender;
- (IBAction)pressSaveChanges:(id)sender;
- (IBAction)pressCancelAddCity:(id)sender;

- (IBAction)pressNextCitySearch:(id)sender;
- (IBAction)pressPreviousCitySearch:(id)sender;
- (IBAction)pressAddCitySearch:(id)sender;
- (IBAction)pressAddExtraCity:(id)sender;

@end
