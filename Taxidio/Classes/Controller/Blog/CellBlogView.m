//
//  CellBlogView.m
//  Taxidio
//
//  Created by E-Intelligence on 12/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CellBlogView.h"

@implementation CellBlogView

@synthesize imgView,lblBlogDate,lblBlogTitle,lblBlogSubject,btnShare,btnReadMore,viewBlogView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
