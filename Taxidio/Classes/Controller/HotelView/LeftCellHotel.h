//
//  LeftCellHotel.h
//  Taxidio
//
//  Created by E-Intelligence on 11/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface LeftCellHotel : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblPrice;
@property (retain, nonatomic) IBOutlet UIButton *btnBookNow;
@property (retain, nonatomic) IBOutlet UIButton *btnMap;
@property (retain, nonatomic) IBOutlet UIButton *btnInfo;

@property (retain, nonatomic) IBOutlet UITextView *txtAddress;

@end
