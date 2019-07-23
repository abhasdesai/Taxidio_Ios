//
//  cellSingleCountry.h
//  Taxidio
//
//  Created by E-Intelligence on 20/09/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellSingleCountry : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCountry;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblCountryName;
@property (strong, nonatomic) IBOutlet UIButton *btnView;
@property (strong, nonatomic) IBOutlet UIButton *btnExplore;

@end
