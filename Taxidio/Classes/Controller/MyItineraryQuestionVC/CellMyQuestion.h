//
//  CellMyQuestion.h
//  Taxidio
//
//  Created by E-Intelligence on 03/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMyQuestion : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@end
