//
//  AttractionListingVC.h
//  Taxidio
//
//  Created by E-Intelligence on 20/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CellLeftAttraction.h"
#import "CellRightAttraction.h"
#import "Utilities.h"

@interface AttractionListingVC : UIViewController
{
    IBOutlet UILabel *lblCityName;

    IBOutlet UIView *viewBody;
    IBOutlet UIView *viewHeader;
    IBOutlet UITableView *tblViewAttractionList;
    NSMutableArray *arrData;
    NSString *strCityName, *strLatitude, *strLongitude;
}
- (IBAction)pressBackBtn:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@property(nonatomic,retain) NSString *strCityName, *strLatitude, *strLongitude;

@end
