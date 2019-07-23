//
//  DestinationListingVC.h
//  Taxidio
//
//  Created by E-Intelligence on 25/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationCell.h"
#import "Utilities.h"

@interface DestinationListingVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *arrDestinationData;
    
    IBOutlet UICollectionView *allcollectionView;
    int noOfSection;
    
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenwidth;

    IBOutlet UILabel *lblCountryName;
    IBOutlet UITableView *tblViewCityListing;
    IBOutlet UIView *viewCityListing;
    NSMutableArray *arrCityNames;
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UIScrollView *scrollCityName;
    IBOutlet UIView *viewDialog;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

- (IBAction)pressCloseDialog:(id)sender;
@end
