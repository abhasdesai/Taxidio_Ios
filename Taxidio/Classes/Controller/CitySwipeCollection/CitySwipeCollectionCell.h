//
//  CitySwipeCollectionCell.h
//  Taxidio
//
//  Created by E-Intelligence on 28/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface CitySwipeCollectionCell : UICollectionViewCell

//@property (strong, nonatomic) PlayingCard *playingCard;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnExploreCity;
@property (strong, nonatomic) IBOutlet UILabel *lblSortOrder;
@property (strong, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewPlane;

@end
