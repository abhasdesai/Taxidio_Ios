//
//  ReplyToForumPageVCViewController.h
//  Taxidio
//
//  Created by E-Intelligence on 07/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import "CellReplyToQuestion.h"

@interface ReplyToForumPageVCViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIImageView *imgView;
    IBOutlet UITextView *txtQuestionTitle;
    IBOutlet UILabel *lblAskedBy;
    IBOutlet UILabel *lblDuration;
    IBOutlet UITextView *txtReplyToSend;
    IBOutlet UIView *viewMain, *viewMessage;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    IBOutlet UIView *viewBody;
}

@property(nonatomic,retain) NSMutableArray *arrData;
@property(nonatomic,retain) NSString *strItineraryId;
@property (strong, nonatomic) NSObject *objForReply;
@property (strong, nonatomic) UIWindow *statusWindow;

- (IBAction)pressBack:(id)sender;
- (IBAction)pressSendReply:(id)sender;

@end
