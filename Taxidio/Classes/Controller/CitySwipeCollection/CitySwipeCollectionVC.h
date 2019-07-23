//
//  CitySwipeCollectionVC.h
//  Taxidio
//
//  Created by E-Intelligence on 27/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"

#define NUMBER_ITEMS_ON_LOAD 250
#define NUMBER_ITEMS_ON_LOAD2 30


@interface CitySwipeCollectionVC : UIViewController <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewMain;
    
    IBOutlet UILabel *lblCountryName;
    GMGridView *_gmGridView;
//    UINavigationController *_optionsNav;
//    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
     NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
}

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;
- (IBAction)pressUserProfile:(id)sender;
- (IBAction)pressBack:(id)sender;
@end
