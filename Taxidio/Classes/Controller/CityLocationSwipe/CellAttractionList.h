//
//  CellAttractionList.h
//  Taxidio
//
//  Created by E-Intelligence on 29/01/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellAttractionList : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgViewLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleCityLocation;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewDollar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewStar;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteAdd;
@property (strong, nonatomic) IBOutlet UIView *viewBackGround;
@property (strong, nonatomic) IBOutlet UIImageView *imgNew;

@end
