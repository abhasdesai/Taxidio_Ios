//
//  HotelViewVC.h
//  Taxidio
//
//  Created by E-Intelligence on 11/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface HotelViewVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *headerView;
    IBOutlet UITableView *tblView;
    IBOutlet UIView *mainView;
    IBOutlet UIView *viewMapView;
    IBOutlet UIWebView *webviewMap;
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    IBOutlet UILabel *lblCityName;
    int noOfPage,total_page;
    BOOL isLastElement;
}
@property(nonatomic,retain)NSMutableArray *arrData;

@property (nonatomic,assign) IBOutlet UIBarButtonItem* revealButtonItem;
@property(nonatomic,retain) NSString *strCityId, *strCityName, *strCitySlug;

- (IBAction)pressDoneMap:(id)sender;
- (IBAction)pressShowMap:(id)sender;

-(IBAction)pressBackBtn:(id)sender;
@end
