//
//  CoTravellerDataViewController.h
//  Taxidio
//
//  Created by Jitesh Keswani on 03/10/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import "CoTravellerTableViewCell.h"

@interface CoTravellerDataViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrCoTravellerDetails;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property(nonatomic,retain)    NSMutableArray *arrCoTravellerDetails;

@end
