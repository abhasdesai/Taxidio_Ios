//
//  CellMyTrips.h
//  Taxidio
//
//  Created by E-Intelligence on 14/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMyTrips : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTripTitle;
@property (strong, nonatomic) IBOutlet UIView *scrollCityNames;
@property (strong, nonatomic) IBOutlet UIView *imgViewLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblDateToFrom;
@property (strong, nonatomic) IBOutlet UIView *viewBorder;

@end
