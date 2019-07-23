//
//  MyItineraryQuestionVC.h
//  Taxidio
//
//  Created by E-Intelligence on 03/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import "CellMyQuestion.h"
#import "ReplyToForumPageVCViewController.h"

@interface MyItineraryQuestionVC : UIViewController
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    NSMutableDictionary *dictData;
    IBOutlet UIWebView *webviewPolicy;
    IBOutlet UITableView *tblView;
    int noOfPage,total_page;
    NSObject *objForReply;
    IBOutlet UIView *viewNoRecords;
    IBOutlet UILabel *lblNoRecords;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property(nonatomic,retain) NSMutableArray *arrData;
@property(nonatomic,retain) NSObject *objForReply;

- (IBAction)pressMenu:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@end
