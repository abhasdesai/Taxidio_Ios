//
//  CoTravellerTableViewCell.h
//  Taxidio
//
//  Created by Jitesh Keswani on 04/10/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoTravellerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDOB;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailId;

@end
