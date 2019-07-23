//
//  BlogViewVC.h
//  Taxidio
//
//  Created by E-Intelligence on 12/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "CellBlogView.h"
#import "Utilities.h"
#import "BlogDetailsVC.h"

@interface BlogViewVC : UIViewController
{
    IBOutlet UIView *viewHeader;
    
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewMainView;
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    NSMutableArray *arrData;
    int noOfPage,total_page;
    BOOL isLastElement;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic,retain) NSMutableArray *arrDataSelected;
//- (IBAction)btnReadMore:(id)sender;

@end
