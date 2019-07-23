//
//  FAQsViewController.h
//  Taxidio
//
//  Created by E-Intelligence on 14/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

#import "Utilities.h"

@interface FAQsViewController : UIViewController
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewTitle;
    
    IBOutlet UIView *viewMainView;
    IBOutlet UIView *viewDetailview;
    IBOutlet JNExpandableTableView *tblView;
    NSMutableArray *arrHeader;
    
    NSMutableArray *cellSubArray,*cellSubArray1;
    
    BOOL isSection0Cell0Expanded;
    UITextView *txtViewCellDescr;
    NSMutableDictionary *dictData;
}

@property(nonatomic,retain)    NSMutableArray *cellAnswers,*cellQuestions;
- (IBAction)pressMenu:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@end
