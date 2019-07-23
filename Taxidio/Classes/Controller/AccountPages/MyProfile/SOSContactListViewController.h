//
//  SOSContactListViewController.h
//  Taxidio
//
//  Created by Jitesh Keswani on 03/09/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "SOSContactViewController.h"

@interface SOSContactListViewController : UIViewController
{
    NSMutableArray *arrContactDetails;
    IBOutlet UIButton *btnAddContact;
    IBOutlet UITableView *tblContactDetails;
}

@property(nonatomic,retain) NSString *strContactIdSelected;

@end
