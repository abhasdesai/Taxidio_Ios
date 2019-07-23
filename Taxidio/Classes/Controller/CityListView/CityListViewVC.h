//
//  CityListViewVC.h
//  Taxidio
//
//  Created by E-Intelligence on 01/08/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import <Mapbox/Mapbox.h>
#import "CellCityListLeft.h"
#import "CellCityListRight.h"
#import "DestinationCell.h"

@interface CityListViewVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
{
    IBOutlet UILabel *lblCountryTitle;
    IBOutlet UILabel *lblTimeTakenToReach;
    IBOutlet UIView *HeaderView;
    
    IBOutlet UIView *MainView;
    NSArray *arrCountryData;
    
    IBOutlet UICollectionView *allcollectionView;
    int noOfSection;
    
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenwidth;

}
@property(nonatomic)BOOL isSingleSelected;
@property(nonatomic,strong) NSString *strTimeToReach;
@property (strong, nonatomic) IBOutlet MGLMapView *mapView;
@property (strong, nonatomic) NSArray *arrCountryData,*arrCityData;;

- (IBAction)pressBack:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@end
