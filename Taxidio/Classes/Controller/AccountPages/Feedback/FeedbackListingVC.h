//
//  FeedbackListingVC.h
//  Taxidio
//
//  Created by E-Intelligence on 20/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface FeedbackListingVC : UIViewController
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewMainView;
    IBOutlet UIView *viewForTable;
    IBOutlet UITableView *tblView;
    int noOfPage,total_page;
    IBOutlet UILabel *lblSubjectView;
    IBOutlet UIWebView *webviewFeedbackView;
    IBOutlet UIView *viewFeedbackPreview;
}

@property(nonatomic,retain)NSMutableArray *arrData;

- (IBAction)pressMenuBtn:(id)sender;
- (IBAction)pressCloseFeedbackView:(id)sender;

@end
