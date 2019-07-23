//
//  CellLeftAttraction.h
//  Taxidio
//
//  Created by E-Intelligence on 01/08/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
@class HCSStarRatingView;

@interface CellLeftAttraction : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblAttractionName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnBookNow;
@property (strong, nonatomic) IBOutlet UIButton *btnViewInfo;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewStarRating;
@property (strong, nonatomic) IBOutlet UILabel *lblUserReviews;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;
@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (assign, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@end
