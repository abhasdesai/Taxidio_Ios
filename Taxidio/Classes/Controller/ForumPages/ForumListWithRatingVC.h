//
//  ForumListWithRatingVC.h
//  Taxidio
//
//  Created by E-Intelligence on 30/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellForumList.h"
#import "Utilities.h"
#import "ReplyToForumPageVCViewController.h"

@class HCSStarRatingView;

@interface ForumListWithRatingVC : UIViewController <UITextViewDelegate>
{
    IBOutlet UILabel *lblTripName;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewMain;
    IBOutlet UIView *viewRatings;
    IBOutlet HCSStarRatingView *starRatings;
    IBOutlet UIView *viewForumList;
    IBOutlet UITableView *tblViewForumList;
    NSMutableArray *arrData;
    int noOfPage,total_page;
    float intStarRating;
    IBOutlet UITextView *txtMessage;
    IBOutlet UIView *viewMessage;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@property (strong, nonatomic) NSString *strItineraryId,*strTripSelected,*strTripOwnerId;
@property (strong, nonatomic) IBOutlet UIButton *pressBack;
@property (strong, nonatomic) NSObject *objForReply;
- (IBAction)pressBack:(id)sender;
- (IBAction)pressSubmitRatings:(id)sender;
- (IBAction)pressSendMessage:(id)sender;
@end
