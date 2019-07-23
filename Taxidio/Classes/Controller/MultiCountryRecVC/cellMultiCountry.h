//
//  cellMultiCountry.h
//  Taxidio
//
//  Created by E-Intelligence on 20/09/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellMultiCountry : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCountry;
@property (strong, nonatomic) IBOutlet UILabel *lblCountryName,*lblRecoTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnView;
@property (strong, nonatomic) IBOutlet UIButton *btnExplore;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIView *viewInnerView;

@end
