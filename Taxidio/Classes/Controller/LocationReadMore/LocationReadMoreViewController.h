//
//  LocationReadMoreViewController.h
//  Taxidio
//
//  Created by E-Intelligence on 01/08/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface LocationReadMoreViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *viewHeader;
    IBOutlet UILabel *lblLocationTitle;
    
    IBOutlet UIView *viewBody;
    IBOutlet UIImageView *imageViewLocation;
    IBOutlet UITableView *tblLocationDetails;
    NSMutableArray *arrData;
    NSObject *objAttractionData;
}

@property(nonatomic,strong) NSObject *objAttractionData;

- (IBAction)pressBack:(id)sender;



@end
