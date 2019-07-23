//
//  CellBlogView.h
//  Taxidio
//
//  Created by E-Intelligence on 12/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface CellBlogView : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblBlogSubject;
@property (strong, nonatomic) IBOutlet UILabel *lblBlogTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblBlogDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBlogDescr;
@property (strong, nonatomic) IBOutlet UIButton *btnReadMore;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIView *viewBlogView;

@end
