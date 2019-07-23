//
//  DestinationCell.h
//  Taxidio
//
//  Created by E-Intelligence on 25/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface DestinationCell : UICollectionViewCell
{
    IBOutlet UIImageView *imgDestination;
    IBOutlet UILabel *lblDestination;
    IBOutlet UIButton *btnViewCities;
    IBOutlet UIView *viewBG;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgDestination;
@property (nonatomic, retain) IBOutlet UILabel *lblDestination;
@property (nonatomic, retain) IBOutlet UIButton *btnViewCities;
@property (nonatomic, retain) IBOutlet UIView *viewBG;

@end
