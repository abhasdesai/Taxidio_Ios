//
//  CellReplyToQuestion.h
//  Taxidio
//
//  Created by E-Intelligence on 07/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellReplyToQuestion : UITableViewCell

@property(nonatomic,retain)IBOutlet UITextView *txtQuestion;
@property(nonatomic,retain)IBOutlet UILabel *lblAskedBy;
@property(nonatomic,retain)IBOutlet UILabel *lblDuration;
@property(nonatomic,retain)IBOutlet UIImageView *imgProfile;
@property(nonatomic,retain)IBOutlet UIView *viewBG;
@property(nonatomic,retain)IBOutlet UIButton *btnEditReply, *btnDeleteReply;

@end
