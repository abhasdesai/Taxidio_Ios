//
//  MyProfileVC.h
//  Taxidio
//
//  Created by E-Intelligence on 17/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Helper.h"
#import "Utilities.h"
#import "HomeScreenVC.h"
#import "GKImagePicker.h"

@interface MyProfileVC : UIViewController 
{
    IBOutlet UITableView *tblViewCountryList, *tblViewTagList;
    IBOutlet UIView *viewCountryList,*viewTagList;
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UITextField *txtPhoneNo;
    IBOutlet UIView *viewTxtPassport;
    IBOutlet UIView *viewMaleFemale;
    IBOutlet UIView *viewPhoneNo;
    IBOutlet UIView *viewDOB;
    IBOutlet UIView *viewCountry;
    IBOutlet UIView *viewTxtEmail;
    IBOutlet UIView *viewTxtName;
    IBOutlet UIView *viewTextData;
    IBOutlet UIView *viewMainView;
    IBOutlet UIView *viewHeader;
    IBOutlet UIButton *btnMale;
    IBOutlet UIButton *btnFemale;
    IBOutlet UIImageView *imgMale;
    IBOutlet UIImageView *imgFemale;

    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtEmailID;
    IBOutlet UITextField *txtDOB;
    IBOutlet UITextField *txtPassportNo;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *lblCountryNameSelected;
    CGRect screenRect;
    CGFloat screenHeight;
    IBOutlet UIButton *btnDone;
    UIDatePicker *datePicker;
    UIView *viewDate;
    NSMutableArray *arrCountryNames;
    IBOutlet UIImageView *imgProfileImage;
    BOOL isMale,isTagTbl;
    NSString *strCountryId;
    NSString *strIsSocial;
    IBOutlet UIButton *btnCamera;
    NSString *strBDate,*strTagIDs,*strTagName;
    NSMutableArray *arrTagData,*arrTemp;
    NSInteger cntSOSContacts;
}
@property (strong, nonatomic) NSMutableDictionary *ParametersEditData;
@property (strong, nonatomic) NSDictionary *Parameters;
- (IBAction)pressMenu:(id)sender;
- (IBAction)pressProfileBtn:(id)sender;
- (IBAction)pressSelectCountry:(id)sender;
- (IBAction)pressCamera:(id)sender;
-(IBAction)pressCancelCountrySelection:(id)sender;
@end
