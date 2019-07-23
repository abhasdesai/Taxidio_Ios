//
//  SingleMultiListViewVC.h
//  Taxidio
//
//  Created by E-Intelligence on 10/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import "cellSingleCountry.h"
#import "cellMultiCountry.h"
#import "CityListViewVC.h"
#import "CitySwipeViewVC.h"
#import "BLMultiColorLoader.h"

@interface SingleMultiListViewVC : UIViewController
{
    IBOutlet UIView *viewHeader;
    int index;
    int lastIndexPath,firstIndexParh;
    int isLastIndexPath,isFirstIndexPath;
    IBOutlet UITableView *tblView,*tblMultiCountryView;
    IBOutlet UIView *viewMain,*viewMainMultiCountry;
    
    IBOutlet UIView *viewTab;
    
    IBOutlet UISegmentedControl *segmentSingleMulti;
    IBOutlet UIView *borderSingle;
    IBOutlet UIView *borderMulti;
    CALayer *bottomBorder;
    NSMutableDictionary *dictSignleCountryData,*dictMultiCountryData;
    NSArray *arrDataSingleCountry,*arrDataMultiCountry;
    BOOL isSingleSelected;
    BOOL isNext,isPrevious;
    NSString *strInfo;
    NSString *strMultiTimeToReach;
    NSInteger intLastIndex, intFirstIndex;
    IBOutlet UIView *viewNoSingleCountryData, *viewNoMultiCountryData;
    IBOutlet UIButton *btnNoSingleData, *btnNoMultiData;
    IBOutlet UILabel *lblNoSingleData, *lblNoMultiData;
    int repeatCnt;
}

@property (assign, readwrite, nonatomic) BOOL isTableReloaded;

@property (weak, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

@property(nonatomic,strong)NSArray *arrDataSingleCountry,*arrDataMultiCountry,*arrDataMultiCountryCityData;
@property(nonatomic,strong)NSMutableArray *arrDataForCountrySelected,*arrCountryDataForOptSelected;
@property(nonatomic,strong)NSString *strCountryName,*strInfo;

- (IBAction)selectSegmentControl:(id)sender;

@end

