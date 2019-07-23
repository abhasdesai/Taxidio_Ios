//
//  SOSContactViewController.h
//  Taxidio
//
//  Created by Jitesh Keswani on 03/09/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface SOSContactViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIView *viewCountryCode;
    __weak IBOutlet UITextField *txtName;
    __weak IBOutlet UITextField *txtRelation;

    __weak IBOutlet UITextField *txtCountryCode;
    __weak IBOutlet UITextField *txtPhoneNo;
    __weak IBOutlet UITextField *txtEmailId;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *tblViewCountryCode;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    NSMutableArray *arrCountryData,*arrContactData;
}
@property(nonatomic,retain) NSString *strContactIdSelected;

- (IBAction)pressSave:(id)sender;

@end
