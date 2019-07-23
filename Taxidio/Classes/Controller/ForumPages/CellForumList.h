//
//  CellForumList.h
//  Taxidio
//
//  Created by E-Intelligence on 30/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellForumList : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewCellMain;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *lblForumQuestionTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAskedByUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblAskedByUser;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UIButton *btnReply;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@end
