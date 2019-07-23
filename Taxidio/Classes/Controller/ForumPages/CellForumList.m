//
//  CellForumList.m
//  Taxidio
//
//  Created by E-Intelligence on 30/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CellForumList.h"

@implementation CellForumList

@synthesize viewCellMain,imgProfileImage,lblDuration,lblComment,lblAskedByUser,lblAskedByUserName,lblForumQuestionTitle,btnReply,btnDelete;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
