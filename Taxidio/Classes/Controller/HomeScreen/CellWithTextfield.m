//
//  CellWithTextfield.m
//  Taxidio
//
//  Created by E-Intelligence on 07/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CellWithTextfield.h"

@implementation CellWithTextfield

@synthesize txtField,lblTitle,imgView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
