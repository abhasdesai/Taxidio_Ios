//
//  CellRightItinerary.h
//  Taxidio
//
//  Created by E-Intelligence on 12/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
@class HCSStarRatingView;

@interface CellRightItinerary : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lbltripName;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnViewInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblDateDuration;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalDays;
@property (strong, nonatomic) IBOutlet UIButton *btnViewTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnSaved;
@property (assign, nonatomic) IBOutlet HCSStarRatingView *starRatingView;
@property (strong, nonatomic) IBOutlet UIButton *btnViewForum;

@end
